import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth/auth_service.dart';
import 'role_selection_page.dart';
import 'student_dashboard.dart';
import 'teacher_dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with TickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool obscure = true;

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
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    _mainController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _bgController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // -------------------- UI --------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 40),
                    _buildGlassCard(),
                    const SizedBox(height: 20),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (_, __) {
        return Stack(
          children: [
            Positioned(
              top: -100 + (50 * _bgController.value),
              left: -50 + (30 * _bgController.value),
              child: _blob(300, Colors.indigo.withOpacity(0.4)),
            ),
            Positioned(
              bottom: -50,
              right: -50 - (40 * _bgController.value),
              child: _blob(400, Colors.deepPurple.withOpacity(0.3)),
            ),
          ],
        );
      },
    );
  }

  Widget _blob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
        child: Container(color: Colors.transparent),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        _staggeredFade(
          index: 0,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
            child: const Icon(Icons.security_rounded,
                size: 60, color: Colors.white),
          ),
        ),
        const SizedBox(height: 16),
        _staggeredFade(
          index: 1,
          child: const Text(
            "Welcome TO PHONE GUARD",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassCard() {
    return _staggeredFade(
      index: 2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                _inputField(
                  hint: "Email",
                  controller: emailController,
                  icon: Icons.alternate_email_rounded,
                  isPassword: false,
                ),
                const SizedBox(height: 20),
                _inputField(
                  hint: "Password",
                  controller: passwordController,
                  icon: Icons.lock_outline_rounded,
                  isPassword: true,
                ),
                const SizedBox(height: 30),
                _buildLoginButton(),
                const SizedBox(height: 16),
                _buildGoogleButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: isLoading ? null : _emailLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1A1A2E),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: isLoading
            ? const CircularProgressIndicator(strokeWidth: 2)
            : const Text("LOGIN",
                style:
                    TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
      ),
    );
  }

  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton(
        onPressed: isLoading ? null : _googleLogin,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.white.withOpacity(0.5)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.g_mobiledata, color: Colors.white, size: 30),
            SizedBox(width: 8),
            Text("Continue with Google",
                style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return _staggeredFade(
      index: 3,
      child: TextButton(
        onPressed: _goToRegister,
        child: const Text("Don't have an account? Register",
            style: TextStyle(color: Colors.white70)),
      ),
    );
  }

  Widget _staggeredFade({required int index, required Widget child}) {
    final start = 0.1 * index;
    final end = (start + 0.5).clamp(0.0, 1.0);

    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _mainController,
        curve: Interval(start, end),
      ),
      child: SlideTransition(
        position:
            Tween(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _mainController,
            curve: Interval(start, end, curve: Curves.easeOutBack),
          ),
        ),
        child: child,
      ),
    );
  }

  // -------------------- LOGIC --------------------

  Future<void> _emailLogin() async {
    setState(() => isLoading = true);
    try {
      await AuthService().loginWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      await _redirectToDashboard();
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _googleLogin() async {
    setState(() => isLoading = true);
    try {
      await AuthService().signInWithGoogle();
      await _redirectToDashboard();
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
Future<void> _redirectToDashboard() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .get();

  if (!doc.exists) {
    _showError("User role not found");
    return;
  }

  final role = doc['role'];

  if (!mounted) return;

  if (role == 'teacher') {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const TeacherDashboard()),
    );
  } else {
    // 🔥 FETCH CLASS ID FROM FIRESTORE
    final studentDoc = await FirebaseFirestore.instance
    .collection('students')
    .doc(user.uid)
    .get();

final classId = studentDoc['classId'];

Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => StudentDashboard(
      studentId: user.uid,
      classId: classId,
    ),
  ),
);
  }
}

  Future<void> _goToRegister() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RoleSelectionPage()),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  Widget _inputField({
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    required bool isPassword,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? obscure : false,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white70,
                ),
                onPressed: () => setState(() => obscure = !obscure),
              )
            : null,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}