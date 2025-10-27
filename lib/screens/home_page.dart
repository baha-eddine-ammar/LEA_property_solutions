import 'package:flutter/material.dart';
import '../components/property_card.dart';
import '../components/search_bar.dart';
import '../components/category_list.dart';
import '../components/filter_modal.dart';
import '../models/property.dart';
import 'property_details.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final List<Property> properties = [
    Property(
      id: '1',
      name: 'Osea Island, UK',
      location: '41 miles away',
      price: 21886,
      rating: 4.92,
      images: [
        'assets/images/property1.jpg',
        'assets/images/property1_2.jpg',
        'assets/images/property1_3.jpg',
      ],
      dates: 'Feb 8 - 13',
      description:
          'Luxurious beachfront property with stunning views of the ocean. This private island retreat offers a unique escape with pristine beaches, lush gardens, and elegant interiors. Perfect for a peaceful getaway or special celebration.',
      isFavorite: false,
    ),
    Property(
      id: '2',
      name: 'Countryside Villa',
      location: '28 miles away',
      price: 12500,
      rating: 4.85,
      images: [
        'assets/images/property2.jpg',
        'assets/images/property2_2.jpg',
        'assets/images/property2_3.jpg',
      ],
      dates: 'Mar 10 - 15',
      description:
          'Beautiful countryside villa surrounded by rolling hills and vineyards. This spacious property features a private pool, outdoor dining area, and panoramic views. Enjoy the tranquility of nature while being just a short drive from charming villages and wineries.',
      isFavorite: false,
    ),
    Property(
      id: '3',
      name: 'Lakefront Cabin',
      location: '52 miles away',
      price: 8750,
      rating: 4.78,
      images: [
        'assets/images/property3.jpg',
        'assets/images/property3_2.jpg',
        'assets/images/property3_3.jpg',
      ],
      dates: 'Apr 5 - 10',
      description:
          'Cozy lakefront cabin with private dock and stunning water views. This rustic yet comfortable retreat offers the perfect balance of outdoor adventure and relaxation. Enjoy fishing, kayaking, or simply unwinding on the spacious deck overlooking the lake.',
      isFavorite: false,
    ),
    Property(
      id: '4',
      name: 'Modern City Apartment',
      location: 'In the city center',
      price: 6500,
      rating: 4.95,
      images: [
        'assets/images/property4.jpg',
        'assets/images/property4_2.jpg',
        'assets/images/property4_3.jpg',
      ],
      dates: 'May 15 - 20',
      description:
          'Stylish and modern apartment in the heart of the city. This recently renovated space features high-end finishes, smart home technology, and floor-to-ceiling windows with spectacular city views. Steps away from top restaurants, shopping, and cultural attractions.',
      isFavorite: false,
    ),
    Property(
      id: '5',
      name: 'Beachfront Bungalow',
      location: '5 miles from airport',
      price: 15200,
      rating: 4.89,
      images: [
        'assets/images/property5.jpg',
        'assets/images/property5_2.jpg',
        'assets/images/property5_3.jpg',
      ],
      dates: 'Jun 20 - 25',
      description:
          'Charming beachfront bungalow with direct access to white sand beaches. This tropical paradise offers indoor-outdoor living at its finest with a spacious veranda, hammocks, and breathtaking ocean views. Fall asleep to the sound of waves and wake up to stunning sunrises.',
      isFavorite: false,
    ),
  ];

  int _currentIndex = 0;
  String _searchQuery = '';
  List<Property> _filteredProperties = [];

  @override
  void initState() {
    super.initState();
    _filteredProperties = List.from(properties);
  }

  void _filterProperties(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredProperties = List.from(properties);
      } else {
        _filteredProperties = properties.where((property) {
          return property.name.toLowerCase().contains(query.toLowerCase()) ||
              property.location.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _currentIndex == 0
            ? Column(
                children: [
                  // Custom Search Bar with Filter Button
                  CustomSearchBar(
                    onSearch: _filterProperties,
                    onFilterTap: () {
                      _showFilterModal(context);
                    },
                  ),

                  // Categories List (Beachfront, Amazing views, etc.)
                  const CategoryList(),

                  // Property Listings
                  Expanded(
                    child: _filteredProperties.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No properties found for "$_searchQuery"',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _filteredProperties.length,
                            itemBuilder: (context, index) {
                              return PropertyCard(
                                property: _filteredProperties[index],
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PropertyDetailsPage(
                                        property: _filteredProperties[index],
                                      ),
                                    ),
                                  );
                                },
                                onFavorite: () {
                                  setState(() {
                                    // Find the actual property in the main list
                                    final mainIndex = properties.indexWhere(
                                        (p) =>
                                            p.id ==
                                            _filteredProperties[index].id);
                                    if (mainIndex != -1) {
                                      properties[mainIndex].isFavorite =
                                          !properties[mainIndex].isFavorite;
                                      // Update the filtered list as well
                                      _filteredProperties[index].isFavorite =
                                          properties[mainIndex].isFavorite;
                                    }
                                  });
                                },
                              );
                            },
                          ),
                  ),
                ],
              )
            : _currentIndex == 1
                ? _buildWishlistsPage()
                : _currentIndex == 2
                    ? _buildTripsPage()
                    : _currentIndex == 3
                        ? _buildInboxPage()
                        : _buildProfilePage(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
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
            icon: Icon(Icons.card_travel),
            label: 'Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: const FilterModal(),
      ),
    );
  }

  Widget _buildWishlistsPage() {
    final favoriteProperties = properties.where((p) => p.isFavorite).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Wishlists',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          favoriteProperties.isEmpty
              ? Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.favorite_border,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No saved properties yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Tap the heart icon on any property to save it here',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _currentIndex = 0; // Go to Explore tab
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Explore properties'),
                        ),
                      ],
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: favoriteProperties.length,
                    itemBuilder: (context, index) {
                      return PropertyCard(
                        property: favoriteProperties[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PropertyDetailsPage(
                                property: favoriteProperties[index],
                              ),
                            ),
                          );
                        },
                        onFavorite: () {
                          setState(() {
                            // Find the actual property in the main list
                            final mainIndex = properties.indexWhere(
                                (p) => p.id == favoriteProperties[index].id);
                            if (mainIndex != -1) {
                              properties[mainIndex].isFavorite = false;
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildTripsPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.card_travel,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'No trips booked yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'When you book a trip, it will appear here',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _currentIndex = 0; // Go to Explore tab
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Explore properties'),
          ),
        ],
      ),
    );
  }

  Widget _buildInboxPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Inbox Header
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Inbox',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Tab Bar
        Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.black, width: 2)),
                  ),
                  child: const Center(
                    child: Text(
                      'Messages',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const Center(
                    child: Text(
                      'Notifications',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Messages List
        Expanded(
          child: ListView(
            children: [
              _buildInboxMessageCard(
                senderName: 'Natacha',
                senderLocation: 'Haslemere',
                title: 'Airbnb update: Reservation request declined',
                message: 'Request declined · Feb 5 - 10',
                time: '2 hours ago',
                isUnread: true,
                senderImage: 'assets/images/profile.jpg',
              ),
              const Divider(height: 1),
              _buildInboxMessageCard(
                senderName: 'LEA Support Team',
                senderLocation: 'Support',
                title: 'Welcome to LEA Property Solutions!',
                message:
                    'Thank you for joining our platform. We\'re excited to help you find your perfect property. Browse our listings and feel free to contact us if you have any questions.',
                time: 'Yesterday',
                isUnread: false,
                senderImage: 'assets/images/profile.jpg',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInboxMessageCard({
    required String senderName,
    required String senderLocation,
    required String title,
    required String message,
    required String time,
    required bool isUnread,
    required String senderImage,
  }) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sender Image
            CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(senderImage),
            ),
            const SizedBox(width: 16),
            // Message Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        senderName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Text(' · '),
                      Text(
                        senderLocation,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight:
                          isUnread ? FontWeight.bold : FontWeight.normal,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePage() {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          floating: true,
          title: Text(
            'Profile',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.settings, color: Colors.black),
              onPressed: null, // Will be implemented later
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/images/profile.jpg'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'John Doe',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Member since 2023',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Profile Actions
                _buildActionButton(
                  icon: Icons.edit,
                  label: 'Edit profile',
                  onTap: () {},
                ),
                _buildActionButton(
                  icon: Icons.favorite_border,
                  label: 'Wishlists',
                  onTap: () {
                    setState(() {
                      _currentIndex = 1; // Go to Wishlists tab
                    });
                  },
                ),
                const Divider(height: 32),
                // Hosting Section
                const Text(
                  'Hosting',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildActionButton(
                  icon: Icons.home,
                  label: 'List your property',
                  onTap: () {},
                ),
                _buildActionButton(
                  icon: Icons.info_outline,
                  label: 'Learn about hosting',
                  onTap: () {},
                ),
                const Divider(height: 32),
                // Support Section
                const Text(
                  'Support',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildActionButton(
                  icon: Icons.help,
                  label: 'Get help',
                  onTap: () {},
                ),
                _buildActionButton(
                  icon: Icons.security,
                  label: 'Safety center',
                  onTap: () {},
                ),
                const Divider(height: 32),
                // Legal Section
                const Text(
                  'Legal',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildActionButton(
                  icon: Icons.privacy_tip,
                  label: 'Privacy policy',
                  onTap: () {},
                ),
                _buildActionButton(
                  icon: Icons.description,
                  label: 'Terms of service',
                  onTap: () {},
                ),
                const SizedBox(height: 24),
                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle logout
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Log out',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
