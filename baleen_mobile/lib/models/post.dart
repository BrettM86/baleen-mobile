import 'package:lemmy_api_client/v3.dart';

class Post {
  final int id;
  final int communityId;
  final String title;
  final String content;
  final String? imageUrl;
  final String communityName;
  final String authorName;
  final DateTime published;
  final int score;
  final int commentCount;
  final String instanceName;

  Post({
    required this.id,
    required this.communityId,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.communityName,
    required this.authorName,
    required this.published,
    required this.score,
    required this.commentCount,
    this.instanceName = '',
  });

  factory Post.fromLemmyPost(PostView postView) {
    // Extract instance name from actorId which is a URI
    String instanceName = '';
    try {
      final actorIdUri = Uri.parse(postView.community.actorId);
      instanceName = actorIdUri.host;
    } catch (e) {
      // If parsing fails, leave instanceName as empty string
    }
    
    return Post(
      id: postView.post.id,
      communityId: postView.community.id,
      title: postView.post.name,
      content: postView.post.body ?? '',
      imageUrl: postView.post.url,
      communityName: postView.community.name,
      authorName: postView.creator.name,
      published: postView.post.published,
      score: postView.counts.score,
      commentCount: postView.counts.comments,
      instanceName: instanceName,
    );
  }
}
