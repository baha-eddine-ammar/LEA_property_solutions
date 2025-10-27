import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/property_detail_page.dart';
import '../theme/app_theme.dart';

class SimilarProperties extends StatelessWidget {
  final PropertyListing currentProperty;
  final List<PropertyListing> allProperties;

  const SimilarProperties({
    Key? key,
    required this.currentProperty,
    required this.allProperties,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter properties to find similar ones
    final similarProperties = allProperties.where((property) {
      // Don't include the current property
      if (property.id == currentProperty.id) return false;
      
      // Include properties with same location or property type
      return property.location.split(',').first == currentProperty.location.split(',').first ||
             property.propertyType == currentProperty.propertyType ||
             property.categories.any((category) => currentProperty.categories.contains(category));
    }).toList();
    
    // If no similar properties, return empty container
    if (similarProperties.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Similar properties you may like',
          style: AppTheme.headingSmall,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: similarProperties.length,
            itemBuilder: (context, index) {
              final property = similarProperties[index];
              return _buildPropertyCard(context, property);
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildPropertyCard(BuildContext context, PropertyListing property) {
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
        width: 220,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                property.imageUrl,
                height: 160,
                width: 220,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            
            // Property details
            Row(
              children: [
                Expanded(
                  child: Text(
                    property.location.split(',').first,
                    style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.star, size: 14),
                const SizedBox(width: 2),
                Text(
                  property.rating.toString(),
                  style: AppTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              property.propertyType,
              style: AppTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              property.distance,
              style: AppTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '\$${property.price.toStringAsFixed(0)} ',
                    style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: 'total',
                    style: AppTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
