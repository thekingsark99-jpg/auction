import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:get/get.dart';

import '../../../core/controllers/account.dart';
import '../../../core/models/comment.dart';
import '../../../core/navigator.dart';
import '../../../core/services/lang_detector.dart';
import '../../../theme/extensions/base.dart';
import 'account_avatar.dart';
import 'comment_content.dart';
import 'name_and_date.dart';
import 'reply.dart';

class CommentItem extends StatelessWidget {
  final bool isSelected;
  final Comment comment;
  final Function handleReply;
  final bool? simple;
  final navigatorService = Get.find<NavigatorService>();

  CommentItem({
    super.key,
    required this.comment,
    required this.isSelected,
    required this.handleReply,
    this.simple = false,
  });

  final accountController = Get.find<AccountController>();
  final languageDetectorService = Get.find<LanguageDetectorService>();

  Widget _renderMessageReplies(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(start: 16),
      child: Column(
        children: [
          for (var reply in comment.replies!) CommentReply(reply: reply)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      width: Get.width,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      color: simple == true
          ? Colors.transparent
          : isSelected
              ? Theme.of(context)
                  .extension<CustomThemeFields>()!
                  .background_3
                  .withOpacity(0.7)
              : Theme.of(context).extension<CustomThemeFields>()!.background_2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommentAccountAvatar(account: comment.account!),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommentNameAndDate(comment: comment),
                CommentContent(comment: comment),
                comment.parentCommentId != null || simple == true
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ScaleTap(
                            onPressed: () {
                              handleReply(comment);
                            },
                            child: Container(
                              color: isSelected
                                  ? Colors.transparent
                                  : Theme.of(context)
                                      .extension<CustomThemeFields>()!
                                      .background_2,
                              padding: const EdgeInsets.only(
                                left: 16,
                                top: 4,
                                bottom: 4,
                                right: 16,
                              ),
                              child: Text(
                                'comments.reply',
                                style: Theme.of(context)
                                    .extension<CustomThemeFields>()!
                                    .smallest
                                    .copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                              ).tr(),
                            ),
                          ),
                        ],
                      ),
                comment.replies != null &&
                        comment.replies!.isNotEmpty &&
                        simple == false
                    ? _renderMessageReplies(context)
                    : Container(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
