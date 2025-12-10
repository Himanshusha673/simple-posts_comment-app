import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../config/theme/app_colors.dart';
import '../../../../../core/utils/debouncer.dart';
import '../../../../../providers/posts_provider.dart';
import '../../widgets/post_card.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/pagination_loader.dart';
import 'post_detail_screen.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  final _debouncer = Debouncer();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    // Trigger initial load after first frame so Provider is available in the tree
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final provider = Provider.of<PostsProvider>(context, listen: false);
    //   provider.loadPosts();
    // });
  }

  void _onScroll() {
    final provider = Provider.of<PostsProvider>(context, listen: false);
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      provider.loadPosts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Posts',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<PostsProvider>(
              builder: (context, provider, _) {
                return TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search posts...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon:
                        provider.searchQuery.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                provider.clearSearch();
                              },
                            )
                            : null,
                  ),
                  onChanged: (value) {
                    _debouncer.call(() {
                      provider.searchPosts(value);
                    });
                  },
                );
              },
            ),
          ),
        ),
      ),
      body: Consumer<PostsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const LoadingIndicator(message: 'Loading posts...');
          }

          if (provider.error != null && provider.posts.isEmpty) {
            return ErrorDisplay(
              message: provider.error!,
              onRetry: () => provider.loadPosts(refresh: true),
            );
          }

          if (provider.posts.isEmpty) {
            return const Center(child: Text('No posts found'));
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadPosts(refresh: true),
            color: AppColors.primary,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              itemCount: provider.posts.length + (provider.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == provider.posts.length) {
                  return const PaginationLoader();
                }

                final post = provider.posts[index];
                return PostCard(
                  post: post,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PostDetailScreen(post: post),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
