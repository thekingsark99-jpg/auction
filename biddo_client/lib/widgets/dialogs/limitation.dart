import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../theme/extensions/base.dart';
import '../common/simple_button.dart';

class LimitationDialog extends StatelessWidget {
  final String title;
  final String description;
  final Function()? onOkPressed;

  const LimitationDialog({
    super.key,
    required this.title,
    required this.description,
    this.onOkPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor:
          Theme.of(context).extension<CustomThemeFields>()!.background_2,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).extension<CustomThemeFields>()!.title,
            ),
          ),
          Container(
            height: 16,
          ),
          Center(
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).extension<CustomThemeFields>()!.smaller,
            ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SimpleButton(
                background:
                    Theme.of(context).extension<CustomThemeFields>()!.action,
                onPressed: () {
                  Navigator.pop(context, true);
                  if (onOkPressed != null) {
                    onOkPressed!();
                  }
                },
                height: 42,
                width: double.infinity,
                child: Text('generic.ok',
                        style: Theme.of(context)
                            .extension<CustomThemeFields>()!
                            .smaller)
                    .tr(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
