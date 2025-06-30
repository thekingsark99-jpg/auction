import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../../core/controllers/comment.dart';
import '../../../core/controllers/flash.dart';
import '../../../core/models/comment.dart';
import '../../../core/services/lang_detector.dart';
import '../../../theme/colors.dart';
import '../../../theme/extensions/base.dart';

class CommentContent extends StatefulWidget {
  final Comment comment;

  const CommentContent({super.key, required this.comment});

  @override
  // ignore: library_private_types_in_public_api
  _CommentContentState createState() => _CommentContentState();
}

class _CommentContentState extends State<CommentContent> {
  final languageDetectorService = Get.find<LanguageDetectorService>();
  final commentController = Get.find<CommentsController>();
  final flashController = Get.find<FlashController>();

  var _translationInProgress = false;
  var _showTranslatedDetails = false;
  var _translatedContent = '';

  Future<void> handleTranslate() async {
    if (_translationInProgress) {
      return;
    }

    if (_showTranslatedDetails) {
      setState(() {
        _showTranslatedDetails = false;
      });
      return;
    }

    if (!_showTranslatedDetails && _translatedContent.isNotEmpty) {
      setState(() {
        _showTranslatedDetails = true;
      });
      return;
    }

    setState(() {
      _translationInProgress = true;
    });

    var translatedContent = await commentController.translate(
      widget.comment.id,
      context.locale.toString(),
    );

    if (translatedContent == null) {
      flashController.showMessageFlash(tr('generic.short_error'));
      setState(() {
        _translationInProgress = false;
      });
      return;
    }

    setState(() {
      _translationInProgress = false;
      _showTranslatedDetails = !_showTranslatedDetails;
      _translatedContent = translatedContent;
    });
  }

  Widget _renderTranslateAction() {
    var currentLanguage = context.locale.toString();
    var contentLang =
        languageDetectorService.detectLanguage(widget.comment.content);
    var translationEnabled = currentLanguage != contentLang;

    if (!translationEnabled) {
      return Container();
    }

    return GestureDetector(
      onTap: () {
        handleTranslate();
      },
      child: Container(
        height: 17,
        margin: EdgeInsets.only(top: 8, bottom: 8),
        child: Row(
          children: [
            _translationInProgress
                ? const SpinKitThreeBounce(
                    color: DarkColors.font_1,
                    size: 17,
                  )
                : Text(
                    _showTranslatedDetails
                        ? 'generic.see_original'
                        : 'generic.translate',
                    style: Theme.of(context)
                        .extension<CustomThemeFields>()!
                        .smallest,
                  ).tr(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var content = widget.comment.content;

    return Container(
      margin: const EdgeInsets.only(
        left: 10,
        top: 4,
        right: 10,
      ),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).extension<CustomThemeFields>()!.background_3,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _showTranslatedDetails ? _translatedContent : content,
              style: Theme.of(context).extension<CustomThemeFields>()!.smaller,
            ),
            _renderTranslateAction(),
          ],
        ),
      ),
    );
  }
}
