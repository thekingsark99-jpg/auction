import 'package:biddo/theme/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../core/controllers/comment.dart';
import '../../../core/models/comment.dart';
import '../../../theme/extensions/base.dart';
import '../../../utils/generic.dart';
import '../../../widgets/common/action_button.dart';
import 'comment.dart';

class AuctionCommentsList extends StatefulWidget {
  final String auctionId;
  final int commentsCount;
  final Function? onCommentCreated;

  const AuctionCommentsList({
    super.key,
    required this.auctionId,
    required this.commentsCount,
    this.onCommentCreated,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AuctionCommentsListState createState() => _AuctionCommentsListState();
}

class _AuctionCommentsListState extends State<AuctionCommentsList> {
  final commentsController = Get.find<CommentsController>();
  final _controller = TextEditingController();

  final RxList<Comment> _auctionComments = <Comment>[].obs;
  final Rx<Comment?> _replyingComment = Rx<Comment?>(null);

  final Rx<bool> _pointerDownInner = false.obs;

  final Rx<bool> _messageIsEmpty = true.obs;
  final Rx<bool> _sendInProgress = false.obs;
  final Rx<bool> _initialLoad = true.obs;
  final RxInt _commentsCount = 0.obs;

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadComments();

    _commentsCount.value = widget.commentsCount;

    _controller.addListener(() {
      _messageIsEmpty.value = _controller.text.isEmpty;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    var comments = await commentsController.getComments(widget.auctionId);
    if (comments == null) {
      _initialLoad.value = false;
      _initialLoad.refresh();
      return;
    }

    var sortedComments = comments
      ..sort((a, b) => a.createdAt!.compareTo(b.createdAt!));

    for (var comment in sortedComments) {
      if (comment.replies != null) {
        comment.replies!.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
      }
    }

    _auctionComments.clear();
    _auctionComments.addAll(sortedComments);
    _auctionComments.refresh();

    _initialLoad.value = false;
    _initialLoad.refresh();

    _scrollToNewComment();
  }

  void handleReply(Comment comment) {
    if (_replyingComment.value != null &&
        _replyingComment.value!.id == comment.id) {
      _replyingComment.value = null;
      setState(() {});
      return;
    }

    _replyingComment.value = comment;
    setState(() {});
  }

  Future<void> handleSend() async {
    if (_controller.text.isEmpty || _sendInProgress.value) {
      return;
    }

    _sendInProgress.value = true;

    Comment? result = await commentsController.create(
      _controller.text,
      widget.auctionId,
      _replyingComment.value?.id,
    );

    _sendInProgress.value = false;

    if (result == null) {
      return;
    }

    if (widget.onCommentCreated != null) {
      widget.onCommentCreated!();
    }

    _commentsCount.value += 1;
    _commentsCount.refresh();

    if (result.parentCommentId != null) {
      var parentComment = _auctionComments
          .firstWhere((element) => element.id == result.parentCommentId);

      parentComment.replies ??= <Comment>[];

      var alreadyExists =
          parentComment.replies!.any((element) => element.id == result.id);

      if (alreadyExists) {
        _auctionComments.refresh();
        _controller.clear();
        return;
      }

      parentComment.replies!.add(result);
      _auctionComments.refresh();
      _controller.clear();
      return;
    }

    _auctionComments.add(result);
    _scrollToNewComment();
    _controller.clear();
  }

  void _scrollToNewComment() {
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 200),
        );
      }
    });
  }

  Widget _renderLoadingScreen() {
    return SizedBox(
      width: Get.width,
      height: double.infinity,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 3,
          color: Theme.of(context).extension<CustomThemeFields>()!.fontColor_1,
        ),
      ),
    );
  }

  Widget _renderNoMessages() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/svg/chat-color.svg',
            height: 160,
            semanticsLabel: 'No chat groups',
          ),
          Container(
            height: 32,
          ),
          Text(
            tr("comments.be_the_first"),
            style: Theme.of(context)
                .extension<CustomThemeFields>()!
                .smaller
                .copyWith(
                  fontWeight: FontWeight.w500,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _renderCommentsList() {
    return ListView.builder(
      itemCount: _auctionComments.length,
      shrinkWrap: true,
      controller: _scrollController,
      itemBuilder: (_, index) {
        var comment = _auctionComments[index];
        return Container(
          margin: EdgeInsets.only(
              bottom: index == _auctionComments.length - 1 ? 16 : 0),
          child: CommentItem(
            comment: comment,
            isSelected: (_replyingComment.value != null &&
                _replyingComment.value!.id == comment.id),
            handleReply: handleReply,
          ),
        );
      },
    );
  }

  Widget _renderInputAndSendButton() {
    return Row(children: [
      Expanded(
        child: TextField(
          maxLines: 20,
          minLines: 1,
          maxLength: 1000,
          controller: _controller,
          style: Theme.of(context).extension<CustomThemeFields>()!.smaller,
          scrollPadding: const EdgeInsets.only(
            bottom: 130,
          ),
          decoration: InputDecoration(
            hintText: tr('comments.leave_message'),
            counterText: '',
            fillColor: Theme.of(context)
                .extension<CustomThemeFields>()!
                .separator
                .withOpacity(0.6),
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
      Container(
        width: 8,
      ),
      Obx(
        () => AnimatedContainer(
          duration: const Duration(seconds: 1),
          child: ActionButton(
            isLoading: _sendInProgress.value,
            filled: false,
            radius: 8,
            width: 44,
            height: 44,
            background: _messageIsEmpty.value
                ? Theme.of(context).extension<CustomThemeFields>()!.separator
                : Theme.of(context).extension<CustomThemeFields>()!.action,
            onPressed: () {
              handleSend();
            },
            border: Border.all(
              color: _messageIsEmpty.value
                  ? Theme.of(context).extension<CustomThemeFields>()!.separator
                  : Theme.of(context).extension<CustomThemeFields>()!.action,
            ),
            child: Icon(
              Icons.send,
              size: 20,
              color: _messageIsEmpty.value
                  ? Theme.of(context)
                      .extension<CustomThemeFields>()!
                      .fontColor_1
                  : DarkColors.font_1,
            ),
          ),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
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
        child: Container(
          padding: EdgeInsets.only(top: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    if (_replyingComment.value != null) {
                      _replyingComment.value = null;
                      setState(() {});
                      return;
                    }
                  },
                  child: Container(
                    height: double.infinity,
                    color: Theme.of(context)
                        .extension<CustomThemeFields>()!
                        .background_2,
                    width: Get.width,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Obx(
                                  () => Text(
                                    'comments.count',
                                    style: Theme.of(context)
                                        .extension<CustomThemeFields>()!
                                        .title,
                                  ).tr(namedArgs: {
                                    'no': _commentsCount.toString()
                                  }),
                                ),
                              ),
                              IconButton(
                                splashRadius: 24,
                                iconSize: 14,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: SvgPicture.asset(
                                  'assets/icons/svg/close.svg',
                                  semanticsLabel: 'Close',
                                  height: 20,
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context)
                                        .extension<CustomThemeFields>()!
                                        .fontColor_1,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Obx(
                          () => Expanded(
                            child: _initialLoad.value == true
                                ? _renderLoadingScreen()
                                : _auctionComments.isEmpty
                                    ? _renderNoMessages()
                                    : _renderCommentsList(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: Get.width,
                color: Theme.of(context)
                    .extension<CustomThemeFields>()!
                    .background_1,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => _replyingComment.value?.id != null
                          ? Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'comments.replying_to',
                                style: Theme.of(context)
                                    .extension<CustomThemeFields>()!
                                    .smallest,
                              ).tr(
                                namedArgs: {
                                  'name': GenericUtils.generateNameForAccount(
                                      _replyingComment.value!.account)
                                },
                              ),
                            )
                          : Container(),
                    ),
                    _renderInputAndSendButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
