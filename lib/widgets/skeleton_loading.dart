import 'package:flutter/material.dart';

class SkeletonLoading extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonLoading({
    Key? key,
    this.width = double.infinity,
    this.height = 20,
    this.borderRadius = 4,
  }) : super(key: key);

  @override
  State<SkeletonLoading> createState() => _SkeletonLoadingState();
}

class _SkeletonLoadingState extends State<SkeletonLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(_animation.value, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: const [
                Color(0xFFEEEEEE),
                Color(0xFFF5F5F5),
                Color(0xFFEEEEEE),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PropertyCardSkeleton extends StatelessWidget {
  const PropertyCardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          const SkeletonLoading(
            height: 300,
            borderRadius: 12,
          ),
          const SizedBox(height: 12),
          
          // Title placeholder
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: SkeletonLoading(
                  height: 20,
                  width: 200,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 50,
                child: const Row(
                  children: [
                    SkeletonLoading(
                      width: 14,
                      height: 14,
                      borderRadius: 7,
                    ),
                    SizedBox(width: 4),
                    SkeletonLoading(
                      width: 30,
                      height: 14,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Details placeholders
          const SkeletonLoading(
            height: 16,
            width: 150,
          ),
          const SizedBox(height: 8),
          const SkeletonLoading(
            height: 16,
            width: 120,
          ),
          const SizedBox(height: 8),
          
          // Price placeholder
          const SkeletonLoading(
            height: 20,
            width: 100,
          ),
        ],
      ),
    );
  }
}

class PropertyDetailSkeleton extends StatelessWidget {
  const PropertyDetailSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          const SkeletonLoading(
            height: 300,
          ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title placeholder
                const SkeletonLoading(
                  height: 28,
                  width: 250,
                ),
                const SizedBox(height: 8),
                
                // Rating and location placeholder
                Row(
                  children: [
                    const SkeletonLoading(
                      height: 16,
                      width: 50,
                      borderRadius: 8,
                    ),
                    const SizedBox(width: 8),
                    const SkeletonLoading(
                      height: 16,
                      width: 150,
                      borderRadius: 8,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                
                // Host info placeholder
                Row(
                  children: [
                    const SkeletonLoading(
                      height: 48,
                      width: 48,
                      borderRadius: 24,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SkeletonLoading(
                          height: 18,
                          width: 120,
                        ),
                        const SizedBox(height: 4),
                        const SkeletonLoading(
                          height: 14,
                          width: 80,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                
                // Features placeholder
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildFeatureSkeleton(),
                    _buildFeatureSkeleton(),
                    _buildFeatureSkeleton(),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                
                // Description placeholder
                const SkeletonLoading(
                  height: 24,
                  width: 150,
                ),
                const SizedBox(height: 16),
                const SkeletonLoading(
                  height: 16,
                ),
                const SizedBox(height: 8),
                const SkeletonLoading(
                  height: 16,
                ),
                const SizedBox(height: 8),
                const SkeletonLoading(
                  height: 16,
                  width: 250,
                ),
                const SizedBox(height: 24),
                
                // Amenities placeholder
                const SkeletonLoading(
                  height: 24,
                  width: 180,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(
                    6,
                    (index) => const SkeletonLoading(
                      height: 36,
                      width: 100,
                      borderRadius: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 100), // Space for bottom bar
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFeatureSkeleton() {
    return Column(
      children: [
        const SkeletonLoading(
          height: 28,
          width: 28,
          borderRadius: 14,
        ),
        const SizedBox(height: 8),
        const SkeletonLoading(
          height: 14,
          width: 80,
        ),
      ],
    );
  }
}
