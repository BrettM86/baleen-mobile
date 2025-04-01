import 'package:flutter/material.dart';
import '../models/post.dart';
import '../constants/app_colors.dart';

class SideActions extends StatelessWidget {
  final Post post;
  final VoidCallback? onUpvote;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onFavorite;

  const SideActions({
    super.key,
    required this.post,
    this.onUpvote,
    this.onComment,
    this.onShare,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Share button (left)
            GestureDetector(
              onTap: onShare,
              child: const Icon(
                Icons.share_outlined,
                color: AppColors.textSecondary,
                size: 24,
              ),
            ),
            
            // Favorite/Bookmark button
            GestureDetector(
              onTap: onFavorite,
              child: const Icon(
                Icons.bookmark_border_outlined,
                color: AppColors.textSecondary,
                size: 24,
              ),
            ),
            
            // Comment button (middle)
            GestureDetector(
              onTap: onComment,
              child: const Icon(
                Icons.comment_outlined,
                color: AppColors.textSecondary,
                size: 24,
              ),
            ),
            
            // Upvote button (right)
            GestureDetector(
              onTap: onUpvote,
              child: const Icon(
                Icons.keyboard_arrow_up,
                color: AppColors.primary,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
