import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/account.dart';
import '../../../core/models/auction.dart';
import '../../../theme/extensions/base.dart';
import '../../../utils/generic.dart';

class DistanceFromCurrentAccount extends StatelessWidget {
  final accountController = Get.find<AccountController>();
  final Auction auction;

  DistanceFromCurrentAccount({
    required this.auction,
  });

  String formatDouble(double value) {
    if (value % 1 == 0) {
      return NumberFormat.decimalPattern().format(value.toInt()).toString();
    }
    if (value < 1) {
      return NumberFormat.decimalPattern().format(value).toString();
    }
    return NumberFormat.decimalPattern().format(value.toInt()).toString();
  }

  @override
  Widget build(BuildContext context) {
    var auctionLatLng = auction.location;
    if (auctionLatLng == null) {
      return Container();
    }

    return Obx(
      () => accountController.account.value.locationLatLng == null
          ? Container()
          : Text(
              'location.distance',
              style: Theme.of(context).extension<CustomThemeFields>()!.smallest,
            ).tr(namedArgs: {
              'no': formatDouble(GenericUtils.calculateDistanceBetweenPoints(
                auctionLatLng.latitude,
                auctionLatLng.longitude,
                accountController.account.value.locationLatLng!.latitude,
                accountController.account.value.locationLatLng!.longitude,
              )).toString()
            }),
    );
  }
}
