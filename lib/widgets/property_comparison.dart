import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../theme/app_theme.dart';

class PropertyComparisonWidget extends StatelessWidget {
  final List<PropertyListing> properties;
  final Function(PropertyListing) onRemoveProperty;

  const PropertyComparisonWidget({
    Key? key,
    required this.properties,
    required this.onRemoveProperty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Property Comparison',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          
          // Properties
          SizedBox(
            height: 500,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columnSpacing: 24,
                  horizontalMargin: 16,
                  columns: [
                    const DataColumn(
                      label: Text(
                        'Features',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ...properties.map((property) {
                      return DataColumn(
                        label: _buildPropertyHeader(property),
                      );
                    }).toList(),
                  ],
                  rows: [
                    // Image row
                    DataRow(
                      cells: [
                        const DataCell(Text(
                          'Image',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        ...properties.map((property) {
                          return DataCell(
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                property.imageUrl,
                                width: 100,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                    
                    // Price row
                    DataRow(
                      cells: [
                        const DataCell(Text(
                          'Price',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        ...properties.map((property) {
                          return DataCell(
                            Text(
                              '\$${property.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                    
                    // Location row
                    DataRow(
                      cells: [
                        const DataCell(Text(
                          'Location',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        ...properties.map((property) {
                          return DataCell(
                            Text(property.location),
                          );
                        }).toList(),
                      ],
                    ),
                    
                    // Property type row
                    DataRow(
                      cells: [
                        const DataCell(Text(
                          'Type',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        ...properties.map((property) {
                          return DataCell(
                            Text(property.propertyType),
                          );
                        }).toList(),
                      ],
                    ),
                    
                    // Bedrooms row
                    DataRow(
                      cells: [
                        const DataCell(Text(
                          'Bedrooms',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        ...properties.map((property) {
                          return DataCell(
                            Text(property.bedrooms.toString()),
                          );
                        }).toList(),
                      ],
                    ),
                    
                    // Bathrooms row
                    DataRow(
                      cells: [
                        const DataCell(Text(
                          'Bathrooms',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        ...properties.map((property) {
                          return DataCell(
                            Text(property.bathrooms.toString()),
                          );
                        }).toList(),
                      ],
                    ),
                    
                    // Rating row
                    DataRow(
                      cells: [
                        const DataCell(Text(
                          'Rating',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        ...properties.map((property) {
                          return DataCell(
                            Row(
                              children: [
                                const Icon(Icons.star, size: 16, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text(property.rating.toString()),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                    
                    // Superhost row
                    DataRow(
                      cells: [
                        const DataCell(Text(
                          'Superhost',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        ...properties.map((property) {
                          return DataCell(
                            property.isSuperhost
                                ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
                                : const Icon(Icons.cancel, color: Colors.grey, size: 20),
                          );
                        }).toList(),
                      ],
                    ),
                    
                    // Instant Book row
                    DataRow(
                      cells: [
                        const DataCell(Text(
                          'Instant Book',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        ...properties.map((property) {
                          return DataCell(
                            property.isInstantBook
                                ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
                                : const Icon(Icons.cancel, color: Colors.grey, size: 20),
                          );
                        }).toList(),
                      ],
                    ),
                    
                    // Amenities row
                    DataRow(
                      cells: [
                        const DataCell(Text(
                          'Amenities',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        ...properties.map((property) {
                          return DataCell(
                            Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: property.amenities.map((amenity) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    amenity,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                    
                    // Categories row
                    DataRow(
                      cells: [
                        const DataCell(Text(
                          'Categories',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        ...properties.map((property) {
                          return DataCell(
                            Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: property.categories.map((category) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    category,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyHeader(PropertyListing property) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            property.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => onRemoveProperty(property),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.close, size: 12, color: Colors.red),
                SizedBox(width: 4),
                Text(
                  'Remove',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PropertyComparisonPage extends StatefulWidget {
  final List<PropertyListing> initialProperties;

  const PropertyComparisonPage({
    Key? key,
    required this.initialProperties,
  }) : super(key: key);

  @override
  State<PropertyComparisonPage> createState() => _PropertyComparisonPageState();
}

class _PropertyComparisonPageState extends State<PropertyComparisonPage> {
  late List<PropertyListing> _properties;

  @override
  void initState() {
    super.initState();
    _properties = List.from(widget.initialProperties);
  }

  void _removeProperty(PropertyListing property) {
    setState(() {
      _properties.remove(property);
    });
    
    if (_properties.isEmpty) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Properties'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: PropertyComparisonWidget(
          properties: _properties,
          onRemoveProperty: _removeProperty,
        ),
      ),
    );
  }
}
