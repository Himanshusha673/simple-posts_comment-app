import 'package:flutter/material.dart';

import '../posts/posts_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State {
  // int _selectedIndex = 0;

  // final List<Widget> _screens = const [
  //   PostsScreen(),

  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PostsScreen(),

      //  IndexedStack(index: _selectedIndex, children: _screens),
      // bottomNavigationBar: NavigationBar(
      //   selectedIndex: _selectedIndex,
      //   onDestinationSelected: (index) {
      //     setState(() {
      //       _selectedIndex = index;
      //     });
      //   },
      //   backgroundColor:
      //       Theme.of(context).brightness == Brightness.light
      //           ? AppColors.surface
      //           : AppColors.surfaceDark,
      //   destinations: const [
      //     NavigationDestination(
      //       icon: Icon(Icons.article_outlined),
      //       selectedIcon: Icon(Icons.article),
      //       label: 'Posts',
      //     ),
      //     // NavigationDestination(
      //     //   icon: Icon(Icons.photo_library_outlined),
      //     //   selectedIcon: Icon(Icons.photo_library),
      //     //   label: 'Albums',
      //     // ),
      //     // NavigationDestination(
      //     //   icon: Icon(Icons.people_outline),
      //     //   selectedIcon: Icon(Icons.people),
      //     //   label: 'Users',
      //     // ),
      //   ],
      // ),
    );
  }
}
