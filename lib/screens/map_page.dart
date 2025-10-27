import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'property_detail_page.dart';

class MapPage extends StatelessWidget {
  final List<PropertyListing> properties;
  final String location;

  const MapPage({
    Key? key,
    required this.properties,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(location),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Map background (simulated with an image)
          Image.network(
            'https://maps.googleapis.com/maps/api/staticmap?center=$location&zoom=12&size=600x800&maptype=roadmap&key=YOUR_API_KEY',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              // Fallback if the map image fails to load
              return Container(
                color: Colors.grey[200],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.map, size: 100, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'Map of $location',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Property markers
          ...properties
              .map((property) => _buildPropertyMarker(context, property))
              .toList(),

          // Bottom sheet with property list
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.1,
            maxChildSize: 0.7,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 12, bottom: 8),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // Title
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        '${properties.length} places in $location',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Property list
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: properties.length,
                        itemBuilder: (context, index) {
                          final property = properties[index];
                          return _buildPropertyListItem(context, property);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyMarker(BuildContext context, PropertyListing property) {
    // Generate a random position for the marker (in a real app, this would use actual coordinates)
    final random = DateTime.now().millisecondsSinceEpoch % property.id.hashCode;
    final top = 100 + (random % 400).toDouble();
    final left = 50 + (random % 300).toDouble();

    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onTap: () {
          _showPropertyDetails(context, property);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(26),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            '\$${property.price.toStringAsFixed(0)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyListItem(
      BuildContext context, PropertyListing property) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          property.imageUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        property.title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        '${property.propertyType} · \$${property.price.toStringAsFixed(0)} total',
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        _showPropertyDetails(context, property);
      },
    );
  }

  void _showPropertyDetails(BuildContext context, PropertyListing property) {
    Navigator.pop(context); // Close map
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropertyDetailPage(property: property),
      ),
    );
  }
}
