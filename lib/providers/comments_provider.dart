import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_test_code/data/respository/api_repository.dart';
import '../data/models/comment.dart';

import '../core/exceptions/network_exception.dart';

class CommentsProvider with ChangeNotifier {
  final ApiRepository _repository;

  CommentsProvider({ApiRepository? repository})
    : _repository = repository ?? ApiRepository();

  final Map _commentsCache = {};
  final Map _loadingStates = {};
  final Map _loadingMoreStates = {};
  final Map _errorStates = {};
  final Map _currentPages = {};
  final Map _hasMoreStates = {};

  List getComments(int postId) => _commentsCache[postId] ?? [];
  bool isLoading(int postId) => _loadingStates[postId] ?? false;
  bool isLoadingMore(int postId) => _loadingMoreStates[postId] ?? false;
  String? getError(int postId) => _errorStates[postId];
  bool hasMore(int postId) => _hasMoreStates[postId] ?? true;

  Future loadComments(int postId, {bool refresh = false}) async {
    if (refresh) {
      _currentPages[postId] = 1;
      _hasMoreStates[postId] = true;
      _commentsCache[postId] = [];
    }

    final currentPage = _currentPages[postId] ?? 1;
    final isLoading = _loadingStates[postId] ?? false;
    final isLoadingMore = _loadingMoreStates[postId] ?? false;
    final hasMore = _hasMoreStates[postId] ?? true;

    if (isLoading || isLoadingMore || !hasMore) return;

    if (currentPage == 1) {
      _loadingStates[postId] = true;
    } else {
      _loadingMoreStates[postId] = true;
    }
    _errorStates[postId] = null;
    notifyListeners();

    try {
      final newComments = await _repository.getPostComments(
        postId: postId,
        page: currentPage,
      );

      if (newComments.length < 10) {
        _hasMoreStates[postId] = false;
      }

      _commentsCache[postId] = [
        ...(_commentsCache[postId] ?? []),
        ...newComments,
      ];
      log("new Comments ${newComments.toString()}");
      _currentPages[postId] = currentPage + 1;
    } on NetworkException catch (e) {
      _errorStates[postId] = e.message;
    } catch (e) {
      _errorStates[postId] = 'An unexpected error occurred';
    } finally {
      _loadingStates[postId] = false;
      _loadingMoreStates[postId] = false;
      notifyListeners();
    }
  }
}
