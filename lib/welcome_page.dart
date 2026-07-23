import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';
import 'screens/home_page.dart'; // ✅ CHANGED

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {

  late AnimationController _mainController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );

    _mainController.forward();

    // ⏳ After 5 seconds → Home Page
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, animation, __) => const HomePage(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 1000),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAnimatedLogo(),
                const SizedBox(height: 40),
                _buildTextContent(),
                const SizedBox(height: 60),
                _buildLoadingBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= UI METHODS (UNCHANGED) =================

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.5,
          colors: [
            Color(0xFF1E3A8A),
            Color(0xFF1E1B4B),
            Color(0xFF0F172A),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Stack(
        alignment: Alignment.center,
        children: [
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOutSine,
            builder: (context, double value, child) {
              return Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent
                          .withOpacity(0.2 + (value * 0.2)),
                      blurRadius: 30 + (value * 20),
                      spreadRadius: 5 + (value * 10),
                    ),
                  ],
                ),
              );
            },
          ),
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: const Icon(
              Icons.security_rounded,
              size: 80,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextContent() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          const Text(
            "PHONE GUARD",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 4.0,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "SILENT MISUSE DETECTION",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.blueAccent.shade100,
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingBar() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SizedBox(
        width: 180,
        child: Column(
          children: [
            const LinearProgressIndicator(
              backgroundColor: Colors.white10,
              color: Colors.blueAccent,
              minHeight: 2,
            ),
            const SizedBox(height: 10),
            Text(
              "INITIALIZING SYSTEM...",
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withOpacity(0.4),
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}