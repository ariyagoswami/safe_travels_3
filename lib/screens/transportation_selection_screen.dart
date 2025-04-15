import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safe_travels_3/config/constants.dart';
import 'package:safe_travels_3/config/theme.dart';
import 'package:safe_travels_3/data/septa_data.dart';
import 'package:safe_travels_3/models/station_model.dart';
import 'package:safe_travels_3/models/transportation_model.dart';
import 'package:safe_travels_3/widgets/custom_app_bar.dart';
import 'package:safe_travels_3/widgets/custom_navigation_bar.dart';
import 'package:safe_travels_3/widgets/location_selector.dart';

class TransportationSelectionScreen extends StatefulWidget {
  const TransportationSelectionScreen({Key? key}) : super(key: key);

  @override
  State<TransportationSelectionScreen> createState() =>
      _TransportationSelectionScreenState();
}

class _TransportationSelectionScreenState
    extends State<TransportationSelectionScreen> {
  String? selectedTransportationType;
  String? selectedStartLocation;
  String? selectedEndLocation;
  int _currentNavIndex = 0;

  // Coordinates for Philadelphia (for future map implementation)
  static const double _philadelphiaLat = 39.9526;
  static const double _philadelphiaLng = -75.1652;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppConstants.transportationTitle,
        isTransportation: true,
        transportationLabel: 'Transportation:',
        transportationDropdown: _buildTransportationDropdown(),
      ),
      body: Column(
        children: [
          // Map view
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                // Placeholder for Google Maps
                Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Text(
                      'Map View',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.location_on, size: 16),
                        SizedBox(width: 4),
                        Text(
                          AppConstants.defaultLocation,
                          style: TextStyle(
                            fontSize: AppTheme.labelFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Location selectors and button
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    LocationSelector(
                      label: 'Starting Location',
                      selectedLocation: selectedStartLocation,
                      locations: AppConstants.startingLocations,
                      onLocationSelected: (location) {
                        setState(() {
                          selectedStartLocation = location;
                        });
                      },
                      onTap: () async {
                        final result = await context.push<String>(
                          '/location-selection?isStarting=true&transportationType=${Uri.encodeComponent(selectedTransportationType ?? '')}');
                        if (result != null) {
                          setState(() {
                            selectedStartLocation = result;
                          });
                        }
                      },
                    ),
                    LocationSelector(
                      label: 'Ending Location',
                      selectedLocation: selectedEndLocation,
                      locations: AppConstants.endingLocations,
                      onLocationSelected: (location) {
                        setState(() {
                          selectedEndLocation = location;
                        });
                      },
                      onTap: () async {
                        final result = await context.push<String>(
                          '/location-selection?isStarting=false&transportationType=${Uri.encodeComponent(selectedTransportationType ?? '')}');
                        if (result != null) {
                          setState(() {
                            selectedEndLocation = result;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        onPressed: _canShowReviews()
                            ? () => _navigateToReviews()
                            : null,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text(AppConstants.showReviews),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
          // Handle navigation to profile screen
          if (index == 1) {
            // Navigate to profile screen
          }
        },
      ),
    );
  }

  Widget _buildTransportationDropdown() {
    // Show all transportation options
    return DropdownButton<String>(
      value: selectedTransportationType,
      hint: const Text(
        'Select',
        style: TextStyle(color: AppTheme.white),
      ),
      icon: const Icon(Icons.arrow_drop_down, color: AppTheme.white),
      style: const TextStyle(
        color: AppTheme.white,
        fontSize: AppTheme.headerFontSize,
        fontWeight: FontWeight.bold,
      ),
      underline: Container(),
      dropdownColor: AppTheme.primaryBlue,
      items: mockTransportationOptions.map((TransportationModel transport) {
        return DropdownMenuItem<String>(
          value: transport.name,
          child: Text(transport.name),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          // If transportation type changed, clear selected locations
          if (selectedTransportationType != value) {
            selectedStartLocation = null;
            selectedEndLocation = null;
          }
          selectedTransportationType = value;
        });
      },
    );
  }

  bool _canShowReviews() {
    return selectedTransportationType != null &&
        selectedStartLocation != null &&
        selectedEndLocation != null;
  }

  void _navigateToReviews() {
    context.push(
      '/reviews?startLocation=$selectedStartLocation&endLocation=$selectedEndLocation&transportationType=$selectedTransportationType',
    );
  }
}
