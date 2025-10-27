import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> images;
  final double height;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final BoxFit imageFit;

  const ImageCarousel({
    Key? key,
    required this.images,
    this.height = 300,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.imageFit = BoxFit.cover,
  }) : super(key: key);

  @override
  ImageCarouselState createState() => ImageCarouselState();
}

class ImageCarouselState extends State<ImageCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    if (widget.autoPlay && widget.images.length > 1) {
      Future.delayed(widget.autoPlayInterval, _autoPlayImages);
    }
  }

  void _autoPlayImages() {
    if (!mounted) return;
    
    if (_currentPage < widget.images.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
    
    Future.delayed(widget.autoPlayInterval, _autoPlayImages);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          // Images
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return Image.asset(
                widget.images[index],
                fit: widget.imageFit,
                width: double.infinity,
              );
            },
          ),
          
          // Indicators
          if (widget.images.length > 1)
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.images.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _currentPage == index ? 16 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index 
                          ? Colors.white 
                          : Colors.white.withAlpha(128),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
