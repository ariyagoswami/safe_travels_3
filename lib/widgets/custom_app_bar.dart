import 'package:flutter/material.dart';
import 'package:safe_travels_3/config/theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showEditButton;
  final VoidCallback? onEditPressed;
  final Widget? dropdown;
  final bool isDashboard;
  final Widget? userSettingsDropdown;
  final bool isTransportation;
  final Widget? transportationDropdown;
  final String? transportationLabel;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showBackButton = false,
    this.showEditButton = false,
    this.onEditPressed,
    this.dropdown,
    this.isDashboard = false,
    this.userSettingsDropdown,
    this.isTransportation = false,
    this.transportationDropdown,
    this.transportationLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.primaryBlue,
      elevation: 0,
      centerTitle: !isDashboard && !isTransportation,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AppTheme.white),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      title: isDashboard
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(color: AppTheme.white)),
                userSettingsDropdown ?? const SizedBox(),
              ],
            )
          : isTransportation
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      transportationLabel ?? 'Transportation:',
                      style: const TextStyle(
                        color: AppTheme.white,
                        fontSize: AppTheme.headerFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    transportationDropdown ?? const SizedBox(),
                  ],
                )
              : dropdown ?? Text(title, style: const TextStyle(color: AppTheme.white)),
      actions: [
        if (showEditButton && !isDashboard && !isTransportation)
          IconButton(
            icon: const Icon(Icons.edit, color: AppTheme.white),
            onPressed: onEditPressed,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
