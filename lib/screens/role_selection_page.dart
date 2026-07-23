import 'dart:ui';
import 'package:flutter/material.dart';
import 'student_register_page.dart';
import 'teacher_register_page.dart';
import 'login_page.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);

    _mainController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Deep Slate
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
          ),
        ),
      ),
      body: Stack(
        children: [
          // 1. Animated Liquid Background
          _buildAnimatedBg(),

          // 2. Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTitle(),
                  const SizedBox(height: 60),
                  _buildRoleCard(
                    index: 0,
                    icon: Icons.school_rounded,
                    title: "Student",
                    subtitle: "Monitor & manage phone usage",
                    colors: [const Color(0xFF38BDF8), const Color(0xFF3B82F6)],
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StudentRegisterPage())),
                  ),
                  const SizedBox(height: 25),
                  _buildRoleCard(
                    index: 1,
                    icon: Icons.record_voice_over_rounded,
                    title: "Teacher",
                    subtitle: "Track & analyze student activity",
                    colors: [const Color(0xFFF472B6), const Color(0xFFDB2777)],
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TeacherRegisterPage())),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _mainController, curve: const Interval(0.0, 0.4)),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero).animate(
          CurvedAnimation(parent: _mainController, curve: Curves.easeOutBack),
        ),
        child: Column(
          children: [
            const Text(
              "Choose Your Role",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 4,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    final start = 0.3 + (index * 0.2);
    final animation = CurvedAnimation(
      parent: _mainController,
      curve: Interval(start, start + 0.4, curve: Curves.elasticOut),
    );

    return ScaleTransition(
      scale: animation,
      child: _InteractiveGlassCard(
        onTap: onTap,
        colors: colors,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 45, color: Colors.white),
            ),
            const SizedBox(width: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.6)),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_rounded, color: Colors.white24),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBg() {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: 100 * _bgController.value,
              left: -50,
              child: _orb(300, Colors.blue.withOpacity(0.15)),
            ),
            Positioned(
              bottom: 100 * (1 - _bgController.value),
              right: -50,
              child: _orb(400, Colors.pink.withOpacity(0.15)),
            ),
          ],
        );
      },
    );
  }

  Widget _orb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
        child: Container(color: Colors.transparent),
      ),
    );
  }
}

class _InteractiveGlassCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final List<Color> colors;
  const _InteractiveGlassCard({required this.child, required this.onTap, required this.colors});

  @override
  State<_InteractiveGlassCard> createState() => _InteractiveGlassCardState();
}

class _InteractiveGlassCardState extends State<_InteractiveGlassCard> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.95),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 150),
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: widget.colors.first.withOpacity(0.3),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}