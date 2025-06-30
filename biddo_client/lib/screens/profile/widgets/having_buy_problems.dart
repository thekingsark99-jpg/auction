import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/ads.dart';
import '../../../core/controllers/settings.dart';
import '../../../theme/extensions/base.dart';
import '../../../widgets/common/simple_button.dart';
import '../../../widgets/dialogs/send_us_a_message.dart';

class HavingBuyCoinsProblems extends StatefulWidget {
  const HavingBuyCoinsProblems({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _HavingBuyCoinsProblems createState() => _HavingBuyCoinsProblems();
}

class _HavingBuyCoinsProblems extends State<HavingBuyCoinsProblems> {
  final adsController = Get.find<AdsController>();
  final settingsController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(start: 16, end: 16, top: 16),
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .extension<CustomThemeFields>()!
              .background_3
              .withOpacity(0.6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    'buy_coins.having_trouble',
                    style: Theme.of(context)
                        .extension<CustomThemeFields>()!
                        .smaller,
                  ).tr(),
                ),
              ],
            ),
            Container(
              height: 16,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    'buy_coins.send_us_a_message',
                    style: Theme.of(context)
                        .extension<CustomThemeFields>()!
                        .smaller,
                  ).tr(),
                ),
              ],
            ),
            Container(
              height: 16,
            ),
            SimpleButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const SendUsAMessageDialog();
                  },
                );
              },
              background:
                  Theme.of(context).extension<CustomThemeFields>()!.separator,
              child: Text(
                'profile.more.send_message.send_message',
                style: Theme.of(context)
                    .extension<CustomThemeFields>()!
                    .smaller
                    .copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ).tr(),
            ),
          ],
        ),
      ),
    );
  }
}
