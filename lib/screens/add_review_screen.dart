import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:safe_travels_3/config/constants.dart';
import 'package:safe_travels_3/config/theme.dart';
import 'package:safe_travels_3/data/septa_data.dart';
import 'package:safe_travels_3/models/review_model.dart';
import 'package:safe_travels_3/models/route_model.dart';
import 'package:safe_travels_3/models/user_model.dart';
import 'package:safe_travels_3/providers/user_provider.dart';
import 'package:safe_travels_3/services/auth_service.dart';
import 'package:safe_travels_3/services/review_service.dart';
import 'package:safe_travels_3/widgets/custom_app_bar.dart';
import 'package:safe_travels_3/widgets/star_rating.dart';

class AddReviewScreen extends StatefulWidget {
  final String startLocation;
  final String endLocation;
  final String transportationType;
  final String? reviewId;

  const AddReviewScreen({
    Key? key,
    required this.startLocation,
    required this.endLocation,
    required this.transportationType,
    this.reviewId,
  }) : super(key: key);

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reviewController = TextEditingController();

  String? _selectedAgeGroup;
  double _punctualityRating = 0;
  double _safetyRating = 0;
  double _cleanlinessRating = 0;
  double _overallRating = 0;

  bool get _isEditing => widget.reviewId != null;
  ReviewModel? _existingReview;
  RouteModel? _route;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _loadExistingReview();
    }
  }

  Future<void> _loadExistingReview() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      _existingReview = await ReviewService.getReviewById(widget.reviewId!);
      if (_existingReview != null && mounted) {
        setState(() {
          _reviewController.text = _existingReview!.content;
          _selectedAgeGroup = _existingReview!.ageGroup;
          _punctualityRating = _existingReview!.punctualityRating;
          _safetyRating = _existingReview!.safetyRating;
          _cleanlinessRating = _existingReview!.cleanlinessRating;
          _overallRating = _existingReview!.overallRating;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading review: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _isEditing ? AppConstants.editReviewTitle : AppConstants.addReviewTitle,
        showBackButton: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24), // Increased padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.startLocation} to ${widget.endLocation}',
                      style: const TextStyle(
                        fontSize: AppTheme.headerFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.transportationType,
                      style: TextStyle(
                        fontSize: AppTheme.bodyFontSize,
                        color: AppTheme.black.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildAgeGroupDropdown(),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _reviewController,
                      decoration: const InputDecoration(
                        labelText: 'Review',
                        hintText: AppConstants.reviewPlaceholder,
                        alignLabelWithHint: true,
                      ),
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a review';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Ratings',
                      style: TextStyle(
                        fontSize: AppTheme.bodyFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CategoryRating(
                      category: AppConstants.punctuality,
                      rating: _punctualityRating,
                      isInteractive: true,
                      onRatingChanged: (rating) {
                        setState(() {
                          _punctualityRating = rating;
                          _updateOverallRating();
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    CategoryRating(
                      category: AppConstants.safety,
                      rating: _safetyRating,
                      isInteractive: true,
                      onRatingChanged: (rating) {
                        setState(() {
                          _safetyRating = rating;
                          _updateOverallRating();
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    CategoryRating(
                      category: AppConstants.cleanliness,
                      rating: _cleanlinessRating,
                      isInteractive: true,
                      onRatingChanged: (rating) {
                        setState(() {
                          _cleanlinessRating = rating;
                          _updateOverallRating();
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    CategoryRating(
                      category: AppConstants.overall,
                      rating: _overallRating,
                      isInteractive: false,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitReview,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          AppConstants.publish,
                          style: TextStyle(
                            fontSize: AppTheme.buttonFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildAgeGroupDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedAgeGroup,
      decoration: const InputDecoration(
        labelText: 'Age Group',
      ),
      items: [
        DropdownMenuItem<String>(
          value: AppConstants.minor,
          child: Text(AppConstants.minor),
        ),
        DropdownMenuItem<String>(
          value: AppConstants.adult,
          child: Text(AppConstants.adult),
        ),
      ],
      onChanged: (value) {
        setState(() {
          _selectedAgeGroup = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select an age group';
        }
        return null;
      },
    );
  }

  void _updateOverallRating() {
    // Calculate the average of the three ratings
    _overallRating = (_punctualityRating + _safetyRating + _cleanlinessRating) / 3;
  }

  Future<void> _submitReview() async {
    print('_submitReview called');
    
    // Check if user is logged in
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be logged in to submit a review'),
          backgroundColor: Colors.red,
        ),
      );
      context.push('/login');
      return;
    }
    
    if (_formKey.currentState!.validate() &&
        _punctualityRating > 0 &&
        _safetyRating > 0 &&
        _cleanlinessRating > 0 &&
        _selectedAgeGroup != null) {
      
      setState(() {
        _isLoading = true;
      });
      
      try {
        // Show loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Saving your review...'),
            duration: Duration(seconds: 1),
          ),
        );
        
        final user = userProvider.user!;
        
        if (_isEditing && _existingReview != null) {
          // Update existing review
          await ReviewService.updateReview(
            id: _existingReview!.id,
            username: user.username,
            content: _reviewController.text,
            punctualityRating: _punctualityRating,
            safetyRating: _safetyRating,
            cleanlinessRating: _cleanlinessRating,
            overallRating: _overallRating,
            ageGroup: _selectedAgeGroup!,
          );
        } else {
          // Create a new review
          String routeId;
          String routeName;
          
          // For Regional Rail, we need to find the actual transit line
          if (widget.transportationType == 'Regional Rail') {
            // Find transit lines that connect the selected stations
            final connectingLines = findConnectingLines(widget.startLocation, widget.endLocation);
            
            if (connectingLines.isNotEmpty) {
              // Use the first connecting line
              final transitLine = connectingLines.first;
              routeId = transitLine.lineId;
              routeName = transitLine.name;
              print('Using transit line: ${transitLine.name} (${transitLine.lineId})');
            } else {
              // Fallback if no connecting line is found
              routeId = '${widget.transportationType}_${widget.startLocation}_${widget.endLocation}';
              routeName = '${widget.transportationType}: ${widget.startLocation} to ${widget.endLocation}';
              print('No connecting line found, using fallback route ID: $routeId');
            }
          } else {
            // For other transportation types, use the combination of type and locations
            routeId = '${widget.transportationType}_${widget.startLocation}_${widget.endLocation}';
            routeName = '${widget.transportationType}: ${widget.startLocation} to ${widget.endLocation}';
          }
          
          await ReviewService.addReview(
            userId: user.id,
            username: user.username,
            routeId: routeId,
            routeName: routeName,
            content: _reviewController.text,
            punctualityRating: _punctualityRating,
            safetyRating: _safetyRating,
            cleanlinessRating: _cleanlinessRating,
            overallRating: _overallRating,
            ageGroup: _selectedAgeGroup!,
          );
        }
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Review saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate back to the reviews screen
        context.pop(true); // Pass true to indicate a successful save
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving review: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      // Show validation error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields and provide ratings'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class CategoryRating extends StatelessWidget {
  final String category;
  final double rating;
  final bool isInteractive;
  final Function(double)? onRatingChanged;

  const CategoryRating({
    Key? key,
    required this.category,
    required this.rating,
    required this.isInteractive,
    this.onRatingChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            category,
            style: const TextStyle(
              fontSize: AppTheme.bodyFontSize,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: StarRating(
            rating: rating,
            size: 24,
            isInteractive: isInteractive,
            onRatingChanged: isInteractive ? onRatingChanged : null,
          ),
        ),
      ],
    );
  }
}
