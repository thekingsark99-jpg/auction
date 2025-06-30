import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../core/controllers/account.dart';
import '../../../core/controllers/flash.dart';
import '../../../core/controllers/settings.dart';
import '../../../core/navigator.dart';
import '../../../theme/colors.dart';
import '../../../theme/extensions/base.dart';
import '../../../widgets/common/section_heading.dart';
import '../../../widgets/common/simple_button.dart';

class ProfileVerificationSection extends StatefulWidget {
  ProfileVerificationSection({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileVerificationSection createState() => _ProfileVerificationSection();
}

class _ProfileVerificationSection extends State<ProfileVerificationSection> {
  final flashController = Get.find<FlashController>();
  final navigatorService = Get.find<NavigatorService>();
  final settingsController = Get.find<SettingsController>();
  final accountController = Get.find<AccountController>();

  bool _askInProgress = false;

  Future<void> askForVerification() async {
    if (_askInProgress) {
      return;
    }

    setState(() {
      _askInProgress = true;
    });

    try {
      var verified = await accountController.askForVerification();
      if (verified) {
        flashController.showMessageFlash(
          tr('verification.verification_asked'),
          FlashMessageType.success,
        );
      } else {
        flashController.showMessageFlash(
          tr('verification.could_not_ask_for_verification'),
          FlashMessageType.error,
        );
      }
    } catch (error) {
      flashController.showMessageFlash(
        tr('verification.could_not_ask_for_verification'),
        FlashMessageType.error,
      );
    } finally {
      setState(() {
        _askInProgress = false;
      });
    }
  }

  Widget _renderIconOnVerifiedAccountInfo(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          'assets/icons/svg/verified.svg',
          height: 28,
          width: 28,
          semanticsLabel: 'verified',
        ),
        Container(
          width: 8,
        ),
        Expanded(
          child: Text(
            'verification.verified_have_icon',
            style: Theme.of(context).extension<CustomThemeFields>()!.smaller,
          ).tr(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var currentLanguage = context.locale.toString();

    return Column(
      children: [
        SectionHeading(
          title: tr('verification.account_verification'),
          withMore: false,
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .extension<CustomThemeFields>()!
                .background_3
                .withOpacity(0.6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Obx(
            () => accountController.account.value.verified &&
                    accountController.account.value.verifiedAt != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _renderIconOnVerifiedAccountInfo(context),
                      Container(
                        height: 16,
                      ),
                      Text(
                        'verification.account_was_verified',
                        style: Theme.of(context)
                            .extension<CustomThemeFields>()!
                            .smaller,
                      ).tr(namedArgs: {
                        'date': DateFormat('d MMM, h:mm a', currentLanguage)
                            .format(accountController.account.value.verifiedAt!)
                            .toString(),
                      }),
                    ],
                  )
                : accountController.account.value.verificationRequestedAt !=
                        null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _renderIconOnVerifiedAccountInfo(context),
                          Container(
                            height: 16,
                          ),
                          Text(
                            'verification.already_asked_for_verification',
                            style: Theme.of(context)
                                .extension<CustomThemeFields>()!
                                .smaller,
                          ).tr(),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _renderIconOnVerifiedAccountInfo(context),
                          Container(
                            height: 16,
                          ),
                          Text(
                            'verification.ask_verification',
                            style: Theme.of(context)
                                .extension<CustomThemeFields>()!
                                .smaller,
                          ).tr(),
                          Container(
                            height: 16,
                          ),
                          SimpleButton(
                            isLoading: _askInProgress,
                            onPressed: () {
                              askForVerification();
                            },
                            background: Theme.of(context)
                                .extension<CustomThemeFields>()!
                                .action,
                            child: Text(
                              'verification.ask_verification_button',
                              style: Theme.of(context)
                                  .extension<CustomThemeFields>()!
                                  .smaller
                                  .copyWith(
                                    color: DarkColors.font_1,
                                  ),
                            ).tr(),
                          )
                        ],
                      ),
          ),
        ),
      ],
    );
  }
}
