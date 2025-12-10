import '../../config/constants/app_constants.dart';
import '../../core/network/api_client.dart';
import '../models/post.dart';
import '../models/comment.dart';

class ApiRepository {
  final ApiClient _apiClient;

  ApiRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  // Posts
  Future<List> getPosts({int page = 1, String? search}) async {
    final start = (page - 1) * AppConstants.pageSize;

    final response = await _apiClient.get(
      AppConstants.postsEndpoint,
      queryParameters: {
        '_start': start.toString(),
        '_limit': AppConstants.pageSize.toString(),
        if (search != null && search.isNotEmpty) 'q': search,
      },
    );

    return (response as List).map((json) => Post.fromJson(json)).toList();
  }

  Future<List> getPostComments({required int postId, int page = 1}) async {
    final start = (page - 1) * AppConstants.pageSize;

    final response = await _apiClient.get(
      AppConstants.commentsEndpoint,
      queryParameters: {
        'postId': postId.toString(),
        '_start': start.toString(),
        '_limit': AppConstants.pageSize.toString(),
      },
    );

    return (response as List).map((json) => Comment.fromJson(json)).toList();
  }
}
