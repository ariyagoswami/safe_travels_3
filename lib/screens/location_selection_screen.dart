import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safe_travels_3/config/constants.dart';
import 'package:safe_travels_3/config/theme.dart';
import 'package:safe_travels_3/models/station_model.dart';
import 'package:safe_travels_3/widgets/custom_app_bar.dart';

class LocationSelectionScreen extends StatefulWidget {
  final bool isStarting;
  final String? transportationType;

  const LocationSelectionScreen({
    Key? key,
    required this.isStarting,
    this.transportationType,
  }) : super(key: key);

  @override
  State<LocationSelectionScreen> createState() =>
      _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  late List<StationModel> stations;

  @override
  void initState() {
    super.initState();
    stations = widget.isStarting
        ? getStartingStations(transportationType: widget.transportationType)
        : getEndingStations(transportationType: widget.transportationType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.isStarting ? 'Starting Location' : 'Ending Location',
        showBackButton: true,
      ),
      body: Scrollbar(
        thumbVisibility: true,
        thickness: 6,
        radius: const Radius.circular(10),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          itemCount: stations.length,
          // Explicitly set physics to ensure scrolling works
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final station = stations[index];
            return _buildLocationItem(station);
          },
        ),
      ),
    );
  }

  Widget _buildLocationItem(StationModel station) {
    return InkWell(
      onTap: () => _selectLocation(station.name),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppTheme.lightGray,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on_outlined),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                station.name,
                style: const TextStyle(
                  fontSize: AppTheme.bodyFontSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectLocation(String location) {
    // Pass the selected location back to the previous screen
    context.pop<String>(location);
  }
}
