import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SearchHistory extends StatefulWidget {
  final List<String> recentSearches;
  final Function(String) onSearchSelected;
  final Function(String) onSearchRemoved;
  final Function() onClearAll;

  const SearchHistory({
    Key? key,
    required this.recentSearches,
    required this.onSearchSelected,
    required this.onSearchRemoved,
    required this.onClearAll,
  }) : super(key: key);

  @override
  State<SearchHistory> createState() => _SearchHistoryState();
}

class _SearchHistoryState extends State<SearchHistory> {
  @override
  Widget build(BuildContext context) {
    if (widget.recentSearches.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent searches',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: widget.onClearAll,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Clear all',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Search items
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: widget.recentSearches.length > 5 
                ? 5 // Limit to 5 recent searches
                : widget.recentSearches.length,
            itemBuilder: (context, index) {
              final search = widget.recentSearches[index];
              return _buildSearchItem(search);
            },
          ),
          
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSearchItem(String search) {
    return InkWell(
      onTap: () => widget.onSearchSelected(search),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(
              Icons.history,
              size: 18,
              color: AppTheme.subtitleColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                search,
                style: const TextStyle(
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            GestureDetector(
              onTap: () => widget.onSearchRemoved(search),
              child: const Icon(
                Icons.close,
                size: 18,
                color: AppTheme.subtitleColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
