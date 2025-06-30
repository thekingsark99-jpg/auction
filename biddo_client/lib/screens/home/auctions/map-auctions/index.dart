import 'dart:async';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/controllers/auction.dart';
import '../../../../core/controllers/location.dart';
import '../../../../core/controllers/map_auctions.dart';
import '../../../../core/controllers/maps.dart';
import '../../../../core/controllers/settings.dart';
import '../../../../core/models/auction_map_data.dart';
import '../../../../theme/extensions/base.dart';
import '../../../../widgets/back_gesture_wrapper.dart';
import 'utils.dart';
import 'widgets/bottom_sheet_auctions.dart';
import 'widgets/category_select_dropdown.dart';
import 'widgets/location_searchbar.dart';

class Cluster {
  List<AuctionMapData> items = [];
  LatLng center = LatLng(0, 0);

  void add(AuctionMapData auction) {
    items.add(auction);
    double sumLat = 0;
    double sumLng = 0;
    for (var p in items) {
      sumLat += p.locationLat;
      sumLng += p.locationLng;
    }
    center = LatLng(sumLat / items.length, sumLng / items.length);
  }
}

class MapAuctionsScreen extends StatefulWidget {
  final LatLng? initialPosition;

  const MapAuctionsScreen({
    super.key,
    this.initialPosition,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MapAuctionsScreenState createState() => _MapAuctionsScreenState();
}

class _MapAuctionsScreenState extends State<MapAuctionsScreen> {
  final auctionsController = Get.find<AuctionController>();
  final mapsController = Get.find<MapsController>();
  final mapAuctionsController = Get.find<MapAuctionsController>();
  final settingsController = Get.find<SettingsController>();
  final locationController = Get.find<LocationController>();

  late GoogleMapController _mapController;
  late StreamSubscription<String> _categoryListener;

  final Map<String, BitmapDescriptor> _markerIconCache = {};
  late CameraPosition _initialCameraPos = CameraPosition(
    target: mapAuctionsController.currentMapPosition.value,
    zoom: 14.0,
  );

  List<AuctionMapData> _allAuctions = [];
  List<AuctionMapData> _filteredAuctions = [];
  Set<Marker> _markers = {};
  double _currentZoom = 14;

  @override
  void initState() {
    super.initState();
    _loadAuctionsForMap();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _categoryListener =
          mapAuctionsController.categoryToDisplayOnMap.listen((category) async {
        await _filterAuctionsForMap();
      });
    });

    if (widget.initialPosition != null) {
      _initialCameraPos = CameraPosition(
        target: widget.initialPosition!,
        zoom: 8,
      );
    } else {
      if (locationController.latLng.value != null) {
        _initialCameraPos = CameraPosition(
          target: locationController.latLng.value!,
          zoom: 14.0,
        );
      }
    }
  }

  @override
  void dispose() {
    _categoryListener.cancel();
    super.dispose();
  }

  Future<void> _loadAuctionsForMap() async {
    var auctions = await auctionsController.loadAuctionsForMap();
    setState(() {
      _allAuctions = auctions;
    });

    _filterAuctionsForMap();
  }

  Future<void> _filterAuctionsForMap() async {
    var category = mapAuctionsController.categoryToDisplayOnMap.value;
    if (category == '' || category.toLowerCase() == 'all') {
      setState(() {
        _filteredAuctions = _allAuctions;
      });

      _updateClusters();
      return;
    }

    var filteredAuctions = _allAuctions.where((auction) {
      return auction.meta?.mainCategoryId == category;
    });

    setState(() {
      _filteredAuctions = filteredAuctions.toList();
    });
    _updateClusters();
  }

