import 'package:get/get.dart';

import '../models/comment.dart';
import 'base.dart';

class CommentRepository {
  var dio = Get.find<Api>();

  Future<Comment?> create(
    String content,
    String auctionId, [
    String? parentCommentId,
  ]) async {
    var commentContent = content.replaceAll('\n\n\n\n\n\n', '\n');

    try {
      var result = await dio.api.post('/comment', data: {
        "auctionId": auctionId,
        "content": commentContent,
        "parentCommentId": parentCommentId
      });

      return Comment.fromJSON(result.data);
    } catch (error) {
      print('Could not create comment: $error');
      return null;
    }
  }

  Future<List<Comment>?> getComments(String auctionId) async {
    try {
      var result = await dio.api.get('/comment/auction/$auctionId');

      return List<Comment>.from(
          result.data.map((comment) => Comment.fromJSON(comment)));
    } catch (error) {
      print('Could not get comments for auction: $error');
      return null;
    }
  }

  Future<int> countForAuction(String auctionId) async {
    try {
      var result = await dio.api.get('/comment/count/$auctionId');
      return result.data;
    } catch (error) {
      print('Could not get comment count for auction: $error');
      return 0;
    }
  }

  Future<String?> translate(String commentId, String lang) async {
    try {
      var response = await dio.api.get('/comment/translate/$commentId/$lang');
      return response.data['content'];
    } catch (error, stackTrace) {
      print('Error translating comment: $error $stackTrace');
      return null;
    }
  }
}
