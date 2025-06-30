import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../core/controllers/account.dart';
import '../../core/controllers/flash.dart';
import '../../core/controllers/settings.dart';
import '../../core/services/auth.dart';
import '../../theme/extensions/base.dart';
import '../common/simple_button.dart';

// ignore: must_be_immutable
class EmailVerificationNeededDialog extends StatefulWidget {
  Function? afterValidation;
  bool? onlyOneLevelBack;

  EmailVerificationNeededDialog({
    super.key,
    this.afterValidation,
    this.onlyOneLevelBack = false,
  });

  @override
  // ignore: library_private_types_in_public_api
  _EmailVerificationNeededDialogState createState() =>
      _EmailVerificationNeededDialogState();
}

class _EmailVerificationNeededDialogState
    extends State<EmailVerificationNeededDialog> {
  final accountController = Get.find<AccountController>();
  final flashController = Get.find<FlashController>();
  final authService = Get.find<AuthService>();
  final settingsController = Get.find<SettingsController>();

  final RxBool _sendingLinkInProgress = false.obs;
  final RxBool _verifyInProgress = false.obs;

  Future<void> resendVerificationLink() async {
    if (_sendingLinkInProgress.value) {
      return;
    }

    _sendingLinkInProgress.value = true;
    var sent = await authService.resendEmailVerification();
    _sendingLinkInProgress.value = false;

    if (sent) {
      flashController.showMessageFlash(
        tr('verify_email.link_sent'),
        FlashMessageType.success,
      );
    } else {
      flashController.showMessageFlash(
        tr('verify_email.could_not_send_link'),
      );
    }
  }

  Future<void> checkIfEmailIsVerified() async {
    if (_verifyInProgress.value) {
      return;
    }

    _verifyInProgress.value = true;
    await authService.reloadFirebaseAccount();

    var isVerified = authService.userHasEmailVerified(
      settingsController.settings.value,
    );

    _verifyInProgress.value = false;

    if (!isVerified) {
      flashController.showMessageFlash(
        tr('verify_email.your_email_is_not_verified'),
      );
      return;
    }

    flashController.showMessageFlash(
      tr('verify_email.email_verified'),
      FlashMessageType.success,
    );

    // ignore: use_build_context_synchronously
    Navigator.pop(context);

    if (widget.afterValidation != null) {
      widget.afterValidation!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        if (widget.onlyOneLevelBack == false) {
          Navigator.maybePop(context);
        }
        return Future.value(false);
      },
      child: AlertDialog(
        backgroundColor:
            Theme.of(context).extension<CustomThemeFields>()!.background_2,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        titlePadding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                'verify_email.title',
                style: Theme.of(context).extension<CustomThemeFields>()!.title,
              ).tr(),
            ),
            IconButton(
              splashRadius: 24,
              iconSize: 14,
              onPressed: () {
                Navigator.pop(context);
                if (widget.onlyOneLevelBack == false) {
                  Navigator.maybePop(context);
                }
              },
              icon: SvgPicture.asset(
                'assets/icons/svg/close.svg',
                semanticsLabel: 'Close',
                height: 20,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).extension<CustomThemeFields>()!.fontColor_1,
                  BlendMode.srcIn,
                ),
              ),
            )
          ],
        ),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/svg/email.svg',
                  semanticsLabel: 'Verify-email',
                  height: 60,
                ),
                Container(
                  height: 16,
                ),
                Text(
                  accountController.account.value.email,
                  style:
                      Theme.of(context).extension<CustomThemeFields>()!.smaller,
                ),
                Container(
                  height: 24,
                ),
                Text(
                  'verify_email.we_sent_email',
                  style:
                      Theme.of(context).extension<CustomThemeFields>()!.smaller,
                ).tr(),
                Container(
                  height: 24,
                ),
                Text(
                  'verify_email.didn_t_receive_email',
                  style:
                      Theme.of(context).extension<CustomThemeFields>()!.smaller,
                ).tr(),
                Container(
                  height: 8,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 24),
                      child: ScaleTap(
                        onPressed: () {
                          resendVerificationLink();
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: IntrinsicHeight(
                            child: IntrinsicWidth(
                              child: Text(
                                'verify_email.send_again',
                                style: Theme.of(context)
                                    .extension<CustomThemeFields>()!
                                    .smaller
                                    .copyWith(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ).tr(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 8, top: 4),
                      height: 16,
                      width: 16,
                      child: IntrinsicHeight(
                        child: Obx(
                          () => CircularProgressIndicator(
                            strokeWidth: 3,
                            color: _sendingLinkInProgress.value
                                ? Colors.blue
                                : Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: SimpleButton(
                  background: Theme.of(context)
                      .extension<CustomThemeFields>()!
                      .background_3,
                  onPressed: () {
                    Navigator.pop(context);
                    if (widget.onlyOneLevelBack == false) {
                      Navigator.maybePop(context);
                    }
                  },
                  height: 42,
                  width: 120,
                  child: Text(
                    'generic.cancel',
                    style: Theme.of(context)
                        .extension<CustomThemeFields>()!
                        .smaller,
                  ).tr(),
                ),
              ),
              Container(
                width: 8,
              ),
              Expanded(
                child: Obx(
                  () => SimpleButton(
                    isLoading: _verifyInProgress.value,
                    background: Theme.of(context)
                        .extension<CustomThemeFields>()!
                        .action,
                    onPressed: () async {
                      await checkIfEmailIsVerified();
                    },
                    height: 42,
                    width: 120,
                    child: Text(
                      'verify_email.verified',
                      style: Theme.of(context)
                          .extension<CustomThemeFields>()!
                          .smaller,
                    ).tr(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
