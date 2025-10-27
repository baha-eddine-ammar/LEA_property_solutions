import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PropertyImageCarousel extends StatefulWidget {
  final String mainImageUrl;
  final List<String> additionalImages;
  final double height;
  final double borderRadius;
  final bool showIndicator;

  const PropertyImageCarousel({
    Key? key,
    required this.mainImageUrl,
    this.additionalImages = const [],
    this.height = 300,
    this.borderRadius = 12,
    this.showIndicator = true,
  }) : super(key: key);

  @override
  State<PropertyImageCarousel> createState() => _PropertyImageCarouselState();
}

class _PropertyImageCarouselState extends State<PropertyImageCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_onPageChanged);
  }
  
  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    super.dispose();
  }
  
  void _onPageChanged() {
    final page = _pageController.page?.round() ?? 0;
    if (page != _currentPage) {
      setState(() {
        _currentPage = page;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Combine main image with additional images
    final allImages = [widget.mainImageUrl, ...widget.additionalImages];
    
    return Stack(
      children: [
        // Image carousel
        ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: SizedBox(
            height: widget.height,
            child: PageView.builder(
              controller: _pageController,
              itemCount: allImages.length,
              itemBuilder: (context, index) {
                return Image.network(
                  allImages[index],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(
                          Icons.broken_image_rounded,
                          color: Colors.grey,
                          size: 48,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        
        // Navigation arrows
        if (allImages.length > 1)
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous button
                GestureDetector(
                  onTap: _currentPage > 0
                      ? () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(180),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: _currentPage > 0 ? Colors.black : Colors.grey[400],
                      size: 16,
                    ),
                  ),
                ),
                
                // Next button
                GestureDetector(
                  onTap: _currentPage < allImages.length - 1
                      ? () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(180),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: _currentPage < allImages.length - 1
                          ? Colors.black
                          : Colors.grey[400],
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        
        // Page indicator
        if (widget.showIndicator && allImages.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                allImages.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? AppTheme.primaryColor
                        : Colors.white.withAlpha(150),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
