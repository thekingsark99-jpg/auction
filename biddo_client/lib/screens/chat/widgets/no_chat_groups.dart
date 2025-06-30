import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../theme/extensions/base.dart';

class NoChatGroupsMessage extends StatelessWidget {
  final bool forBuying;

  const NoChatGroupsMessage({
    super.key,
    required this.forBuying,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 60,
          ),
          SvgPicture.asset(
            'assets/icons/svg/chat-color.svg',
            height: 160,
            semanticsLabel: 'No chat groups',
          ),
          Container(
            height: 32,
          ),
          Text(
            'chat.no_conversations_available',
            style: Theme.of(context).extension<CustomThemeFields>()!.title,
            textAlign: TextAlign.center,
          ).tr(),
          Container(
            height: 32,
          ),
          Text(
            forBuying
                ? 'chat.buying_will_appear_here'
                : 'chat.selling_will_appear_here',
            style: Theme.of(context).extension<CustomThemeFields>()!.smaller,
            textAlign: TextAlign.center,
          ).tr(),
          Container(
            height: 32,
          ),
        ],
      ),
    );
  }
}
