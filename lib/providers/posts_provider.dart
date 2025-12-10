import 'package:flutter/foundation.dart';
import 'package:flutter_test_code/data/respository/api_repository.dart';

import '../core/exceptions/network_exception.dart';

class PostsProvider with ChangeNotifier {
  final ApiRepository _repository;

  PostsProvider({ApiRepository? repository})
    : _repository = repository ?? ApiRepository();

  final List _posts = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  int _currentPage = 1;
  bool _hasMore = true;
  String _searchQuery = '';

  List get posts => _posts;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  bool get hasMore => _hasMore;
  String get searchQuery => _searchQuery;

  Future loadPosts({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _posts.clear();
    }

    if (_isLoading || _isLoadingMore || !_hasMore) return;

    _currentPage == 1 ? _isLoading = true : _isLoadingMore = true;
    _error = null;
    notifyListeners();

    try {
      final newPosts = await _repository.getPosts(
        page: _currentPage,
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
      );

      if (newPosts.length < 10) {
        _hasMore = false;
      }
      print('Fetched ${newPosts.length} posts');
      _posts.addAll(newPosts);
      _currentPage++;
    } on NetworkException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'An unexpected error occurred';
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future searchPosts(String query) async {
    _searchQuery = query;
    _currentPage = 1;
    _hasMore = true;
    _posts.clear();
    await loadPosts();
  }

  void clearSearch() {
    _searchQuery = '';
    _currentPage = 1;
    _hasMore = true;
    _posts.clear();
    loadPosts();
  }
}
