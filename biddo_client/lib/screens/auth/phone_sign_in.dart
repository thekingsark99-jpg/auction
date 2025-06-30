import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/controllers/flash.dart';
import '../../core/navigator.dart';
import '../../core/services/auth.dart';
import '../../theme/colors.dart';
import '../../theme/extensions/base.dart';
import '../../widgets/common/action_button.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'otp_validation.dart';

class PhoneSignInScreen extends StatefulWidget {
  const PhoneSignInScreen({super.key});

  @override
  State<PhoneSignInScreen> createState() => _PhoneSignInScreenState();
}

class _PhoneSignInScreenState extends State<PhoneSignInScreen> {
  final authService = Get.find<AuthService>();
  final flashController = Get.find<FlashController>();
  final navigatorService = Get.find<NavigatorService>();

  final Rx<bool> _pointerDownInner = false.obs;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();

  PhoneNumber? _phoneNumber;
  bool _phoneNumberSendInProgress = false;

  RxBool _isPhoneNumberValid = false.obs;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void goBack() {
    Navigator.of(context).pop();
  }

  void handlePhoneNumberSignIn() async {
    if (_phoneNumberSendInProgress ||
        _phoneNumber == null ||
        _phoneNumber!.phoneNumber == null) {
      return;
    }

    if (mounted) {
      setState(() {
        _phoneNumberSendInProgress = true;
      });
    }

    try {
      var codeSent =
          await authService.validatePhoneNumber(_phoneNumber!.phoneNumber!);
      if (codeSent) {
        navigatorService.push(const OtpValidation());
      }
    } catch (e) {
      switch (e) {
        case 'code_sent':
          navigatorService.push(const OtpValidation());
        case 'verification_failed':
        case 'retrieval_timeout':
          flashController.showMessageFlash(
            tr('phone_sign_in.could_not_sign_in'),
            FlashMessageType.error,
          );
        default:
          flashController.showMessageFlash(
            tr('phone_sign_in.could_not_sign_in'),
            FlashMessageType.error,
          );
      }
    }

    if (mounted) {
      setState(() {
        _phoneNumberSendInProgress = false;
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
              body: SingleChildScrollView(
                child: Container(
                  height: Get.height - 200,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'phone_sign_in.title',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .extension<CustomThemeFields>()!
                            .title
                            .copyWith(fontSize: 30),
                      ).tr(),
                      Container(
                        height: 32,
                      ),
                      Text(
                        "phone_sign_in.description",
                        textAlign: TextAlign.start,
                        style: Theme.of(context)
                            .extension<CustomThemeFields>()!
                            .smaller,
                      ).tr(),
                      Container(
                        height: 8,
                      ),
                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 16),
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InternationalPhoneNumberInput(
                                      onInputChanged: (PhoneNumber number) {
                                        // Store the full phone number including country code
                                        setState(() {
                                          _phoneNumber = number;
                                        });
                                      },
                                      onInputValidated: (bool value) {
                                        if (value !=
                                            _isPhoneNumberValid.value) {
                                          _isPhoneNumberValid.value = value;
                                        }
                                      },
                                      cursorColor: Theme.of(context)
                                          .extension<CustomThemeFields>()!
                                          .fontColor_3,
                                      searchBoxDecoration: InputDecoration(
                                        filled: true,
                                        fillColor: Theme.of(context)
                                            .extension<CustomThemeFields>()!
                                            .background_2,
                                        hintText:
                                            tr('phone_sign_in.phone_number'),
                                        hintStyle: Theme.of(context)
                                            .extension<CustomThemeFields>()!
                                            .smaller
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .extension<
                                                      CustomThemeFields>()!
                                                  .fontColor_3,
                                            ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .extension<CustomThemeFields>()!
                                                .separator,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .extension<CustomThemeFields>()!
                                                .separator,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .extension<CustomThemeFields>()!
                                                .fontColor_1,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .extension<CustomThemeFields>()!
                                                .separator,
                                          ),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .extension<CustomThemeFields>()!
                                                .fontColor_1,
                                          ),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .extension<CustomThemeFields>()!
                                                .separator,
                                          ),
                                        ),
                                      ),
                                      inputDecoration: InputDecoration(
                                        filled: true,
                                        fillColor: Theme.of(context)
                                            .extension<CustomThemeFields>()!
                                            .background_2,
                                        hintText:
                                            tr('phone_sign_in.phone_number'),
                                        hintStyle: Theme.of(context)
                                            .extension<CustomThemeFields>()!
                                            .smaller
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .extension<
                                                      CustomThemeFields>()!
                                                  .fontColor_3,
                                            ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .extension<CustomThemeFields>()!
                                                .separator,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .extension<CustomThemeFields>()!
                                                .separator,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .extension<CustomThemeFields>()!
                                                .fontColor_1,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .extension<CustomThemeFields>()!
                                                .separator,
                                          ),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .extension<CustomThemeFields>()!
                                                .fontColor_1,
                                          ),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .extension<CustomThemeFields>()!
                                                .separator,
                                          ),
                                        ),
                                      ),
                                      selectorConfig: SelectorConfig(
                                        selectorType:
                                            PhoneInputSelectorType.BOTTOM_SHEET,
                                        useBottomSheetSafeArea: true,
                                      ),
                                      ignoreBlank: false,
                                      textStyle: Theme.of(context)
                                          .extension<CustomThemeFields>()!
                                          .smaller,
                                      autoValidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      selectorTextStyle: Theme.of(context)
                                          .extension<CustomThemeFields>()!
                                          .smaller,
                                      initialValue: _phoneNumber,
                                      textFieldController: controller,
                                      formatInput: true,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                        signed: true,
                                        decimal: true,
                                      ),
                                      inputBorder: OutlineInputBorder(),
                                      onSaved: (PhoneNumber number) {
                                        _phoneNumber = number;
                                      },
                                      errorMessage:
                                          tr('phone_sign_in.phone_invalid'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 8,
                      ),
                      Text(
                        "phone_sign_in.you_will_receive",
                        style: Theme.of(context)
                            .extension<CustomThemeFields>()!
                            .smaller,
                      ).tr(),
                      Container(
                        height: 24,
                      ),
                      Obx(
                        () => ActionButton(
                          onPressed: () {
                            if (_isPhoneNumberValid.value) {
                              handlePhoneNumberSignIn();
                            }
                          },
                          isLoading: _phoneNumberSendInProgress,
                          background: _isPhoneNumberValid.value
                              ? Theme.of(context)
                                  .extension<CustomThemeFields>()!
                                  .action
                              : Theme.of(context)
                                  .extension<CustomThemeFields>()!
                                  .separator,
                          child: Text(
                            'phone_sign_in.send_code',
                            style: Theme.of(context)
                                .extension<CustomThemeFields>()!
                                .smaller
                                .copyWith(
                                  color: _isPhoneNumberValid.value
                                      ? DarkColors.font_1
                                      : Theme.of(context)
                                          .extension<CustomThemeFields>()!
                                          .fontColor_1,
                                  fontWeight: FontWeight.w500,
                                ),
                          ).tr(),
                        ),
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
      ),
    );
  }
}
