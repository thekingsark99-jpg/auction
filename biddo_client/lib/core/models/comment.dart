import 'account.dart';

class Comment {
  final String id;
  final String content;
  final String accountId;
  final String? auctionId;
  final String? parentCommentId;

  final Account? account;

  List<Comment>? replies;

  DateTime? createdAt;
  DateTime? updatedAt;

  Comment({
    required this.id,
    required this.accountId,
    required this.content,
    this.auctionId,
    this.account,
    this.replies,
    this.parentCommentId,
    this.createdAt,
    this.updatedAt,
  });

  static Comment fromJSON(dynamic data) {
    var account =
        data['account'] != null ? Account.fromJSON(data['account']) : null;

    var replies = data['replies'] != null
        ? List<Comment>.from(
            data['replies'].map(
              (el) => Comment.fromJSON(el),
            ),
          )
        : null;

    return Comment(
      account: account,
      replies: replies,
      id: data['id'],
      accountId: data['accountId'],
      auctionId: data['auctionId'],
      content: data['content'],
      parentCommentId: data['parentCommentId'],
      createdAt:
          data['createdAt'] != null ? DateTime.parse(data['createdAt']) : null,
      updatedAt:
          data['updatedAt'] != null ? DateTime.parse(data['updatedAt']) : null,
    );
  }
}
