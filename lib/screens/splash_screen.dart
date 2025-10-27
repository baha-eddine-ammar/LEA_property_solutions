import 'package:flutter/material.dart';
import 'onboarding_screens.dart';
import '../assets/logo.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  // Additional animations for enhanced effects
  late Animation<double> _rotateAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.8, curve: Curves.easeOutCubic),
    ));

    // Rotation animation for background elements
    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 0.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
    ));

    // Pulse animation for logo
    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.05), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
    ));

    _controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const OnboardingScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var fadeAnim =
                  Tween<double>(begin: 0.0, end: 1.0).animate(animation);
              return FadeTransition(opacity: fadeAnim, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background gradient with animated overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.white,
                  AppTheme.backgroundColor.withAlpha(76),
                  AppTheme.backgroundColor.withAlpha(178),
                ],
              ),
            ),
          ),

          // Animated background patterns
          Positioned(
            top: -screenSize.height * 0.1,
            right: -screenSize.width * 0.1,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value * 0.15,
                  child: Transform.rotate(
                    angle: _rotateAnimation.value,
                    child: Container(
                      width: screenSize.width * 0.7,
                      height: screenSize.width * 0.7,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Positioned(
            bottom: -screenSize.height * 0.15,
            left: -screenSize.width * 0.15,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value * 0.2,
                  child: Transform.rotate(
                    angle: -_rotateAnimation.value * 1.5,
                    child: Container(
                      width: screenSize.width * 0.8,
                      height: screenSize.width * 0.8,
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor.withAlpha(20),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Decorative elements
          Positioned(
            top: screenSize.height * 0.15,
            left: screenSize.width * 0.1,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value * 0.3,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor.withAlpha(150),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          ),

          Positioned(
            bottom: screenSize.height * 0.25,
            right: screenSize.width * 0.15,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value * 0.3,
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withAlpha(150),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with animated container
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value * _pulseAnimation.value,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          width: 180,
                          height: 180,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryColor.withAlpha(51),
                                blurRadius: 25,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Pulsating background
                              AnimatedBuilder(
                                animation: _controller,
                                builder: (context, child) {
                                  return Opacity(
                                    opacity:
                                        (0.5 + (_controller.value * 0.5)) * 0.3,
                                    child: Container(
                                      width: 140 + (_controller.value * 20),
                                      height: 140 + (_controller.value * 20),
                                      decoration: BoxDecoration(
                                        color:
                                            AppTheme.primaryColor.withAlpha(30),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              // Logo
                              const AppLogo(size: 90),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),

                // Text with enhanced animation
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        // Main title with enhanced styling
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              AppTheme.primaryColor,
                              AppTheme.accentColor,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: Text(
                            'LEA PROPERTY',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: AppTheme.primaryColor.withAlpha(100),
                                  offset: const Offset(0, 3),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'SOLUTIONS',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 4,
                            color: AppTheme.primaryColor.withAlpha(230),
                          ),
                        ),

                        // Tagline
                        const SizedBox(height: 16),
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _controller.value > 0.7
                                  ? (_controller.value - 0.7) * 3.3
                                  : 0,
                              child: const Text(
                                'Find your perfect stay',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppTheme.subtitleColor,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Loading indicator
                const SizedBox(height: 60),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: SizedBox(
                        width: 180,
                        child: LinearProgressIndicator(
                          value: _controller.value,
                          backgroundColor: Colors.grey[200],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryColor),
                          borderRadius: BorderRadius.circular(10),
                          minHeight: 6,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
