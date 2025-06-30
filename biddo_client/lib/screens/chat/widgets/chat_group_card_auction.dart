import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../core/controllers/categories.dart';
import '../../../core/controllers/settings.dart';
import '../../../core/models/auction.dart';
import '../../../core/navigator.dart';
import '../../../theme/extensions/base.dart';
import '../../../utils/constants.dart';
import '../../auction-details/index.dart';

// ignore: must_be_immutable
class ChatGroupCardAuction extends StatelessWidget {
  final settingsController = Get.find<SettingsController>();
  final categoriesController = Get.find<CategoriesController>();
  final navigatorService = Get.find<NavigatorService>();

  Auction auction;

  ChatGroupCardAuction({
    super.key,
    required this.auction,
  });

  Widget _renderPostAssets() {
    var assets = auction.assets ?? [];
    var assetsLen = assets.length;
    var serverBaseUrl = FlutterConfig.get('SERVER_URL');

    if (assetsLen == 0) {
      return SizedBox(
        width: 40,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: settingsController
                      .settings.value.defaultProductImageUrl.isNotEmpty &&
                  settingsController.settings.value.defaultProductImageUrl !=
                      Constants.DEFAULT_ITEM_IMAGE
              ? Image.network(
                  settingsController.settings.value.defaultProductImageUrl,
                  fit: BoxFit.cover,
                  width: 40,
                  height: 40,
                )
              : Image.asset(
                  'assets/jpg/default-item.jpeg',
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                ),
        ),
      );
    }

    var firstAsset = assets[0];

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.network(
        '$serverBaseUrl/assets/${firstAsset.path}',
        fit: BoxFit.cover,
        width: 40,
        height: 40,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var category = categoriesController.categories.firstWhere(
      (element) => element.value.id == auction.mainCategoryId,
    );

    return Material(
      borderRadius: BorderRadius.circular(8),
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          navigatorService.push(AuctionDetailsScreen(
            auctionId: auction.id,
            assetsLen: 1,
          ));
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  Theme.of(context).extension<CustomThemeFields>()!.separator,
            ),
            color: Theme.of(context)
                .extension<CustomThemeFields>()!
                .background_2
                .withOpacity(0.3),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Row(
                  children: [
                    _renderPostAssets(),
                    Container(width: 8),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            auction.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .extension<CustomThemeFields>()!
                                .smallest
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            category.value.name[context.locale.toString()]!,
                            maxLines: 1,
                            style: Theme.of(context)
                                .extension<CustomThemeFields>()!
                                .smallest,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SvgPicture.asset(
                'assets/icons/svg/next.svg',
                height: 20,
                semanticsLabel: 'See details',
                colorFilter: ColorFilter.mode(
                  Theme.of(context).extension<CustomThemeFields>()!.fontColor_1,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
