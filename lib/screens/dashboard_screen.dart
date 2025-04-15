import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safe_travels_3/config/theme.dart';
import 'package:safe_travels_3/widgets/custom_app_bar.dart';
import 'package:safe_travels_3/widgets/custom_navigation_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  void _onNavigationItemTapped(int index) {
    if (index == 0) {
      // Already on dashboard, do nothing
      return;
    } else if (index == 1) {
      // Navigate to home/transportation selection
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Dashboard',
        isDashboard: true,
        userSettingsDropdown: _buildUserSettingsDropdown(context),
      ),
      body: const Center(
        child: Text('Dashboard Content'),
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: 0,
        onTap: _onNavigationItemTapped,
      ),
    );
  }

  Widget _buildUserSettingsDropdown(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.account_circle,
        color: AppTheme.white,
        size: 28,
      ),
      onSelected: (String value) {
        // Handle menu item selection
        switch (value) {
          case 'profile':
            // Navigate to profile screen
            break;
          case 'settings':
            // Navigate to settings screen
            break;
          case 'logout':
            // Handle logout
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person, color: AppTheme.primaryBlue),
              SizedBox(width: 8),
              Text('My Profile'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings, color: AppTheme.primaryBlue),
              SizedBox(width: 8),
              Text('Settings'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, color: AppTheme.primaryBlue),
              SizedBox(width: 8),
              Text('Logout'),
            ],
          ),
        ),
      ],
    );
  }
}
