import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:url_launcher/url_launcher.dart';

import '../models/post.dart';
import '../services/lemmy_service.dart';



class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final _lemmyService = LemmyService();
  final _pageController = PageController();
  List<Post> _posts = [];
  bool _isLoading = true;
  String? _error;
  int _currentPage = 0;
  int _selectedIndex = 0;

  // Link previews
  Map<String, dynamic> _linkPreviews = {};
  Map<String, bool> _loadingStates = {};

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _fetchPosts() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final posts = await _lemmyService.getPosts();
      setState(() {
        _posts = posts;
        _isLoading = false;
      });
      
      // Fetch link previews for all posts with URLs
      for (final post in posts) {
        if (post.imageUrl != null) {
          _fetchLinkPreview(post.imageUrl!);
        }
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchLinkPreview(String url) async {
    if (_loadingStates[url] == true) return; // Already loading
    
    setState(() {
      _loadingStates[url] = true;
    });

    try {
      // Check if it's a Lemmy image via pictrs usage
      if (url.contains('pictrs')) {
        setState(() {
          _linkPreviews[url] = {
            'imageUrl': url,
            'isLemmyImage': true,
          };
          _loadingStates[url] = false;
        });
        return;
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final document = parser.parse(response.body);
        final title = document.querySelector('title')?.text ?? '';
        final description = document.querySelector('meta[name="description"]')?.attributes['content'] ?? '';
        final imageUrl = document.querySelector('meta[property="og:image"]')?.attributes['content'] ??
                        document.querySelector('meta[name="twitter:image"]')?.attributes['content'];

        setState(() {
          _linkPreviews[url] = {
            'title': title,
            'description': description,
            'imageUrl': imageUrl,
            'isLemmyImage': false,
          };
          _loadingStates[url] = false;
        });
      } else {
        setState(() {
          _linkPreviews[url] = {
            'isLemmyImage': false,
            'error': true,
          };
          _loadingStates[url] = false;
        });
      }
    } catch (e) {
      setState(() {
        _linkPreviews[url] = {
          'isLemmyImage': false,
          'error': true,
        };
        _loadingStates[url] = false;
      });
    }
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        _fetchPosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF1A1A1A),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: $_error',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchPosts,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_posts.isEmpty) {
      return const Center(
        child: Text('No posts found'),
      );
    }

    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: _posts.length,
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
      itemBuilder: (context, index) {
        final post = _posts[index];
        return Stack(
          children: [
            _buildPostCard(post),
            _buildSideActions(post),
          ],
        );
      },
    );
  }

  Widget _buildPostCard(Post post) {
    final timeAgo = _getTimeAgo(post.published);
    
    return Container(
      color: const Color(0xFF1A1A1A),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    radius: 24,
                    child: Text(
                      post.communityName[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.communityName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Instance Name',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Post Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User and Source Info Line
                    Row(
                      children: [
                        Text(
                          post.authorName,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '•',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          timeAgo,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Headline
                    Text(
                      post.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Image or Link Preview
                    if (post.imageUrl != null) ...[
                      _buildImageOrLinkPreview(post.imageUrl!),
                      const SizedBox(height: 16),
                    ],
                    
                    // Excerpt / Body Snippet
                    if (post.content.isNotEmpty) ...[
                      Text(
                        post.content,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.5,
                        ),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageOrLinkPreview(String url) {
    final preview = _linkPreviews[url];
    final isLoading = _loadingStates[url] == true;
    
    // If it's a Lemmy image, show it as a full-width image
    if (preview != null && preview['isLemmyImage'] == true) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          preview['imageUrl']!,
          fit: BoxFit.contain,
          width: double.infinity,
          height: 600,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 200,
              color: Colors.grey[800],
              child: const Icon(Icons.error, color: Colors.white),
            );
          },
        ),
      );
    }
    
    // For external links, show the preview container
    return GestureDetector(
      onTap: () async {
        if (await canLaunch(url)) {
          await launch(url);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[800]!),
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview Image
            if (isLoading)
              Container(
                height: 200,
                color: Colors.grey[800],
                child: const Center(child: CircularProgressIndicator()),
              )
            else if (preview != null && preview['imageUrl'] != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  preview['imageUrl']!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[800],
                      child: const Icon(Icons.error, color: Colors.white),
                    );
                  },
                ),
              )
            else
              Container(
                height: 120,
                color: Colors.grey[800],
                child: const Center(child: Icon(Icons.link, color: Colors.white, size: 48)),
              ),
            
            // Preview Text
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isLoading && preview != null && preview['title'] != null)
                    Text(
                      preview['title']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (!isLoading && preview != null && preview['description'] != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      preview['description']!,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    _getDomainFromUrl(url),
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper to extract domain from URL
  String _getDomainFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host;
    } catch (e) {
      return url;
    }
  }



  String _getTimeAgo(DateTime published) {
    final now = DateTime.now();
    final difference = now.difference(published);
    if (difference.inMinutes < 60)
      return '${difference.inMinutes}m';
    if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }

  Widget _buildSideActions(Post post) {
    return Positioned(
      right: 16,
      bottom: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSideActionButton(
            icon: Icons.arrow_upward,
            label: post.score.toString(),
            onPressed: () {
              // TODO: Implement upvote
            },
          ),
          const SizedBox(height: 16),
          _buildSideActionButton(
            icon: Icons.comment,
            label: '${post.commentCount}',
            onPressed: () {
              // TODO: Navigate to comments
            },
          ),
          const SizedBox(height: 16),
          _buildSideActionButton(
            icon: Icons.share,
            label: 'Share',
            onPressed: () {
              // TODO: Implement share
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSideActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 28,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 2),
                blurRadius: 3,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 2),
                  blurRadius: 3,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
} 