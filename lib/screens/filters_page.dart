import 'package:flutter/material.dart';

class FiltersPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilters;
  final Map<String, dynamic> currentFilters;

  const FiltersPage({
    super.key,
    required this.onApplyFilters,
    required this.currentFilters,
  });

  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  late String selectedPropertyType;
  late List<String> selectedAmenities;
  late RangeValues priceRange;
  late int selectedBedrooms;
  late int selectedBeds;
  late int selectedBathrooms;
  late bool isPrivateRoom;
  late bool isSharedRoom;
  late bool isSuperhost;
  late bool isAirbnbPlus;
  late bool isEntirePlace;
  late List<String> selectedAccessibilityFeatures;

  @override
  void initState() {
    super.initState();
    // Initialize with current filters or defaults
    selectedPropertyType = widget.currentFilters['propertyType'] ?? '';
    selectedAmenities =
        List<String>.from(widget.currentFilters['amenities'] ?? []);
    priceRange =
        widget.currentFilters['priceRange'] ?? const RangeValues(10, 280);
    selectedBedrooms = widget.currentFilters['bedrooms'] ?? 0;
    selectedBeds = widget.currentFilters['beds'] ?? 0;
    selectedBathrooms = widget.currentFilters['bathrooms'] ?? 0;
    isPrivateRoom = widget.currentFilters['isPrivateRoom'] ?? false;
    isSharedRoom = widget.currentFilters['isSharedRoom'] ?? false;
    isSuperhost = widget.currentFilters['isSuperhost'] ?? false;
    isAirbnbPlus = widget.currentFilters['isAirbnbPlus'] ?? false;
    isEntirePlace = widget.currentFilters['isEntirePlace'] ?? false;
    selectedAccessibilityFeatures =
        List<String>.from(widget.currentFilters['accessibilityFeatures'] ?? []);
  }

  void _applyFilters() {
    widget.onApplyFilters({
      'propertyType': selectedPropertyType,
      'amenities': selectedAmenities,
      'priceRange': priceRange,
      'bedrooms': selectedBedrooms,
      'beds': selectedBeds,
      'bathrooms': selectedBathrooms,
      'isPrivateRoom': isPrivateRoom,
      'isSharedRoom': isSharedRoom,
      'isSuperhost': isSuperhost,
      'isAirbnbPlus': isAirbnbPlus,
      'isEntirePlace': isEntirePlace,
      'accessibilityFeatures': selectedAccessibilityFeatures,
    });
    Navigator.pop(context);
  }

  void _clearAll() {
    setState(() {
      selectedPropertyType = '';
      selectedAmenities = [];
      priceRange = const RangeValues(10, 280);
      selectedBedrooms = 0;
      selectedBeds = 0;
      selectedBathrooms = 0;
      isPrivateRoom = false;
      isSharedRoom = false;
      isSuperhost = false;
      isAirbnbPlus = false;
      isEntirePlace = false;
      selectedAccessibilityFeatures = [];
    });
  }

  Widget _buildPropertyTypeCard(String type, IconData icon) {
    bool isSelected = selectedPropertyType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPropertyType = isSelected ? '' : type;
        });
      },
      child: Container(
        width: (MediaQuery.of(context).size.width - 64) / 2,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 24),
            const SizedBox(height: 8),
            Text(
              type,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberSelector(
      String title, int value, Function(int) onChanged) {
    return Row(
      children: [
        for (var i = 0; i <= 4; i++)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(i == 0 ? 'Any' : i.toString()),
              selected: value == i,
              onSelected: (bool selected) {
                if (selected) {
                  onChanged(i);
                }
              },
              backgroundColor: Colors.white,
              selectedColor: Colors.black,
              labelStyle: TextStyle(
                color: value == i ? Colors.white : Colors.black,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Filters',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Property type',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildPropertyTypeCard('House', Icons.home),
                  _buildPropertyTypeCard('Apartment', Icons.apartment),
                  _buildPropertyTypeCard('Guesthouse', Icons.house_siding),
                  _buildPropertyTypeCard('Hotel', Icons.business),
                ],
              ),
            ),
            const Divider(height: 32),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Price range',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The average nightly price is \$122',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  RangeSlider(
                    values: priceRange,
                    min: 10,
                    max: 280,
                    divisions: 27,
                    labels: RangeLabels(
                      '\$${priceRange.start.round()}',
                      '\$${priceRange.end.round()}',
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        priceRange = values;
                      });
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Minimum'),
                              Text(
                                'US\$${priceRange.start.round()}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('—'),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Maximum'),
                              Text(
                                'US\$${priceRange.end.round()}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
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
            const Divider(height: 32),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rooms and beds',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Bedrooms'),
                  const SizedBox(height: 8),
                  _buildNumberSelector(
                    'Bedrooms',
                    selectedBedrooms,
                    (value) => setState(() => selectedBedrooms = value),
                  ),
                  const SizedBox(height: 16),
                  const Text('Beds'),
                  const SizedBox(height: 8),
                  _buildNumberSelector(
                    'Beds',
                    selectedBeds,
                    (value) => setState(() => selectedBeds = value),
                  ),
                  const SizedBox(height: 16),
                  const Text('Bathrooms'),
                  const SizedBox(height: 8),
                  _buildNumberSelector(
                    'Bathrooms',
                    selectedBathrooms,
                    (value) => setState(() => selectedBathrooms = value),
                  ),
                ],
              ),
            ),
            const Divider(height: 32),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Type of place',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    value: isEntirePlace,
                    onChanged: (value) {
                      setState(() {
                        isEntirePlace = value ?? false;
                      });
                    },
                    title: const Text('Entire place'),
                    subtitle: const Text('A place all to yourself'),
                    controlAffinity: ListTileControlAffinity.trailing,
                  ),
                  CheckboxListTile(
                    value: isPrivateRoom,
                    onChanged: (value) {
                      setState(() {
                        isPrivateRoom = value ?? false;
                      });
                    },
                    title: const Text('Private room'),
                    subtitle: const Text(
                        'Your own room in a home or hotel, plus some shared common spaces'),
                    controlAffinity: ListTileControlAffinity.trailing,
                  ),
                  CheckboxListTile(
                    value: isSharedRoom,
                    onChanged: (value) {
                      setState(() {
                        isSharedRoom = value ?? false;
                      });
                    },
                    title: const Text('Shared room'),
                    subtitle: const Text(
                        'A sleeping space and common areas that may be shared with others'),
                    controlAffinity: ListTileControlAffinity.trailing,
                  ),
                ],
              ),
            ),
            const Divider(height: 32),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Amenities',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Essentials',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...[
                    'Wifi',
                    'Kitchen',
                    'Washer',
                    'Dryer',
                    'Air conditioning',
                    'Heating',
                    'Dedicated workspace',
                    'TV',
                    'Hair dryer',
                    'Iron'
                  ]
                      .map((amenity) => CheckboxListTile(
                            value: selectedAmenities.contains(amenity),
                            onChanged: (value) {
                              setState(() {
                                if (value ?? false) {
                                  selectedAmenities.add(amenity);
                                } else {
                                  selectedAmenities.remove(amenity);
                                }
                              });
                            },
                            title: Text(amenity),
                            controlAffinity: ListTileControlAffinity.trailing,
                          ))
                      .toList(),
                ],
              ),
            ),
            const Divider(height: 32),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Accessibility features',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...[
                    'Step-free guest entrance',
                    'Guest entrance wider than 32 inches',
                    'Step-free path to the guest entrance'
                  ]
                      .map((feature) => CheckboxListTile(
                            value:
                                selectedAccessibilityFeatures.contains(feature),
                            onChanged: (value) {
                              setState(() {
                                if (value ?? false) {
                                  selectedAccessibilityFeatures.add(feature);
                                } else {
                                  selectedAccessibilityFeatures.remove(feature);
                                }
                              });
                            },
                            title: Text(feature),
                            controlAffinity: ListTileControlAffinity.trailing,
                          ))
                      .toList(),
                ],
              ),
            ),
            const Divider(height: 32),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Top tier stays',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    value: isSuperhost,
                    onChanged: (value) {
                      setState(() {
                        isSuperhost = value;
                      });
                    },
                    title: const Text('Superhost'),
                    subtitle: const Text('Stay with recognized Hosts'),
                  ),
                  SwitchListTile(
                    value: isAirbnbPlus,
                    onChanged: (value) {
                      setState(() {
                        isAirbnbPlus = value;
                      });
                    },
                    title: const Text('Airbnb Plus'),
                    subtitle: const Text(
                        'A selection of places to stay verified for quality and design'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            TextButton(
              onPressed: _clearAll,
              child: const Text(
                'Clear all',
                style: TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Show ${widget.currentFilters['totalHomes'] ?? 0} homes',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
