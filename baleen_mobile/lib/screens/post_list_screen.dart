import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/lemmy_service.dart';
import '../services/link_preview_service.dart';
import '../widgets/post_card.dart';
import '../widgets/side_actions.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final _lemmyService = LemmyService();
  final _linkPreviewService = LinkPreviewService();
  final _pageController = PageController();
  List<Post> _posts = [];
  bool _isLoading = true;
  String? _error;
  int _currentPage = 0;
  int _selectedIndex = 0;

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
          await _linkPreviewService.fetchLinkPreview(post.imageUrl!);
          // Update state to reflect new previews
          setState(() {});
        }
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
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
      return const LoadingView();
    }

    if (_error != null) {
      return ErrorView(
        message: _error!,
        onRetry: _fetchPosts,
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
            PostCard(
              post: post,
              linkPreviews: _linkPreviewService.linkPreviews,
              loadingStates: _linkPreviewService.loadingStates,
            ),
            SideActions(
              post: post,
              onUpvote: () {
                // TODO: Implement upvote
              },
              onComment: () {
                // TODO: Navigate to comments
              },
              onShare: () {
                // TODO: Implement share
              },
            ),
          ],
        );
      },
    );
  }
}
