import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/post.dart';
import '../utils/time_utils.dart';
import '../utils/url_utils.dart';
import '../constants/app_colors.dart';
import 'markdown_text.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final Map<String, dynamic> linkPreviews;
  final Map<String, bool> loadingStates;

  const PostCard({
    super.key,
    required this.post,
    required this.linkPreviews,
    required this.loadingStates,
  });

  @override
  Widget build(BuildContext context) {
    final timeAgo = TimeUtils.getTimeAgo(post.published);
    
    return Container(
      color: AppColors.background,
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
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          post.instanceName.isNotEmpty ? post.instanceName : 'Instance Name',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
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
                    // Headline
                    Text(
                      post.title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        height: 1.2
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Image or Link Preview
                    if (post.imageUrl != null) ...[
                      _buildImageOrLinkPreview(post.imageUrl!),
                      const SizedBox(height: 2),
                    ],
                    
                    // Excerpt / Body Snippet with Markdown
                    if (post.content.isNotEmpty) ...[
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  MarkdownText(
                                    data: post.content,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 13,
                                      height: 1.5,
                                    ),
                                    maxLines: 8,
                                    overflow: TextOverflow.fade,
                                  ),
                                  if (post.content.split('\n').length > 5 || post.content.length > 300)
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        height: 60,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              AppColors.background.withOpacity(0.0),
                                              AppColors.background.withOpacity(0.8),
                                              AppColors.background,
                                            ],
                                            stops: const [0.0, 0.7, 1.0],
                                          ),
                                        ),
                                        alignment: Alignment.bottomCenter,
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: 8),
                                          child: GestureDetector(
                                            onTap: () {
                                              // TODO: Implement read more functionality
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                              decoration: BoxDecoration(
                                                color: AppColors.cardBackground,
                                                borderRadius: BorderRadius.circular(4),
                                                border: Border.all(color: AppColors.border),
                                              ),
                                              child: const Text(
                                                'Expand',
                                                style: TextStyle(
                                                  color: AppColors.primary,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    // Divider
                    Container(
                      height: 1,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      color: AppColors.divider,
                    ),
                    
                    // Post Metadata Section
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left side: Username
                          GestureDetector(
                            onTap: () {
                              // TODO: Navigate to user profile
                            },
                            child: Text(
                              post.authorName,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          
                          // Right side: Stats and time
                          Row(
                            children: [
                              // Upvote count
                              Row(
                                children: [
                                  const Icon(
                                    Icons.arrow_upward,
                                    size: 16,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    post.score.toString(),
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              
                              // Comment count
                              Row(
                                children: [
                                  const Icon(
                                    Icons.comment_outlined,
                                    size: 16,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    post.commentCount.toString(),
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 6),
                              
                              // Time posted with clock icon
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    timeAgo,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
    final preview = linkPreviews[url];
    final isLoading = loadingStates[url] == true;
    
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
              color: AppColors.cardBackground,
              child: const Icon(Icons.error, color: AppColors.textPrimary),
            );
          },
        ),
      );
    }
    
    // For external links, show the preview container
    return GestureDetector(
      onTap: () async {
        await UrlUtils.launchUrl(url);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Preview Image
            if (isLoading)
              Container(
                height: 200,
                color: AppColors.cardBackground,
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
                      color: AppColors.cardBackground,
                      child: const Icon(Icons.error, color: AppColors.textPrimary),
                    );
                  },
                ),
              )
            else
              Container(
                height: 120,
                color: AppColors.cardBackground,
                child: const Center(child: Icon(Icons.link, color: AppColors.textPrimary, size: 48)),
              ),
            
            // Preview Text
            Container(
              width: double.infinity,
              color: AppColors.cardBackground,
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const Icon(
                    Icons.link,
                    size: 12,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    UrlUtils.getDomainFromUrl(url),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
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
}
