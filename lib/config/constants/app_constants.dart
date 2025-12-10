class AppConstants {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const int pageSize = 10;
  static const Duration timeoutDuration = Duration(seconds: 15);
  static const Duration debounceDuration = Duration(milliseconds: 500);
  
  // API Endpoints
  static const String postsEndpoint = '/posts';
  static const String commentsEndpoint = '/comments';

  
  // Error Messages
  static const String noInternetMessage = 'No internet connection';
  static const String serverErrorMessage = 'Server error occurred';
  static const String timeoutMessage = 'Request timeout';
  static const String unknownErrorMessage = 'An unknown error occurred';
}