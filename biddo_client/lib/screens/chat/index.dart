import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/controllers/account.dart';
import '../../core/controllers/chat.dart';
import '../../core/controllers/main.dart';
import '../../core/models/chat_group.dart';
import 'app_bar.dart';
import 'widgets/chat_group_card.dart';
import 'widgets/no_chat_groups.dart';
import 'widgets/sort_popup.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final mainController = Get.find<MainController>();
  final chatController = Get.find<ChatController>();
  final accountController = Get.find<AccountController>();

  final Rx<bool> _pointerDownInner = false.obs;

  var _currentSort = ChatGroupsSortBy.newest;
  late StreamSubscription<List<ChatGroup>> _chatGroupsSubscription;

  final _sellingChatGroups = RxList<Rx<ChatGroup>>();
  final _buyingGroups = RxList<Rx<ChatGroup>>();

  @override
  void initState() {
    super.initState();

    sortChatGroups();

    _chatGroupsSubscription = chatController.chatGroups.listen((_) {
      if (mounted) {
        sortChatGroups();
      }
    });
  }

  @override
  void dispose() {
    _chatGroupsSubscription.cancel();
    super.dispose();
  }

  void sortChatGroups() {
    var currentAcountId = accountController.account.value.id;

    setState(() {
      var initialChatGroups = chatController.chatGroups.toList();

      _sellingChatGroups.clear();
      _buyingGroups.clear();

      for (var chatGroup in initialChatGroups) {
        if (chatGroup.initiatedBy == currentAcountId) {
          _buyingGroups.add(chatGroup.obs);
        } else {
          _sellingChatGroups.add(chatGroup.obs);
        }
      }

      _sellingChatGroups.sort((a, b) {
        switch (_currentSort) {
          case ChatGroupsSortBy.newest:
            return b.value.lastMessageAt != null
                ? b.value.lastMessageAt!
                    .compareTo(a.value.lastMessageAt ?? DateTime.now())
                : 1;
          case ChatGroupsSortBy.oldest:
            return a.value.lastMessageAt != null
                ? a.value.lastMessageAt!
                    .compareTo(b.value.lastMessageAt ?? DateTime.now())
                : -1;
        }
      });

      _buyingGroups.sort((a, b) {
        switch (_currentSort) {
          case ChatGroupsSortBy.newest:
            return b.value.lastMessageAt != null
                ? b.value.lastMessageAt!
                    .compareTo(a.value.lastMessageAt ?? DateTime.now())
                : 1;
          case ChatGroupsSortBy.oldest:
            return a.value.lastMessageAt != null
                ? a.value.lastMessageAt!
                    .compareTo(b.value.lastMessageAt ?? DateTime.now())
                : -1;
        }
      });

      _sellingChatGroups.refresh();
      _buyingGroups.refresh();
    });
  }

  void goBack() {
    Navigator.of(context).pop();
  }

  void handleSortChange(ChatGroupsSortBy sort) {
    setState(() {
      _currentSort = sort;
    });

    sortChatGroups();
  }

  Widget _renderChatGroups(RxList<Rx<ChatGroup>> chatGroups) {
    return Container(
      constraints: BoxConstraints(minHeight: Get.height - 300),
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          for (var chatGroup in chatGroups)
            ChatGroupCard(
              group: chatGroup.value,
            ),
        ],
      ),
    );
  }

  Widget _renderSellingChatGroups() {
    if (_sellingChatGroups.isEmpty) {
      return NoChatGroupsMessage(
        forBuying: false,
      );
    }

    return _renderChatGroups(_sellingChatGroups);
  }

  Widget _renderBuyingChatGroups() {
    if (_buyingGroups.isEmpty) {
      return NoChatGroupsMessage(
        forBuying: true,
      );
    }

    return _renderChatGroups(_buyingGroups);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: (_) {
          if (_pointerDownInner.value) {
            _pointerDownInner.value = false;
            return;
          }

          _pointerDownInner.value = false;
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Obx(
          () => ChatAppBar(
            forSaleChats: _renderSellingChatGroups(),
            toBuyChats: _renderBuyingChatGroups(),
            forSaleChatsLen: _sellingChatGroups.length,
            toBuyChatsLet: _buyingGroups.length,
            currentSort: _currentSort,
            handleSortChange: (ChatGroupsSortBy newSortValue) {
              handleSortChange(newSortValue);
            },
          ),
        ),
      ),
    );
  }
}
