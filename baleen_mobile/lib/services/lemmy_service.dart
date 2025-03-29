import 'package:lemmy_api_client/v3.dart' as lemmy;
import '../models/post.dart';

class LemmyService {
  final lemmy.LemmyApiV3 _api;
  static const String _defaultInstance = 'lemmy.world';

  LemmyService({String? instance}) : _api = lemmy.LemmyApiV3(instance ?? _defaultInstance);

  Future<List<Post>> getPosts({
    int page = 1,
    int limit = 20,
    lemmy.SortType sortType = lemmy.SortType.hot,
  }) async {
    try {
      final response = await _api.run(
        lemmy.GetPosts(
          page: page,
          limit: limit,
          sort: sortType,
        ),
      );

      return response.posts.map((postView) => Post.fromLemmyPost(postView)).toList();
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }
} 