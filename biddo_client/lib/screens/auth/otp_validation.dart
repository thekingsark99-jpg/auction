import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';

import '../../core/controllers/flash.dart';
import '../../core/services/auth.dart';
import '../../theme/colors.dart';
import '../../theme/extensions/base.dart';
import '../../widgets/common/action_button.dart';

class OtpValidation extends StatefulWidget {
  const OtpValidation({super.key});

  @override
  State<OtpValidation> createState() => _OtpValidationScreenState();
}

class _OtpValidationScreenState extends State<OtpValidation> {
  final authService = Get.find<AuthService>();
  final flashController = Get.find<FlashController>();

  final Rx<bool> _pointerDownInner = false.obs;

  bool _verifyInProgress = false;
  String _otp = '';

  void goBack() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  Future<void> verifyOtp() async {
    if (_verifyInProgress || _otp.isEmpty || _otp.length != 6) {
      return;
    }

    setState(() {
      _verifyInProgress = true;
    });

    try {
      await authService.submitPhoneNumberOtp(
        _otp,
      );
      goBack();
    } catch (error) {
      flashController.showMessageFlash(
        tr('phone_sign_in.could_not_sign_in'),
        FlashMessageType.error,
      );
    } finally {
      setState(() {
        _verifyInProgress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
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
          child: Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: (_) {
              if (_pointerDownInner.value) {
                _pointerDownInner.value = false;
                return;
              }

              _pointerDownInner.value = false;
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              backgroundColor: Theme.of(context)
                  .extension<CustomThemeFields>()!
                  .background_1,
              resizeToAvoidBottomInset: true,
              body: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'phone_sign_in.verify_otp',
                      style: Theme.of(context)
                          .extension<CustomThemeFields>()!
                          .title
                          .copyWith(fontSize: 30),
                    ).tr(),
                    Container(
                      height: 32,
                    ),
                    Text(
                      "phone_sign_in.we_sent_code",
                      style: Theme.of(context)
                          .extension<CustomThemeFields>()!
                          .smaller,
                    ).tr(),
                    Container(
                      height: 8,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: OtpTextField(
                              textStyle: Theme.of(context)
                                  .extension<CustomThemeFields>()!
                                  .title,
                              numberOfFields: 6,
                              borderColor: Theme.of(context)
                                  .extension<CustomThemeFields>()!
                                  .separator,
                              focusedBorderColor: Theme.of(context)
                                  .extension<CustomThemeFields>()!
                                  .fontColor_3,
                              filled: true,
                              showFieldAsBox: false,
                              fillColor: Theme.of(context)
                                  .extension<CustomThemeFields>()!
                                  .background_2,
                              borderWidth: 4.0,
                              onCodeChanged: (String code) {},
                              onSubmit: (String verificationCode) {
                                setState(() {
                                  _otp = verificationCode;
                                });
                              }, // end onSubmit
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 24,
                    ),
                    ActionButton(
                      onPressed: () {
                        verifyOtp();
                      },
                      isLoading: _verifyInProgress,
                      background: Theme.of(context)
                          .extension<CustomThemeFields>()!
                          .action,
                      child: Text(
                        'auth.sign_in.sign_in',
                        style: Theme.of(context)
                            .extension<CustomThemeFields>()!
                            .smaller
                            .copyWith(
                              color: DarkColors.font_1,
                              fontWeight: FontWeight.w500,
                            ),
                      ).tr(),
                    ),
                    Container(
                      height: 56,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'auth.forgot_password.return_to',
                          style: Theme.of(context)
                              .extension<CustomThemeFields>()!
                              .subtitle,
                        ).tr(),
                        InkWell(
                          onTap: () {
                            goBack();
                          },
                          child: Text(
                            'auth.sign_up.sign_in',
                            style: Theme.of(context)
                                .extension<CustomThemeFields>()!
                                .subtitle
                                .copyWith(
                                  color: Colors.blue,
                                ),
                          ).tr(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
