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
  });

  factory Post.fromLemmyPost(PostView postView) {
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
    );
  }
} 