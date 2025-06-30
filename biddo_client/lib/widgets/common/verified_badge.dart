import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_svg/svg.dart';

import '../dialogs/verified_info.dart';

class VerifiedBadge extends StatelessWidget {
  final bool verified;
  final double? size;

  const VerifiedBadge({
    super.key,
    required this.verified,
    this.size = 24,
  });

  void _handleTap(BuildContext context) {
    var alert = VerifiedAccountInfoDialog();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return verified
        ? ScaleTap(
            onPressed: () => _handleTap(context),
            child: SvgPicture.asset(
              'assets/icons/svg/verified.svg',
              height: size,
              width: size,
              semanticsLabel: 'verified',
            ),
          )
        : Container();
  }
}
