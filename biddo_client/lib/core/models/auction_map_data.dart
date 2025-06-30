class AuctionMapData {
  String id;
  double locationLat;
  double locationLng;
  AuctionDataMeta? meta;

  AuctionMapData({
    required this.id,
    required this.locationLat,
    required this.locationLng,
    this.meta,
  });

  static AuctionMapData fromJSON(dynamic data) {
    return AuctionMapData(
      id: data['id'],
      locationLat: data['locationLat'],
      locationLng: data['locationLong'],
      meta: data['meta'] != null
          ? AuctionDataMeta(
              assetPath: data['meta']['assetPath'],
              mainCategoryId: data['meta']['mainCategoryId'],
            )
          : null,
    );
  }
}

class AuctionDataMeta {
  String assetPath;
  String mainCategoryId;

  AuctionDataMeta({
    required this.assetPath,
    required this.mainCategoryId,
  });
}
