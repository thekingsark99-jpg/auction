import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/colors.dart';
import '../../../theme/extensions/base.dart';
import '../../simple_app_bar.dart';
import '../simple_button.dart';
import 'adaptive_video_player.dart';

class FullscreenVideoPlayer extends StatelessWidget {
  final String videoUrl;
  final Function? onDetails;
  final bool? withBottomNavigation;

  FullscreenVideoPlayer({
    required this.videoUrl,
    this.onDetails,
    this.withBottomNavigation = true,
  });

  final Rx<bool> _pointerDownInner = false.obs;

  void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  Widget _renderBottomNavigation(BuildContext context) {
    if (onDetails == null || withBottomNavigation == false) {
      return Container(
        height: 0,
      );
    }

    return Container(
      height: 60,
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).extension<CustomThemeFields>()!.separator,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SimpleButton(
              onPressed: () => goBack(context),
              child: Text(
                'generic.cancel',
                style: Theme.of(context)
                    .extension<CustomThemeFields>()!
                    .smaller
                    .copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ).tr(),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SimpleButton(
              onPressed: () {
                onDetails!();
              },
              background:
                  Theme.of(context).extension<CustomThemeFields>()!.action,
              child: Text(
                'generic.details',
                style: Theme.of(context)
                    .extension<CustomThemeFields>()!
                    .smaller
                    .copyWith(
                      color: DarkColors.font_1,
                      fontWeight: FontWeight.bold,
                    ),
              ).tr(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        // Check if the device is in landscape mode.
        final isLandscape = orientation == Orientation.landscape;
        return Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (_) {
            if (_pointerDownInner.value) {
              _pointerDownInner.value = false;
              return;
            }
            _pointerDownInner.value = false;
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Theme.of(context)
                  .extension<CustomThemeFields>()!
                  .background_1,
              resizeToAvoidBottomInset: true,
              appBar: isLandscape
                  ? null
                  : SimpleAppBar(
                      onBack: () => goBack(context),
                      withSearch: false,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              'create_auction.auction_video',
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .extension<CustomThemeFields>()!
                                  .title,
                            ).tr(),
                          ),
                        ],
                      ),
                    ),
              body: Material(
                elevation: 0,
                color: Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    return true;
                  },
                  child: Center(
                    child: AdaptiveVideoWidget(videoUrl: videoUrl),
                  ),
                ),
              ),
              bottomNavigationBar:
                  isLandscape ? null : _renderBottomNavigation(context),
            ),
          ),
        );
      },
    );
  }
}
