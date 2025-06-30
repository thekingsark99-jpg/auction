import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../theme/extensions/base.dart';
import 'fullscreen_player.dart';

class VideoPlayerButton extends StatelessWidget {
  final Widget? button;
  final String videoUrl;
  final Function? onDetails;
  final double? radius;
  final Color? background;
  final bool? withBottomNavigation;

  VideoPlayerButton(
      {this.button,
      required this.videoUrl,
      this.onDetails,
      this.radius = 50,
      this.background,
      this.withBottomNavigation = true});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      color: Colors.transparent,
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          return true; // Stop scroll notification from propagating
        },
        child: OpenContainer(
          closedShape: ShapeBorder.lerp(
            CircleBorder(),
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius!),
            ),
            1,
          )!,
          useRootNavigator: true,
          closedElevation: 0,
          openColor:
              Theme.of(context).extension<CustomThemeFields>()!.background_1,
          closedColor: background != null
              ? background!
              : Theme.of(context)
                  .extension<CustomThemeFields>()!
                  .background_2
                  .withOpacity(0.9),
          onClosed: (post) {},
          openBuilder: (_, close) => FullscreenVideoPlayer(
            videoUrl: videoUrl,
            withBottomNavigation: withBottomNavigation!,
            onDetails: () {
              close();

              if (onDetails != null) {
                onDetails!();
              }
            },
          ),
          closedBuilder: (_, VoidCallback openContainer) => button != null
              ? button as Widget
              : Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context)
                        .extension<CustomThemeFields>()!
                        .background_2
                        .withOpacity(0.9),
                  ),
                  height: 20,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(maxHeight: 38, maxWidth: 38),
                    splashRadius: 24,
                    iconSize: 24,
                    onPressed: () {
                      openContainer();
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/svg/play.svg',
                      semanticsLabel: 'Play',
                      height: 18,
                      width: 18,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).iconTheme.color!,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
