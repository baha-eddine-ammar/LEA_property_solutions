import 'package:flutter/material.dart';

class FilterModal extends StatefulWidget {
  const FilterModal({Key? key}) : super(key: key);

  @override
  FilterModalState createState() => FilterModalState();
}

class FilterModalState extends State<FilterModal> {
  RangeValues _priceRange = const RangeValues(0, 1000);
  String? _selectedPropertyType;
  final Map<String, bool> _amenities = {
    'Wifi': false,
    'Kitchen': false,
    'Washer': false,
    'Air conditioning': false,
    'Pool': false,
    'Free parking': false,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
              const Text(
                'Filters',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _priceRange = const RangeValues(0, 1000);
                    _selectedPropertyType = null;
                    _amenities.forEach((key, value) {
                      _amenities[key] = false;
                    });
                  });
                },
                child: const Text('Clear all'),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Property Type
                  const Text(
                    'Property type',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildPropertyTypeChip('House'),
                      _buildPropertyTypeChip('Apartment'),
                      _buildPropertyTypeChip('Guesthouse'),
                      _buildPropertyTypeChip('Hotel'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Price Range
                  const Text(
                    'Price range',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 1000,
                    divisions: 100,
                    labels: RangeLabels(
                      '\$${_priceRange.start.round()}',
                      '\$${_priceRange.end.round()}',
                    ),
                    onChanged: (values) {
                      setState(() {
                        _priceRange = values;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${_priceRange.start.round()}'),
                      Text('\$${_priceRange.end.round()}'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Amenities
                  const Text(
                    'Amenities',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._amenities.entries.map((entry) {
                    return CheckboxListTile(
                      title: Text(entry.key),
                      value: entry.value,
                      onChanged: (bool? value) {
                        setState(() {
                          _amenities[entry.key] = value ?? false;
                        });
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          // Show Results Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                // Apply filters and close modal
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Show 300+ places',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyTypeChip(String label) {
    final isSelected = _selectedPropertyType == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPropertyType = isSelected ? null : label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
