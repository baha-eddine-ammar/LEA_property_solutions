import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'booking_form_page.dart';
import '../widgets/property_comparison.dart';
import '../theme/app_theme.dart';
import '../widgets/property_image_carousel.dart';
import '../widgets/property_reviews.dart';
import '../widgets/similar_properties.dart';
import '../widgets/favorite_button.dart';
import '../widgets/share_property_sheet.dart';
import '../widgets/virtual_tour_button.dart';

class PropertyDetailPage extends StatefulWidget {
  final PropertyListing property;

  const PropertyDetailPage({
    Key? key,
    required this.property,
  }) : super(key: key);

  @override
  State<PropertyDetailPage> createState() => _PropertyDetailPageState();
}

// Helper class to maintain a static list of properties for comparison
class _ComparisonList {
  static final List<PropertyListing> _list = [];

  static List<PropertyListing> getList() {
    return _list;
  }
}

class _PropertyDetailPageState extends State<PropertyDetailPage> {
  // No longer needed as we're using the booking form page

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image Carousel
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: PropertyImageCarousel(
                mainImageUrl: widget.property.imageUrl,
                additionalImages: const [
                  'https://images.unsplash.com/photo-1502005229762-cf1b2da7c5d6',
                  'https://images.unsplash.com/photo-1512917774080-9991f1c4c750',
                  'https://images.unsplash.com/photo-1505843513577-22bb7d21e455',
                ],
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.share, color: Colors.black),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => SharePropertySheet(
                        property: widget.property,
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: FavoriteButton(
                  isFavorite: false,
                  onToggle: (isFavorite) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isFavorite
                              ? 'Added to wishlist'
                              : 'Removed from wishlist',
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: isFavorite
                            ? AppTheme.successColor
                            : AppTheme.subtitleColor,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  backgroundColor: Colors.white,
                  inactiveColor: Colors.black,
                ),
              ),
            ],
          ),
          // Property Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Rating
                  Text(
                    widget.property.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        widget.property.rating.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.property.location,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),

                  // Host Info
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(
                          'https://randomuser.me/api/portraits/men/32.jpg',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hosted by John',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.property.isSuperhost ? 'Superhost' : 'Host',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 32),

                  // Property Features
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildFeature(Icons.king_bed,
                          '${widget.property.bedrooms} ${widget.property.bedrooms > 1 ? 'bedrooms' : 'bedroom'}'),
                      _buildFeature(Icons.bathtub,
                          '${widget.property.bathrooms} ${widget.property.bathrooms > 1 ? 'bathrooms' : 'bathroom'}'),
                      _buildFeature(Icons.people,
                          '${widget.property.bedrooms * 2} guests'),
                    ],
                  ),
                  const Divider(height: 32),

                  // Description
                  const Text(
                    'About this place',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'This beautiful ${widget.property.propertyType.toLowerCase()} in ${widget.property.location} offers a comfortable stay with ${widget.property.bedrooms} ${widget.property.bedrooms > 1 ? 'bedrooms' : 'bedroom'} and ${widget.property.bathrooms} ${widget.property.bathrooms > 1 ? 'bathrooms' : 'bathroom'}. Located just ${widget.property.distance}, it\'s perfect for your next getaway.',
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Amenities
                  const Text(
                    'What this place offers',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: widget.property.amenities.map((amenity) {
                      IconData icon;
                      switch (amenity.toLowerCase()) {
                        case 'wifi':
                          icon = Icons.wifi;
                          break;
                        case 'kitchen':
                          icon = Icons.kitchen;
                          break;
                        case 'pool':
                          icon = Icons.pool;
                          break;
                        case 'air conditioning':
                          icon = Icons.ac_unit;
                          break;
                        case 'heating':
                          icon = Icons.hot_tub;
                          break;
                        case 'washer':
                          icon = Icons.local_laundry_service;
                          break;
                        case 'dryer':
                          icon = Icons.dry;
                          break;
                        case 'tv':
                          icon = Icons.tv;
                          break;
                        case 'garden':
                          icon = Icons.yard;
                          break;
                        case 'river view':
                          icon = Icons.water;
                          break;
                        case 'gym':
                          icon = Icons.fitness_center;
                          break;
                        default:
                          icon = Icons.check_circle_outline;
                      }
                      return _buildAmenity(icon, amenity);
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Location
                  const Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.map,
                        size: 48,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.property.location,
                    style: const TextStyle(fontSize: 16),
                  ),
                  // Reviews section
                  const SizedBox(height: 24),
                  const Text(
                    'Reviews',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  PropertyReviews(
                    rating: widget.property.rating,
                    reviewCount: 25,
                    reviews: [
                      Review(
                        reviewerName: 'John Smith',
                        reviewerImage:
                            'https://randomuser.me/api/portraits/men/32.jpg',
                        date: 'March 2023',
                        text:
                            'This place was amazing! The views were spectacular and the host was very accommodating. Would definitely stay here again.',
                      ),
                      Review(
                        reviewerName: 'Sarah Johnson',
                        reviewerImage:
                            'https://randomuser.me/api/portraits/women/44.jpg',
                        date: 'February 2023',
                        text:
                            'Beautiful property with all the amenities you need. The location is perfect for exploring the area. Highly recommend!',
                      ),
                      Review(
                        reviewerName: 'Michael Brown',
                        reviewerImage:
                            'https://randomuser.me/api/portraits/men/22.jpg',
                        date: 'January 2023',
                        text:
                            'Great stay! The property was clean and exactly as described. The host was responsive and helpful.',
                      ),
                      Review(
                        reviewerName: 'Emily Davis',
                        reviewerImage:
                            'https://randomuser.me/api/portraits/women/67.jpg',
                        date: 'December 2022',
                        text:
                            'We had a wonderful time at this property. The kitchen was well-equipped and the beds were very comfortable.',
                      ),
                      Review(
                        reviewerName: 'David Wilson',
                        reviewerImage:
                            'https://randomuser.me/api/portraits/men/52.jpg',
                        date: 'November 2022',
                        text:
                            'Excellent location and beautiful views. The property was clean and well-maintained. Would stay here again!',
                      ),
                    ],
                  ),

                  // Similar properties section
                  const SizedBox(height: 32),
                  SimilarProperties(
                    currentProperty: widget.property,
                    allProperties: [
                      widget.property,
                      PropertyListing(
                        id: '101',
                        title: 'Luxury Beachfront Villa',
                        location: widget.property.location,
                        price: widget.property.price * 1.2,
                        imageUrl:
                            'https://images.unsplash.com/photo-1512917774080-9991f1c4c750',
                        rating: 4.9,
                        distance:
                            '${(int.parse(widget.property.distance.split(' ')[0]) + 5).toString()} miles away',
                        dates: 'Mar 15 - 20',
                        propertyType: widget.property.propertyType,
                        amenities: widget.property.amenities,
                        bedrooms: widget.property.bedrooms + 1,
                        bathrooms: widget.property.bathrooms + 1,
                        isInstantBook: true,
                        isSuperhost: true,
                        categories: widget.property.categories,
                      ),
                      PropertyListing(
                        id: '102',
                        title: 'Modern Apartment with View',
                        location: widget.property.location,
                        price: widget.property.price * 0.8,
                        imageUrl:
                            'https://images.unsplash.com/photo-1502005229762-cf1b2da7c5d6',
                        rating: 4.7,
                        distance:
                            '${(int.parse(widget.property.distance.split(' ')[0]) - 2).toString()} miles away',
                        dates: 'Mar 10 - 15',
                        propertyType: 'Apartment',
                        amenities: ['WiFi', 'Kitchen', 'Air conditioning'],
                        bedrooms: 2,
                        bathrooms: 1,
                        isInstantBook: true,
                        isSuperhost: false,
                        categories: ['Amazing views'],
                      ),
                      PropertyListing(
                        id: '103',
                        title: 'Cozy Cottage Retreat',
                        location: widget.property.location,
                        price: widget.property.price * 0.9,
                        imageUrl:
                            'https://images.unsplash.com/photo-1505843513577-22bb7d21e455',
                        rating: 4.8,
                        distance:
                            '${(int.parse(widget.property.distance.split(' ')[0]) + 10).toString()} miles away',
                        dates: 'Mar 20 - 25',
                        propertyType: 'House',
                        amenities: ['WiFi', 'Kitchen', 'Heating', 'Garden'],
                        bedrooms: 3,
                        bathrooms: 2,
                        isInstantBook: false,
                        isSuperhost: true,
                        categories: ['Countryside'],
                      ),
                    ],
                  ),

                  const SizedBox(height: 100), // Space for bottom bar
                ],
              ),
            ),
          ),
        ],
      ),
      // Floating action buttons
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Compare button
            FloatingActionButton.small(
              heroTag: 'compare',
              onPressed: () {
                // Get properties from static list or create a new one
                final comparisonList = _ComparisonList.getList();

                // Check if property is already in the list
                if (!comparisonList.contains(widget.property)) {
                  comparisonList.add(widget.property);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('${widget.property.title} added to comparison'),
                      action: SnackBarAction(
                        label: 'COMPARE',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PropertyComparisonPage(
                                initialProperties: comparisonList,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  // If already in list, navigate to comparison page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PropertyComparisonPage(
                        initialProperties: comparisonList,
                      ),
                    ),
                  );
                }
              },
              backgroundColor: Colors.white,
              child: const Icon(Icons.compare_arrows, color: Colors.black),
            ),
            const SizedBox(height: 16),
            // Virtual tour button
            VirtualTourButton(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => VirtualTourDialog(
                    propertyTitle: widget.property.title,
                  ),
                );
              },
            ),
          ],
        ),
      ),

      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: '\$${widget.property.price.toStringAsFixed(0)} ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const TextSpan(
                        text: 'total',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Text(
                  widget.property.dates,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to booking form
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingFormPage(
                      property: widget.property,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Book now',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, size: 28),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildAmenity(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