  void _openBottomSheet(List<String> auctionIds) async {
    if (auctionIds.isEmpty) {
      return;
    }

    var summaries = await auctionsController.getManySummary(auctionIds);

    showModalBottomSheet(
      backgroundColor:
          // ignore: use_build_context_synchronously
          Theme.of(context).extension<CustomThemeFields>()!.background_1,
      // ignore: use_build_context_synchronously
      context: context,
      builder: (context) {
        return SafeArea(
          child: Container(
            color:
                Theme.of(context).extension<CustomThemeFields>()!.background_1,
            child: Wrap(
              children: [
                MapBottomSheetAuctions(auctions: summaries),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleMapCreate(GoogleMapController controller) async {
    _mapController = controller;
    _filterAuctionsForMap();

    if (locationController.latLng.value != null) {
      return;
    }

    if (widget.initialPosition != null) {
      return;
    }

    try {
      var pos = await getGeoLocationPosition();
      var latLong = LatLng(pos.latitude, pos.longitude);

      setState(() {
        _initialCameraPos = CameraPosition(target: latLong, zoom: 14.0);
      });
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> _updateClusters() async {
    Set<Marker> markers = await _getMarkersForClusters(_currentZoom);
    setState(() {
      _markers = markers;
    });
  }

  void _handleClusterTap(Cluster cluster) {
    if (_currentZoom < 14) {
      _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(cluster.center, _currentZoom + 2),
      );
    }
    if (_currentZoom < 8) {
      return;
    }
    _openBottomSheet(
      cluster.items.map((e) => e.id).toList(),
    );
  }

  void _handleSimpleMarkerTap(Cluster cluster) {
    if (_currentZoom < 16) {
      _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(cluster.center, _currentZoom + 2),
      );
    }

    _openBottomSheet(
      [cluster.items[0].id],
    );
  }

  Future<Set<Marker>> _getMarkersForClusters(double zoom) async {
    // Define a grouping threshold (in meters). Adjust the formula as needed.
    double threshold = zoom >= 18 ? 1 : (18 - zoom) * 50;

    List<Cluster> clusters = [];
    for (var auction in _filteredAuctions) {
      bool added = false;
      LatLng auctionLatLng = LatLng(auction.locationLat, auction.locationLng);
      for (var cluster in clusters) {
        double dist = distanceBetween(auctionLatLng, cluster.center);
        if (dist < threshold) {
          cluster.add(auction);
          added = true;
          break;
        }
      }
      if (!added) {
        Cluster newCluster = Cluster();
        newCluster.add(auction);
        clusters.add(newCluster);
      }
    }

    Set<Marker> markers = {};
    for (var cluster in clusters) {
      if (cluster.items.length == 1) {
        AuctionMapData auction = cluster.items.first;
        BitmapDescriptor? icon = await _getCustomMarkerIcon(auction);
        if (icon == null) {
          continue;
        }

        Marker marker = Marker(
          markerId:
              MarkerId('marker_${auction.locationLat}_${auction.locationLng}'),
          position: LatLng(auction.locationLat, auction.locationLng),
          icon: icon,
          onTap: () {
            _handleSimpleMarkerTap(cluster);
          },
        );

        markers.add(marker);
        continue;
      }

      BitmapDescriptor icon = await _getClusterMarkerIcon(cluster.items.length);
      Marker marker = Marker(
        markerId: MarkerId(
            'cluster_${cluster.center.latitude}_${cluster.center.longitude}'),
        position: cluster.center,
        icon: icon,
        onTap: () {
          _handleClusterTap(cluster);
        },
      );
      markers.add(marker);
    }

    return markers;
  }

  Future<BitmapDescriptor?> _getCustomMarkerIcon(AuctionMapData auction) async {
    try {
      var serverBaseUrl = FlutterConfig.get('SERVER_URL');
      String url =
          auction.meta?.assetPath != null && auction.meta!.assetPath.isNotEmpty
              ? '$serverBaseUrl/assets/${auction.meta!.assetPath}'
              : settingsController.settings.value.defaultProductImageUrl;

      if (_markerIconCache.containsKey(url)) {
        return _markerIconCache[url]!;
      }

      const double markerWidth = 130;
      const double markerHeight = 150;
      const double padding = 8;

      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder);

      final Rect rect = Rect.fromLTWH(0, 0, markerWidth, markerHeight);
      final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(12));
      final Paint rectPaint = Paint()
        ..color = Theme.of(context).extension<CustomThemeFields>()!.action;
      canvas.drawRRect(rrect, rectPaint);

      final Paint borderPaint = Paint()
        ..color = Theme.of(context).extension<CustomThemeFields>()!.separator
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4;
      canvas.drawRRect(rrect, borderPaint);

      final Rect innerRect = Rect.fromLTWH(
        padding,
        padding,
        markerWidth - 2 * padding,
        markerHeight - 2 * padding,
      );

      Uint8List networkBytes;
      try {
        networkBytes = await getBytesFromNetwork(url);
      } catch (e) {
        final ByteData assetData =
            await rootBundle.load('assets/default_marker.png');
        networkBytes = assetData.buffer.asUint8List();
      }

      ui.Codec codec = await ui.instantiateImageCodec(
        networkBytes,
        targetWidth: innerRect.width.toInt(),
        targetHeight: innerRect.height.toInt(),
      );
      ui.FrameInfo fi = await codec.getNextFrame();
      ui.Image networkImage = fi.image;

      final Rect srcRect = Rect.fromLTWH(
        0,
        0,
        networkImage.width.toDouble(),
        networkImage.height.toDouble(),
      );

      canvas.drawImageRect(networkImage, srcRect, innerRect, Paint());

      ui.Image finalImage = await recorder
          .endRecording()
          .toImage(markerWidth.toInt(), markerHeight.toInt());
      ByteData? byteData =
          await finalImage.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List bytes = byteData!.buffer.asUint8List();

      final BitmapDescriptor descriptor = BitmapDescriptor.fromBytes(bytes);
      _markerIconCache[url] = descriptor;
      return descriptor;
    } catch (error) {
      return null;
    }
  }

  Future<BitmapDescriptor> _getClusterMarkerIcon(int count) async {
    const double width = 150;
    const double height = 170;
    const double gap = 12;

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    final Rect rect = Rect.fromLTWH(0, 0, width, height);
    final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(12));
    final Paint rectPaint = Paint()
      ..color = Theme.of(context).extension<CustomThemeFields>()!.action;
    canvas.drawRRect(rrect, rectPaint);

    bool isRTL = Directionality.of(context)
        .toString()
        .contains(TextDirection.RTL.value.toLowerCase());

    final TextPainter countPainter = TextPainter(
      text: TextSpan(
        text: "$count",
        style: Theme.of(context)
            .extension<CustomThemeFields>()!
            .title
            .copyWith(fontSize: 45),
      ),
      textAlign: TextAlign.center,
      textDirection: isRTL ? ui.TextDirection.rtl : ui.TextDirection.ltr,
    );
    countPainter.layout(maxWidth: width);

    final TextPainter auctionsPainter = TextPainter(
      text: TextSpan(
        text: tr("home.auctions.auctions"),
        style: Theme.of(context)
            .extension<CustomThemeFields>()!
            .title
            .copyWith(fontSize: 34),
      ),
      textAlign: TextAlign.center,
      textDirection: isRTL ? ui.TextDirection.rtl : ui.TextDirection.ltr,
    );
    auctionsPainter.layout(maxWidth: width);

    final double totalTextHeight =
        countPainter.height + gap + auctionsPainter.height;

    final double startY = (height - totalTextHeight) / 2;
    final double countX = (width - countPainter.width) / 2;
    countPainter.paint(canvas, Offset(countX, startY));

    final double auctionsX = (width - auctionsPainter.width) / 2;
    final double auctionsY = startY + countPainter.height + gap;
    auctionsPainter.paint(canvas, Offset(auctionsX, auctionsY));

    final ui.Image image =
        await recorder.endRecording().toImage(width.toInt(), height.toInt());
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List bytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(bytes);
  }

  void _animateCameraToLocation(LatLng latLng) {
    mapAuctionsController.updateCurrentMapPosition(latLng);

    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 14),
      ),
    );
  }

  Widget _renderGoogleMap() {
    return GoogleMap(
      initialCameraPosition: _initialCameraPos,
      style: Get.isDarkMode
          ? mapsController.darkMapStyle.value
          : mapsController.lightMapStyle.value,
      markers: _markers,
      onMapCreated: (GoogleMapController controller) {
        _handleMapCreate(controller);
      },
      onCameraMove: (position) {
        _currentZoom = position.zoom;
      },
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      zoomGesturesEnabled: true,
      mapToolbarEnabled: false,
      scrollGesturesEnabled: true,
      myLocationButtonEnabled: true,
      compassEnabled: true,
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        Factory<OneSequenceGestureRecognizer>(
          () => EagerGestureRecognizer(),
        ),
      },
      onCameraIdle: () {
        _updateClusters();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackGestureWrapper(
      child: Scaffold(
        backgroundColor:
            Theme.of(context).extension<CustomThemeFields>()!.background_1,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              _renderGoogleMap(),
              Positioned(
                top: 16,
                left: 0,
                child: SizedBox(
                  width: Get.width,
                  child: ListView.builder(
                    key: UniqueKey(),
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: Get.width,
                        height: 108,
                        child: Column(
                          children: [
                            MapAuctionsLocationSearchbar(
                              handleSelectPrediction: (location) {
                                _animateCameraToLocation(location);
                              },
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: MapAuctionsCategorySelectDropdown(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
