import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:get/get.dart';

import '../../../core/controllers/auction.dart';
import '../../../theme/extensions/base.dart';
import '../../../widgets/common/section_heading.dart';

// ignore: must_be_immutable
class AuctionFormYoutubeSection extends StatefulWidget {
  Function? handleTitlePointerDown;

  AuctionFormYoutubeSection({
    super.key,
    this.handleTitlePointerDown,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AuctionFormYoutubeSectionState createState() =>
      _AuctionFormYoutubeSectionState();
}

class _AuctionFormYoutubeSectionState extends State<AuctionFormYoutubeSection> {
  final auctionControllerController = Get.find<AuctionController>();

  final _youtubeLinkController = TextEditingController();
  final RxInt _youtubeLinkLength = 0.obs;

  @override
  void initState() {
    super.initState();
    _youtubeLinkController.text = auctionControllerController.youtubeLink.value;
    _youtubeLinkLength.value =
        auctionControllerController.youtubeLink.value.length;

    _youtubeLinkController.addListener(() {
      auctionControllerController.setYoutubeLink(_youtubeLinkController.text);
    });
  }

  @override
  void dispose() {
    _youtubeLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var descriptionMsg = tr("create_auction.youtube_link");
    var addDescriptionMsg = tr("create_auction.enter_youtube_link");
    var optionalMsg = tr('generic.optional');

    return Container(
      height: 130,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeading(
            title: descriptionMsg,
            titleSufix: optionalMsg,
            withMore: false,
            padding: 0,
          ),
          Flexible(
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: (_) {
                widget.handleTitlePointerDown?.call();
              },
              child: TextField(
                maxLines: 1,
                minLines: 1,
                maxLength: 400,
                controller: _youtubeLinkController,
                style:
                    Theme.of(context).extension<CustomThemeFields>()!.smaller,
                scrollPadding: const EdgeInsets.only(
                  bottom: 130,
                ),
                onChanged: ((value) {
                  if (mounted) {
                    _youtubeLinkLength.value = value.length;
                  }
                }),
                decoration: InputDecoration(
                  hintText: addDescriptionMsg,
                  counterText: '',
                  fillColor: Theme.of(context)
                      .extension<CustomThemeFields>()!
                      .background_2,
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
              ),
            ),
          ),
          Container(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => ScaleTap(
                  onPressed: () {
                    _youtubeLinkController.text = '';
                    _youtubeLinkLength.value = 0;
                  },
                  child: _youtubeLinkLength.value == 0
                      ? Container()
                      : Text(
                          'generic.clear',
                          textAlign: TextAlign.right,
                          style: Theme.of(context)
                              .extension<CustomThemeFields>()!
                              .smallest
                              .copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.blue,
                              ),
                        ).tr(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
