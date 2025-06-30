import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:get/get.dart';

import '../../../core/controllers/comment.dart';
import '../../../theme/extensions/base.dart';
import 'comments_list.dart';

class AuctionDetailsCommentsButton extends StatefulWidget {
  final String auctionId;

  const AuctionDetailsCommentsButton({
    super.key,
    required this.auctionId,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AuctionDetailsCommentsButtonState createState() =>
      _AuctionDetailsCommentsButtonState();
}

class _AuctionDetailsCommentsButtonState
    extends State<AuctionDetailsCommentsButton> {
  final commentsController = Get.find<CommentsController>();

  RxInt commentsCount = 0.obs;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    commentsCount.value =
        await commentsController.countForAuction(widget.auctionId);
    commentsCount.refresh();
  }

  void _openCommentsBottomSheet() {
    showModalBottomSheet(
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor:
          Theme.of(context).extension<CustomThemeFields>()!.background_2,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: FractionallySizedBox(
            heightFactor: 0.9,
            child: AuctionCommentsList(
              auctionId: widget.auctionId,
              commentsCount: commentsCount.value,
              onCommentCreated: () {
                commentsCount += 1;
                commentsCount.refresh();
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTap(
        onPressed: () {
          _openCommentsBottomSheet();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color:
                Theme.of(context).extension<CustomThemeFields>()!.fontColor_1,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context)
                  .extension<CustomThemeFields>()!
                  .background_1,
            ),
          ),
          child: Obx(
            () => Text(
              'comments.count',
              style: Theme.of(context)
                  .extension<CustomThemeFields>()!
                  .smaller
                  .copyWith(
                    color: Theme.of(context)
                        .extension<CustomThemeFields>()!
                        .background_1,
                  ),
            ).tr(namedArgs: {
              'no': commentsCount.value.toString(),
            }),
          ),
        ),
      ),
    );
  }
}
