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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Upvote button
            GestureDetector(
              onTap: onUpvote,
              child: const Icon(
                Icons.keyboard_arrow_up,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(height: 16),
            
            // Comment button
            GestureDetector(
              onTap: onComment,
              child: const Icon(
                Icons.comment_outlined,
                color: AppColors.textSecondary,
                size: 24,
              ),
            ),
            const SizedBox(height: 16),

            // Share button
            GestureDetector(
              onTap: onShare,
              child: const Icon(
                Icons.share_outlined,
                color: AppColors.textSecondary,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
