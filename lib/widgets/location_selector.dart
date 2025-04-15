import 'package:flutter/material.dart';
import 'package:safe_travels_3/config/constants.dart';
import 'package:safe_travels_3/config/theme.dart';
import 'package:safe_travels_3/models/station_model.dart';

class LocationSelector extends StatelessWidget {
  final String label;
  final String? selectedLocation;
  final List<String> locations;
  final Function(String) onLocationSelected;
  final VoidCallback? onTap;

  const LocationSelector({
    Key? key,
    required this.label,
    this.selectedLocation,
    required this.locations,
    required this.onLocationSelected,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: AppTheme.lightGray,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: AppTheme.labelFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedLocation ?? AppConstants.select,
                  style: TextStyle(
                    fontSize: AppTheme.bodyFontSize,
                    color: selectedLocation != null
                        ? AppTheme.black
                        : AppTheme.black.withOpacity(0.5),
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LocationDropdown extends StatelessWidget {
  final String label;
  final String? selectedLocation;
  final List<String> locations;
  final Function(String?) onChanged;

  const LocationDropdown({
    Key? key,
    required this.label,
    this.selectedLocation,
    required this.locations,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: AppTheme.labelFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppTheme.lightGray,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedLocation,
              isExpanded: true,
              hint: Text(
                AppConstants.select,
                style: TextStyle(
                  color: AppTheme.black.withOpacity(0.5),
                ),
              ),
              items: locations.map((location) {
                return DropdownMenuItem<String>(
                  value: location,
                  child: Text(location),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
