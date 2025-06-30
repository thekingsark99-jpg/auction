import 'package:biddo/theme/extensions/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_svg/svg.dart';

class AttachmentTypeButton extends StatelessWidget {
  final String title;
  final String icon;
  final Function onTap;

  const AttachmentTypeButton({
    required this.title,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTap(
      onPressed: () {
        onTap();
      },
      child: Container(
        height: 82,
        decoration: BoxDecoration(
          color: Theme.of(context).extension<CustomThemeFields>()!.background_3,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            color: Theme.of(context).extension<CustomThemeFields>()!.separator,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              height: 32,
              semanticsLabel: 'Attachment type',
              colorFilter: ColorFilter.mode(
                Theme.of(context).extension<CustomThemeFields>()!.fontColor_1,
                BlendMode.srcIn,
              ),
            ),
            Container(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .extension<CustomThemeFields>()!
                      .smaller
                      .copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
