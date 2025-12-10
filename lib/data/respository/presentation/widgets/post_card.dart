// import 'package:flutter/material.dart';
// import 'package:flutter_test_code/config/theme/app_colors.dart';
// import 'package:flutter_test_code/data/models/post.dart';

// class PostCard extends StatelessWidget {
//   final Post post;
//   final VoidCallback onTap;

//   const PostCard({super.key, required this.post, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(16),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 16,
//                     backgroundColor: AppColors.primary.withOpacity(0.1),
//                     child: Text(
//                       '#${post.id}',
//                       style: const TextStyle(
//                         color: AppColors.primary,
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Text(
//                       'User ${post.userId}',
//                       style: Theme.of(context).textTheme.labelLarge?.copyWith(
//                         color: AppColors.textSecondary,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                   Icon(
//                     Icons.chevron_right,
//                     color: AppColors.textTertiary,
//                     size: 20,
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 post.title,
//                 style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.textPrimary,
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 post.body,
//                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                   color: AppColors.textSecondary,
//                   height: 1.5,
//                 ),
//                 maxLines: 3,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_code/config/theme/app_colors.dart';
import 'package:flutter_test_code/data/models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;

  const PostCard({super.key, required this.post, required this.onTap});

  String _imageUrlForPost(Post p) {
    return 'https://picsum.photos/seed/post_${p.id}/800/420';
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _imageUrlForPost(post);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(16),
        shadowColor: Colors.black.withOpacity(0.08),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                        errorWidget:
                            (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, size: 50),
                            ),
                      ),
                    ),

                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.35),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      left: 12,
                      top: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '#${post.id}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: AppColors.primary.withValues(
                              alpha: 0.1,
                            ),
                            backgroundImage: CachedNetworkImageProvider(
                              'https://i.pravatar.cc/150?u=${post.userId}',
                            ),
                          ),
                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              'User ${post.userId}',
                              style: Theme.of(
                                context,
                              ).textTheme.labelLarge?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          Icon(
                            Icons.today,
                            size: 18,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${(post.id % 24) + 1}h',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: AppColors.textTertiary),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Text(
                        post.title,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        post.body,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          _IconTextButton(
                            icon: Icons.thumb_up_outlined,
                            label: "Like",
                          ),
                          const SizedBox(width: 12),
                          _IconTextButton(
                            icon: Icons.comment_outlined,
                            label: "Comments",
                          ),
                          const Spacer(),
                          Icon(
                            Icons.chevron_right,
                            size: 22,
                            color: AppColors.textTertiary,
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
      ),
    );
  }
}

class _IconTextButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _IconTextButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textTertiary),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
