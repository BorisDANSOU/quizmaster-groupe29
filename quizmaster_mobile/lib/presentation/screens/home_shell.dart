import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(index);
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: "Acceuil",
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            label: "Explorer",
          ),
          NavigationDestination(
            icon: Icon(Icons.leaderboard_outlined),
            label: "Classement",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_2_outlined),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
