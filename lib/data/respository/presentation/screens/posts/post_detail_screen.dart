import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../config/theme/app_colors.dart';
import '../../../../models/post.dart';
import '../../../../../providers/comments_provider.dart';
import '../../widgets/comment_card.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/pagination_loader.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key, required this.post});
  final Post post;

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _scrollController = ScrollController();
  late CommentsProvider _provider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider = Provider.of<CommentsProvider>(context, listen: false);
      _provider.loadComments(widget.post.id);
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _provider.loadComments(widget.post.id);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Post Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<CommentsProvider>(
        builder: (context, provider, _) {
          final comments = provider.getComments(widget.post.id);
          final isLoading = provider.isLoading(widget.post.id);
          final error = provider.getError(widget.post.id);
          final hasMore = provider.hasMore(widget.post.id);

          return RefreshIndicator(
            onRefresh:
                () => provider.loadComments(widget.post.id, refresh: true),
            color: AppColors.primary,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Card(
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Chip(
                                label: Text('User ${widget.post.userId}'),
                                avatar: CircleAvatar(
                                  backgroundColor: AppColors.primary,
                                  child: Text(
                                    '${widget.post.userId}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Chip(label: Text('ID: ${widget.post.id}')),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.post.title,
                            style: Theme.of(
                              context,
                            ).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.post.body,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.comment_outlined,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Comments (${comments.length})',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (isLoading && comments.isEmpty)
                  const SliverFillRemaining(
                    child: LoadingIndicator(message: 'Loading comments...'),
                  )
                else if (error != null && comments.isEmpty)
                  SliverFillRemaining(
                    child: ErrorDisplay(
                      message: error,
                      onRetry:
                          () => provider.loadComments(
                            widget.post.id,
                            refresh: true,
                          ),
                    ),
                  )
                else if (comments.isEmpty)
                  const SliverFillRemaining(
                    child: Center(child: Text('No comments yet')),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if (index == comments.length) {
                        return hasMore
                            ? const PaginationLoader()
                            : const SizedBox.shrink();
                      }
                      return CommentCard(comment: comments[index]);
                    }, childCount: comments.length + (hasMore ? 1 : 0)),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
