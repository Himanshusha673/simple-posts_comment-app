import 'package:flutter/material.dart';
import 'package:flutter_test_code/data/respository/api_repository.dart';
import 'package:provider/provider.dart';

import 'config/theme/app_theme.dart';
import 'data/respository/presentation/screens/home/home_screen.dart';

// Adjust these imports to match your project structure:
import 'providers/posts_provider.dart';
import 'providers/comments_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var apiRepo = ApiRepository();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PostsProvider>(
          create: (_) => PostsProvider(repository: apiRepo)..loadPosts(),
        ),

        ChangeNotifierProvider<CommentsProvider>(
          create: (_) => CommentsProvider(repository: apiRepo),
        ),
      ],
      child: MaterialApp(
        title: 'App task Hranker',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}
