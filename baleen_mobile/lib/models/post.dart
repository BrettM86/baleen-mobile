class Post {
  final int id;
  final String name;
  final String body;
  final String url;
  final String creatorName;
  final int score;
  final DateTime published;
  final String communityName;
  final int commentCount;

  Post({
    required this.id,
    required this.name,
    required this.body,
    required this.url,
    required this.creatorName,
    required this.score,
    required this.published,
    required this.communityName,
    required this.commentCount,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['post']['id'],
      name: json['post']['name'],
      body: json['post']['body'] ?? '',
      url: json['post']['url'] ?? '',
      creatorName: json['creator']['name'],
      score: json['counts']['score'],
      published: DateTime.parse(json['post']['published']),
      communityName: json['community']['name'],
      commentCount: json['counts']['comments'],
    );
  }
}