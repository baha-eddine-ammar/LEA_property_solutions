import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'search_history.dart';
import 'search_suggestions.dart';

class EnhancedSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSearch;
  final VoidCallback onFilterTap;
  final List<String> recentSearches;
  final Function(String) onSearchSelected;
  final Function(String) onSearchRemoved;
  final Function() onClearAllSearches;

  const EnhancedSearchBar({
    Key? key,
    required this.controller,
    required this.onSearch,
    required this.onFilterTap,
    required this.recentSearches,
    required this.onSearchSelected,
    required this.onSearchRemoved,
    required this.onClearAllSearches,
  }) : super(key: key);

  @override
  State<EnhancedSearchBar> createState() => _EnhancedSearchBarState();
}

class _EnhancedSearchBarState extends State<EnhancedSearchBar> {
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();
  final List<String> _popularDestinations = [
    'London, UK',
    'Paris, France',
    'New York, USA',
    'Tokyo, Japan',
    'Rome, Italy',
    'Barcelona, Spain',
  ];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _handleSearch(String value) {
    widget.onSearch(value);
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search bar
        Container(
          margin: const EdgeInsets.all(16),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.black),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: widget.controller,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: 'Search by location',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      onSubmitted: _handleSearch,
                      textInputAction: TextInputAction.search,
                    ),
                  ),
                  if (widget.controller.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        widget.controller.clear();
                        // Trigger search with empty query
                        widget.onSearch('');
                      },
                      child: const Icon(Icons.clear, color: Colors.grey),
                    ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: widget.onFilterTap,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.tune, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Search history and suggestions
        if (_isFocused)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Recent searches
                if (widget.recentSearches.isNotEmpty)
                  SearchHistory(
                    recentSearches: widget.recentSearches,
                    onSearchSelected: (search) {
                      widget.controller.text = search;
                      _handleSearch(search);
                      widget.onSearchSelected(search);
                    },
                    onSearchRemoved: widget.onSearchRemoved,
                    onClearAll: widget.onClearAllSearches,
                  ),
                
                // Popular destinations
                const SizedBox(height: 16),
                SearchSuggestions(
                  suggestions: _popularDestinations,
                  onSuggestionSelected: (suggestion) {
                    widget.controller.text = suggestion;
                    _handleSearch(suggestion);
                    widget.onSearchSelected(suggestion);
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
