import 'package:easy_localization/easy_localization.dart';
import 'package:biddo/theme/extensions/base.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/currencies.dart';
import '../../../core/models/auction.dart';
import '../../../widgets/common/price_text.dart';

class MinSellPriceInfo extends StatelessWidget {
  final Rx<Auction> auction;
  final currenciesController = Get.find<CurrenciesController>();

  MinSellPriceInfo({
    super.key,
    required this.auction,
  });

  @override
  Widget build(BuildContext context) {
    var minPrice =
        currenciesController.getMaxPriceFromAuctionBids(auction.value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          auction.value.bids.isEmpty
              ? 'auction_details.create_bid.starting_price'
              : 'auction_details.create_bid.highest_bid',
          style: Theme.of(context).extension<CustomThemeFields>()!.smaller,
        ).tr(),
        Container(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PriceText(
              price: minPrice.maxPrice,
              initialCurrencyIsSameAsTargetCurrency: true,
              style: Theme.of(context)
                  .extension<CustomThemeFields>()!
                  .smaller
                  .copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
