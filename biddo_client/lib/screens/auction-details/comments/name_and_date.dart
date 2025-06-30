import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/models/comment.dart';
import '../../../theme/extensions/base.dart';
import '../../../utils/generic.dart';

class CommentNameAndDate extends StatelessWidget {
  final Comment comment;

  const CommentNameAndDate({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              GenericUtils.generateNameForAccount(comment.account!),
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).extension<CustomThemeFields>()!.smaller,
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              DateFormat('d MMM, h:mm a').format(comment.createdAt!),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).extension<CustomThemeFields>()!.smallest,
            ),
          ),
        ],
      ),
    );
  }
}
