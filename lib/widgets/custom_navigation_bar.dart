import 'package:flutter/material.dart';
import 'package:safe_travels_3/config/constants.dart';
import 'package:safe_travels_3/config/theme.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.secondaryYellow,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppTheme.black,
        unselectedItemColor: AppTheme.black.withOpacity(0.6),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: AppTheme.labelFontSize,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: AppTheme.labelFontSize,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppConstants.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: AppConstants.profile,
          ),
        ],
      ),
    );
  }
}
