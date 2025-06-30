import 'package:get/get.dart';
import 'package:profanity_filter/profanity_filter.dart';

import '../models/comment.dart';
import '../repositories/comment.dart';

class CommentsController extends GetxController {
  final commentRepository = Get.find<CommentRepository>();

  Future<Comment?> create(
    String content,
    String auctionId, [
    String? parentCommentId,
  ]) async {
    final filter = ProfanityFilter();
    var cleanContent = filter.censor(content);
    return commentRepository.create(cleanContent, auctionId, parentCommentId);
  }

  Future<List<Comment>?> getComments(String auctionId) async {
    return commentRepository.getComments(auctionId);
  }

  Future<int> countForAuction(String auctionId) async {
    return commentRepository.countForAuction(auctionId);
  }

  Future<String?> translate(String commentId, String language) async {
    return commentRepository.translate(commentId, language);
  }
}
