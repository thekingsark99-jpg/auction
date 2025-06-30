import 'package:flutter/material.dart';
import '../../../core/models/comment.dart';
import 'account_avatar.dart';
import 'comment_content.dart';
import 'name_and_date.dart';

class CommentReply extends StatefulWidget {
  final Comment reply;

  const CommentReply({super.key, required this.reply});

  @override
  // ignore: library_private_types_in_public_api
  _CommentReplyState createState() => _CommentReplyState();
}

class _CommentReplyState extends State<CommentReply> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommentAccountAvatar(
            account: widget.reply.account!,
            small: true,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommentNameAndDate(comment: widget.reply),
                CommentContent(comment: widget.reply),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
