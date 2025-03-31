import 'package:flutter/material.dart';
import '../models/post.dart';
import '../constants/app_colors.dart';

class SideActions extends StatelessWidget {
  final Post post;
  final VoidCallback? onUpvote;
  final VoidCallback? onComment;
  final VoidCallback? onShare;

  const SideActions({
    super.key,
    required this.post,
    this.onUpvote,
    this.onComment,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSideActionButton(
            icon: Icons.arrow_upward,
            label: post.score.toString(),
            onPressed: onUpvote,
          ),
          const SizedBox(height: 16),
          _buildSideActionButton(
            icon: Icons.comment,
            label: '${post.commentCount}',
            onPressed: onComment,
          ),
          const SizedBox(height: 16),
          _buildSideActionButton(
            icon: Icons.share,
            label: 'Share',
            onPressed: onShare,
          ),
        ],
      ),
    );
  }

  Widget _buildSideActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white.withAlpha(230),
            size: 28,
            shadows: [
              Shadow(
                color: Colors.black.withAlpha(77),
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
                  color: Colors.black.withAlpha(77),
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
