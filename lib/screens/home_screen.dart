import 'package:flutter/material.dart';
import 'filters_page.dart';
import 'profile_page.dart';
import 'wishlist_page.dart';
import 'property_detail_page.dart';
import 'inbox_page.dart';
import 'trips_page.dart';
import 'map_page.dart';
import '../widgets/chat_bot.dart';
import '../widgets/notification_center.dart';
import '../services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Search controller for the search bar
  final TextEditingController _searchController = TextEditingController();
  final List<PropertyListing> _wishlist = [];
  List<PropertyListing> _allListings = [];
  List<PropertyListing> _filteredListings = [];
  int _selectedIndex = 0;
  Map<String, dynamic> _currentFilters = {};
  String _selectedCategory = 'Beachfront';
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _initializeProperties();

    // Add listener to search controller
    _searchController.addListener(_onSearchChanged);

    // Initialize notification service
    _notificationService.initialize();

    // Apply initial category filter
    Future.delayed(Duration.zero, () {
      _filterByCategory(_selectedCategory);
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _searchProperties(_searchController.text);
  }

  void _searchProperties(String query) {
    setState(() {
      if (query.isEmpty) {
        // If search is empty, apply only the filters
        _applyFilters();
      } else {
        // Filter properties by location
        _filteredListings = _allListings.where((property) {
          // Check if the property location contains the search query
          return property.location.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _initializeProperties() {
    _allListings = [
      PropertyListing(
        id: '1',
        title: 'Modern Beachfront Villa',
        location: 'Osea Island, UK',
        price: 21886,
        imageUrl:
            'https://images.unsplash.com/photo-1512917774080-9991f1c4c750',
        rating: 4.8,
        distance: '41 miles away',
        dates: 'Feb 8 - 13',
        propertyType: 'House',
        amenities: ['WiFi', 'Pool', 'Kitchen', 'Air conditioning'],
        bedrooms: 4,
        bathrooms: 3,
        isInstantBook: true,
        isSuperhost: true,
        categories: ['Beachfront', 'Amazing views'],
      ),
      PropertyListing(
        id: '2',
        title: 'Luxury Countryside Estate',
        location: 'Cornwall, UK',
        price: 18500,
        imageUrl:
            'https://images.unsplash.com/photo-1505843513577-22bb7d21e455',
        rating: 4.9,
        distance: '120 miles away',
        dates: 'Feb 10 - 15',
        propertyType: 'House',
        amenities: ['WiFi', 'Kitchen', 'Washer', 'Dryer'],
        bedrooms: 3,
        bathrooms: 2,
        isInstantBook: false,
        isSuperhost: true,
        categories: ['Countryside', 'Amazing views'],
      ),
      // Add more properties here (total 15)
      PropertyListing(
        id: '3',
        title: 'Modern City Apartment',
        location: 'London, UK',
        price: 15000,
        imageUrl:
            'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267',
        rating: 4.7,
        distance: '5 miles away',
        dates: 'Feb 12 - 17',
        propertyType: 'Apartment',
        amenities: ['WiFi', 'Kitchen', 'Gym'],
        bedrooms: 2,
        bathrooms: 2,
        isInstantBook: true,
        isSuperhost: false,
        categories: ['Amazing views'],
      ),
      PropertyListing(
        id: '4',
        title: 'Cozy Guesthouse',
        location: 'Brighton, UK',
        price: 12000,
        imageUrl:
            'https://images.unsplash.com/photo-1493809842364-78817add7ffb',
        rating: 4.6,
        distance: '52 miles away',
        dates: 'Feb 15 - 20',
        propertyType: 'Guesthouse',
        amenities: ['WiFi', 'Kitchen'],
        bedrooms: 1,
        bathrooms: 1,
        isInstantBook: true,
        isSuperhost: false,
        categories: ['Countryside'],
      ),
      PropertyListing(
        id: '5',
        title: 'Luxury Hotel Suite',
        location: 'Manchester, UK',
        price: 25000,
        imageUrl:
            'https://images.unsplash.com/photo-1590490360182-c33d57733427',
        rating: 4.9,
        distance: '180 miles away',
        dates: 'Feb 18 - 23',
        propertyType: 'Hotel',
        amenities: ['WiFi', 'Air conditioning', 'TV'],
        bedrooms: 1,
        bathrooms: 1,
        isInstantBook: true,
        isSuperhost: false,
        categories: ['Amazing views'],
      ),
      PropertyListing(
        id: '6',
        title: 'Seaside Apartment',
        location: 'Liverpool, UK',
        price: 16500,
        imageUrl:
            'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688',
        rating: 4.7,
        distance: '210 miles away',
        dates: 'Feb 20 - 25',
        propertyType: 'Apartment',
        amenities: ['WiFi', 'Kitchen', 'Washer'],
        bedrooms: 2,
        bathrooms: 1,
        isInstantBook: false,
        isSuperhost: true,
        categories: ['Beachfront'],
      ),
      PropertyListing(
        id: '7',
        title: 'Historic Townhouse',
        location: 'Edinburgh, UK',
        price: 19500,
        imageUrl:
            'https://images.unsplash.com/photo-1464146072230-91cabc968266',
        rating: 4.8,
        distance: '400 miles away',
        dates: 'Feb 22 - 27',
        propertyType: 'House',
        amenities: ['WiFi', 'Kitchen', 'Heating'],
        bedrooms: 3,
        bathrooms: 2,
        isInstantBook: false,
        isSuperhost: true,
        categories: ['Amazing views', 'Countryside'],
      ),
      PropertyListing(
        id: '8',
        title: 'Modern Studio',
        location: 'Glasgow, UK',
        price: 13500,
        imageUrl:
            'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267',
        rating: 4.6,
        distance: '420 miles away',
        dates: 'Feb 25 - Mar 2',
        propertyType: 'Apartment',
        amenities: ['WiFi', 'Kitchen'],
        bedrooms: 1,
        bathrooms: 1,
        isInstantBook: true,
        isSuperhost: false,
        categories: ['Amazing views'],
      ),
      PropertyListing(
        id: '9',
        title: 'Lakeside Cottage',
        location: 'Lake District, UK',
        price: 17500,
        imageUrl:
            'https://images.unsplash.com/photo-1449158743715-0a90ebb6d2d8',
        rating: 4.9,
        distance: '250 miles away',
        dates: 'Feb 28 - Mar 5',
        propertyType: 'House',
        amenities: ['WiFi', 'Kitchen', 'Heating'],
        bedrooms: 2,
        bathrooms: 1,
        isInstantBook: false,
        isSuperhost: true,
        categories: ['Countryside', 'Amazing views'],
      ),
      PropertyListing(
        id: '10',
        title: 'City View Penthouse',
        location: 'Birmingham, UK',
        price: 22000,
        imageUrl:
            'https://images.unsplash.com/photo-1502005229762-cf1b2da7c5d6',
        rating: 4.8,
        distance: '160 miles away',
        dates: 'Mar 3 - 8',
        propertyType: 'Apartment',
        amenities: ['WiFi', 'Kitchen', 'Air conditioning'],
        bedrooms: 3,
        bathrooms: 2,
        isInstantBook: true,
        isSuperhost: true,
        categories: ['Amazing views'],
      ),
      PropertyListing(
        id: '11',
        title: 'Boutique Hotel Room',
        location: 'Oxford, UK',
        price: 14500,
        imageUrl:
            'https://images.unsplash.com/photo-1444201983204-c43cbd584d93',
        rating: 4.7,
        distance: '60 miles away',
        dates: 'Mar 5 - 10',
        propertyType: 'Hotel',
        amenities: ['WiFi', 'TV'],
        bedrooms: 1,
        bathrooms: 1,
        isInstantBook: true,
        isSuperhost: false,
        categories: ['Amazing views'],
      ),
      PropertyListing(
        id: '12',
        title: 'Garden Cottage',
        location: 'Cambridge, UK',
        price: 16000,
        imageUrl:
            'https://images.unsplash.com/photo-1510798831971-661eb04b3739',
        rating: 4.8,
        distance: '55 miles away',
        dates: 'Mar 8 - 13',
        propertyType: 'House',
        amenities: ['WiFi', 'Kitchen', 'Garden'],
        bedrooms: 2,
        bathrooms: 1,
        isInstantBook: false,
        isSuperhost: true,
        categories: ['Countryside'],
      ),
      PropertyListing(
        id: '13',
        title: 'Modern Loft',
        location: 'Bristol, UK',
        price: 15500,
        imageUrl:
            'https://images.unsplash.com/photo-1536376072261-38c75010e6c9',
        rating: 4.6,
        distance: '120 miles away',
        dates: 'Mar 10 - 15',
        propertyType: 'Apartment',
        amenities: ['WiFi', 'Kitchen'],
        bedrooms: 1,
        bathrooms: 1,
        isInstantBook: true,
        isSuperhost: false,
        categories: ['Amazing views'],
      ),
      PropertyListing(
        id: '14',
        title: 'Countryside Manor',
        location: 'Yorkshire, UK',
        price: 28000,
        imageUrl:
            'https://images.unsplash.com/photo-1505843513577-22bb7d21e455',
        rating: 4.9,
        distance: '220 miles away',
        dates: 'Mar 12 - 17',
        propertyType: 'House',
        amenities: ['WiFi', 'Kitchen', 'Pool'],
        bedrooms: 5,
        bathrooms: 4,
        isInstantBook: false,
        isSuperhost: true,
        categories: ['Countryside', 'Amazing pools'],
      ),
      PropertyListing(
        id: '15',
        title: 'Riverside Apartment',
        location: 'Newcastle, UK',
        price: 17000,
        imageUrl:
            'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688',
        rating: 4.7,
        distance: '280 miles away',
        dates: 'Mar 15 - 20',
        propertyType: 'Apartment',
        amenities: ['WiFi', 'Kitchen', 'River view'],
        bedrooms: 2,
        bathrooms: 2,
        isInstantBook: true,
        isSuperhost: false,
        categories: ['Amazing views', 'Amazing pools'],
      ),
    ];
    _filteredListings = List.from(_allListings);
    _currentFilters['totalHomes'] = _filteredListings.length;
  }

  void _toggleWishlist(PropertyListing property) {
    setState(() {
      if (_wishlist.contains(property)) {
        _wishlist.remove(property);
      } else {
        _wishlist.add(property);
      }
    });
  }

  void _showFilters() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FiltersPage(
          currentFilters: _currentFilters,
          onApplyFilters: (filters) {
            setState(() {
              _currentFilters = filters;
              _applyFilters();
            });
          },
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _currentFilters = result;
        _applyFilters();
      });
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredListings = _allListings.where((property) {
        // Property Type Filter
        if (_currentFilters['propertyType']?.isNotEmpty == true &&
            property.propertyType != _currentFilters['propertyType']) {
          return false;
        }

        // Price Range Filter
        final priceRange = _currentFilters['priceRange'] as RangeValues?;
        if (priceRange != null &&
            (property.price < priceRange.start ||
                property.price > priceRange.end)) {
          return false;
        }

        // Bedrooms Filter
        final bedrooms = _currentFilters['bedrooms'] as int?;
        if (bedrooms != null && bedrooms > 0 && property.bedrooms != bedrooms) {
          return false;
        }

        // Bathrooms Filter
        final bathrooms = _currentFilters['bathrooms'] as int?;
        if (bathrooms != null &&
            bathrooms > 0 &&
            property.bathrooms != bathrooms) {
          return false;
        }

        // Amenities Filter
        final amenities = _currentFilters['amenities'] as List<String>?;
        if (amenities != null && amenities.isNotEmpty) {
          if (!amenities
              .every((amenity) => property.amenities.contains(amenity))) {
            return false;
          }
        }

        // Superhost Filter
        if (_currentFilters['isSuperhost'] == true && !property.isSuperhost) {
          return false;
        }

        return true;
      }).toList();

      _currentFilters['totalHomes'] = _filteredListings.length;
    });
  }

  void _navigateToPage(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      // Navigate to Wishlist
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WishlistPage(wishlistItems: _wishlist),
        ),
      );
    } else if (index == 2) {
      // Navigate to Trips
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TripsPage(bookedProperties: []),
        ),
      );
    } else if (index == 3) {
      // Navigate to Inbox
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const InboxPage(),
        ),
      );
    } else if (index == 4) {
      // Navigate to Profile
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfilePage(),
        ),
      );
    }
  }

  void _openMap(PropertyListing property) {
    // Find properties in the same location
    final propertiesInLocation = _allListings
        .where((p) =>
            p.location.split(',').first == property.location.split(',').first)
        .toList();

    // Navigate to map page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPage(
          properties: propertiesInLocation,
          location: property.location.split(',').first,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // App Bar with Search and Notifications
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Search Bar
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(26),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  const Icon(Icons.search, color: Colors.black),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      decoration: InputDecoration(
                                        hintText: 'Search by location',
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  if (_searchController.text.isNotEmpty)
                                    GestureDetector(
                                      onTap: () {
                                        _searchController.clear();
                                      },
                                      child: const Icon(Icons.clear,
                                          color: Colors.grey),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Notification Button
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(26),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ValueListenableBuilder<int>(
                          valueListenable: _notificationService.unreadCount,
                          builder: (context, count, _) {
                            return NotificationBadge(
                              count: count,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NotificationCenter(
                                      notifications: _notificationService
                                          .getAllNotifications(),
                                      onNotificationRead: (notification) {
                                        _notificationService
                                            .markAsRead(notification);
                                      },
                                      onNotificationsDeleted: (ids) {
                                        _notificationService
                                            .deleteNotifications(ids);
                                      },
                                      onMarkAllAsRead: () {
                                        _notificationService.markAllAsRead();
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),

                      // Filter Button
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(26),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.tune),
                          onPressed: _showFilters,
                        ),
                      ),
                    ],
                  ),
                ),

                // Categories
                SizedBox(
                  height: 80,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildCategoryItem('Beachfront', Icons.beach_access,
                          _selectedCategory == 'Beachfront'),
                      _buildCategoryItem('Amazing views', Icons.photo_camera,
                          _selectedCategory == 'Amazing views'),
                      _buildCategoryItem('Countryside', Icons.nature,
                          _selectedCategory == 'Countryside'),
                      _buildCategoryItem('Amazing pools', Icons.pool,
                          _selectedCategory == 'Amazing pools'),
                    ],
                  ),
                ),

                // Property Listings
                Expanded(
                  child: _filteredListings.isEmpty
                      ? const Center(
                          child: Text(
                            'No properties found for this location',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredListings.length,
                          itemBuilder: (context, index) {
                            final property = _filteredListings[index];
                            return _buildPropertyCard(property);
                          },
                        ),
                ),
              ],
            ),
          ),
          // Chat Bot
          const ChatBot(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateToPage,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Wishlists',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String title, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () {
        _filterByCategory(title);
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 24),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected ? Colors.black : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.black : Colors.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (isSelected)
              Container(
                height: 2,
                width: 24,
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;

      if (category == 'Beachfront') {
        _filteredListings = _allListings
            .where((property) => property.categories.contains('Beachfront'))
            .toList();
      } else if (category == 'Amazing views') {
        _filteredListings = _allListings
            .where((property) => property.categories.contains('Amazing views'))
            .toList();
      } else if (category == 'Countryside') {
        _filteredListings = _allListings
            .where((property) => property.categories.contains('Countryside'))
            .toList();
      } else if (category == 'Amazing pools') {
        _filteredListings = _allListings
            .where((property) => property.categories.contains('Amazing pools'))
            .toList();
      }
    });
  }

  Widget _buildPropertyCard(PropertyListing property) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyDetailPage(property: property),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    property.imageUrl,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: () => _toggleWishlist(property),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _wishlist.contains(property)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: _wishlist.contains(property)
                            ? Colors.red
                            : Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property.location,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        property.distance,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        property.dates,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text:
                                        '\$${property.price.toStringAsFixed(0)} ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const TextSpan(text: 'total'),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _openMap(property);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Map',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: const Icon(
                                      Icons.grid_view,
                                      color: Colors.black,
                                      size: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      property.rating.toString(),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PropertyListing {
  final String id;
  final String title;
  final String location;
  final double price;
  final String imageUrl;
  final double rating;
  final String distance;
  final String dates;
  final String propertyType;
  final List<String> amenities;
  final int bedrooms;
  final int bathrooms;
  final bool isInstantBook;
  final bool isSuperhost;
  final List<String> categories;

  PropertyListing({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.distance,
    required this.dates,
    required this.propertyType,
    required this.amenities,
    required this.bedrooms,
    required this.bathrooms,
    required this.isInstantBook,
    required this.isSuperhost,
    this.categories = const [],
  });
}
