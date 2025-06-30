import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/flash.dart';
import '../../../core/controllers/main.dart';
import '../../theme/colors.dart';
import '../../theme/extensions/base.dart';
import '../common/simple_button.dart';

class SendUsAMessageDialog extends StatefulWidget {
  const SendUsAMessageDialog({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SendUsAMessageDialogState createState() => _SendUsAMessageDialogState();
}

class _SendUsAMessageDialogState extends State<SendUsAMessageDialog> {
  final mainController = Get.find<MainController>();
  final flashController = Get.find<FlashController>();
  final _detailsController = TextEditingController();

  int proposalLen = 0;
  bool _sendingMessage = false;

  @override
  void initState() {
    super.initState();
    _detailsController.addListener(() {
      if (mounted) {
        setState(() {
          proposalLen = _detailsController.text.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> handleSendMessage() async {
    if (proposalLen == 0 || _sendingMessage) {
      return;
    }
    if (mounted) {
      setState(() {
        _sendingMessage = true;
      });
    }
    var sent = await mainController.sendUsAMessage(_detailsController.text);
    if (mounted) {
      setState(() {
        _sendingMessage = false;
      });
    }

    if (sent == true) {
      flashController.showMessageFlash(
        tr('profile.more.send_message.message_sent'),
        FlashMessageType.success,
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      return;
    }

    flashController.showMessageFlash(
      tr('profile.more.send_message.could_not_send'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor:
          Theme.of(context).extension<CustomThemeFields>()!.background_2,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'profile.more.send_message.title',
                textAlign: TextAlign.center,
                style: Theme.of(context).extension<CustomThemeFields>()!.title,
              ).tr(),
            ),
            Container(
              height: 16,
            ),
            TextField(
              maxLines: 4,
              minLines: 4,
              maxLength: 1000,
              controller: _detailsController,
              style: Theme.of(context).extension<CustomThemeFields>()!.smaller,
              scrollPadding: const EdgeInsets.only(
                bottom: 130,
              ),
              decoration: InputDecoration(
                hintText: tr('profile.more.send_message.input_placeholder'),
                counterText: '',
                fillColor: Theme.of(context)
                    .extension<CustomThemeFields>()!
                    .background_3,
                hintStyle:
                    Theme.of(context).extension<CustomThemeFields>()!.smaller,
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: Theme.of(context)
                          .extension<CustomThemeFields>()!
                          .background_2,
                      width: 0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Theme.of(context)
                        .extension<CustomThemeFields>()!
                        .fontColor_1,
                    width: 1,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        Row(
          children: [
            IntrinsicWidth(
              child: SimpleButton(
                background:
                    Theme.of(context).extension<CustomThemeFields>()!.separator,
                onPressed: () {
                  Navigator.pop(context);
                },
                height: 42,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'generic.cancel',
                    style: Theme.of(context)
                        .extension<CustomThemeFields>()!
                        .smaller,
                  ).tr(),
                ),
              ),
            ),
            Container(
              width: 8,
            ),
            Expanded(
              child: SimpleButton(
                borderColor: proposalLen == 0
                    ? Colors.transparent
                    : Theme.of(context).extension<CustomThemeFields>()!.action,
                background: proposalLen == 0
                    ? Theme.of(context)
                        .extension<CustomThemeFields>()!
                        .background_3
                    : Theme.of(context).extension<CustomThemeFields>()!.action,
                onPressed: () {
                  handleSendMessage();
                },
                isLoading: _sendingMessage,
                height: 42,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text('profile.more.send_message.send_message',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .extension<CustomThemeFields>()!
                              .smaller
                              .copyWith(
                                color: proposalLen == 0
                                    ? Theme.of(context)
                                        .extension<CustomThemeFields>()!
                                        .fontColor_1
                                    : DarkColors.font_1,
                              )).tr(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
