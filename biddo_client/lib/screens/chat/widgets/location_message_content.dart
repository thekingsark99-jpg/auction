import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/models/chat_message.dart';
import '../../../core/navigator.dart';
import '../../create-auction/widgets/location_preview.dart';
import '../../home/auctions/map-auctions/index.dart';

class LocationMessageContent extends StatelessWidget {
  final navigatorService = Get.find<NavigatorService>();
  final Rx<ChatMessage> message;

  LocationMessageContent({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    var latitude = message.value.latitude;
    var longitude = message.value.longitude;

    if (latitude == null || longitude == null) {
      return Container();
    }

    var latLng = LatLng(double.parse(latitude), double.parse(longitude));
    return GestureDetector(
      onTap: () {
        navigatorService.push(
          MapAuctionsScreen(
            initialPosition: latLng,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(8),
        child: Container(
          height: 170,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
            child: LocationPreview(
              latLng: latLng,
            ),
          ),
        ),
      ),
    );
  }
}
