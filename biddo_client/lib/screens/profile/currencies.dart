import 'package:easy_localization/easy_localization.dart';
import 'package:biddo/theme/extensions/base.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/controllers/account.dart';
import '../../core/controllers/currencies.dart';
import '../../core/controllers/flash.dart';
import '../../core/controllers/settings.dart';
import '../../core/models/currency.dart';
import '../../theme/colors.dart';
import '../../widgets/simple_app_bar.dart';

class CurrenciesSettingsScreen extends StatefulWidget {
  const CurrenciesSettingsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CurrenciesSettingsScreen createState() => _CurrenciesSettingsScreen();
}

class _CurrenciesSettingsScreen extends State<CurrenciesSettingsScreen> {
  final accountController = Get.find<AccountController>();
  final settingsController = Get.find<SettingsController>();
  final flashController = Get.find<FlashController>();
  final currenciesController = Get.find<CurrenciesController>();

  void goBack() {
    Navigator.of(context).pop();
  }

  bool _currencyChanging = false;

  Future handleChange(Currency currency) async {
    if (_currencyChanging) {
      return;
    }

    var accountCurrencyId = accountController.account.value.selectedCurrencyId;
    var currentCurrency = accountCurrencyId ??
        settingsController.settings.value.defaultCurrencyId;

    if (currentCurrency == currency.id) {
      return;
    }

    setState(() {
      _currencyChanging = true;
    });

    var result = await accountController.updateAccountCurrency(currency.id);
    if (!mounted) {
      return;
    }

    if (!result) {
      flashController.showMessageFlash(
        'currencies.could_not_update',
        FlashMessageType.error,
      );
    }

    setState(() {
      _currencyChanging = false;
    });
  }

  Widget _renderCurrency(
    String icon,
    String title,
    bool isSelected,
    Function onChange,
  ) {
    return InkWell(
      onTap: () {
        onChange();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: Theme.of(context)
                          .extension<CustomThemeFields>()!
                          .smaller
                          .copyWith(fontWeight: FontWeight.w300),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: 8,
            ),
            Checkbox(
              side: BorderSide(
                color: Theme.of(context)
                    .extension<CustomThemeFields>()!
                    .fontColor_1,
              ),
              checkColor: DarkColors.font_1,
              activeColor:
                  Theme.of(context).extension<CustomThemeFields>()!.action,
              value: isSelected,
              onChanged: (bool? value) {
                onChange();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var currentLanguage = EasyLocalization.of(context)!.locale;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.pop(context);
        }
      },
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            Navigator.pop(context); // Swipe right to go back
          }
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor:
                Theme.of(context).extension<CustomThemeFields>()!.background_1,
            resizeToAvoidBottomInset: true,
            appBar: SimpleAppBar(
                onBack: goBack,
                withSearch: false,
                elevation: 0,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        'profile.currencies',
                        textAlign: TextAlign.start,
                        style: Theme.of(context)
                            .extension<CustomThemeFields>()!
                            .title,
                      ).tr(),
                    ),
                  ],
                )),
            body: SingleChildScrollView(
              child: Obx(
                () => Column(
                  children: currenciesController.currencies.map((currency) {
                    return _renderCurrency(
                      currency.id,
                      '${currency.code} - ${currency.name[currentLanguage.toString()]!}',
                      accountController.account.value.selectedCurrencyId != null
                          ? accountController
                                  .account.value.selectedCurrencyId ==
                              currency.id
                          : settingsController
                                  .settings.value.defaultCurrencyId ==
                              currency.id,
                      () => handleChange(currency),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
