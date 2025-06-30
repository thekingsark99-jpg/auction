import 'package:get/get.dart';

import 'account.dart';
import 'auction.dart';

class ChatGroup {
  String id;
  String firstAccountId;
  String secondAccountId;
  String? initiatedBy;

  int? unreadMessages;

  DateTime createdAt;
  DateTime updatedAt;
  DateTime? lastMessageAt;

  Account? firstAccount;
  Account? secondAccount;

  RxList<Auction>? chatGroupAuctions;

  ChatGroup({
    required this.id,
    required this.firstAccountId,
    required this.secondAccountId,
    required this.createdAt,
    required this.updatedAt,
    this.initiatedBy,
    this.chatGroupAuctions,
    this.firstAccount,
    this.secondAccount,
    this.lastMessageAt,
    this.unreadMessages,
  });

  static ChatGroup fromJSON(dynamic data) {
    var firstAccount = data['firstAccount'] != null
        ? Account.fromJSON(data['firstAccount'])
        : null;

    var secondAccount = data['secondAccount'] != null
        ? Account.fromJSON(data['secondAccount'])
        : null;

    var lastMessageAt = data['lastMessageAt'] != null
        ? DateTime.parse(data['lastMessageAt'])
        : null;

    var chatGroupAuctions = data['chatGroupAuctions'] != null
        ? (data['chatGroupAuctions'] as List<dynamic>)
            .map((e) => Auction.fromJSON(e))
            .toList()
            .obs
        : null;

    return ChatGroup(
      id: data['id'],
      firstAccountId: data['firstAccountId'],
      secondAccountId: data['secondAccountId'],
      initiatedBy: data['initiatedBy'],
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
      firstAccount: firstAccount,
      secondAccount: secondAccount,
      lastMessageAt: lastMessageAt,
      chatGroupAuctions: chatGroupAuctions,
      unreadMessages: data['unreadMessages'],
    );
  }
}
