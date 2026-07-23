import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/auth_service.dart';

class TeacherRegisterPage extends StatefulWidget {
  const TeacherRegisterPage({super.key});

  @override
  State<TeacherRegisterPage> createState() => _TeacherRegisterPageState();
}

class _TeacherRegisterPageState extends State<TeacherRegisterPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final employeeIdController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final departmentController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  String selectedDesignation = "Assistant Professor";
  final List<String> designations = ["Assistant Professor", "Associate Professor", "Professor", "HOD"];

  late AnimationController _mainController;

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _mainController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    nameController.dispose();
    employeeIdController.dispose();
    emailController.dispose();
    phoneController.dispose();
    departmentController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E), // Consistent midnight theme
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Teacher Registration", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          _buildBackgroundOrbs(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _staggeredItem(0, _buildHeader()),
                    const SizedBox(height: 30),
                    _staggeredItem(1, _inputField(nameController, "Full Name", Icons.person_outline)),
                    _staggeredItem(2, _inputField(employeeIdController, "Employee ID", Icons.badge_outlined)),
                    _staggeredItem(3, _inputField(emailController, "Official Email", Icons.email_outlined, keyboard: TextInputType.emailAddress)),
                    _staggeredItem(4, _inputField(phoneController, "Contact Number", Icons.phone_android_outlined, keyboard: TextInputType.phone)),
                    _staggeredItem(5, _inputField(departmentController, "Department", Icons.account_balance_outlined)),
                    _staggeredItem(6, _designationDropdown()),
                    _staggeredItem(7, _inputField(passwordController, "Security Password", Icons.lock_outline, obscure: true)),
                    const SizedBox(height: 30),
                    _staggeredItem(8, _buildRegisterButton()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= UI COMPONENTS =================

  Widget _staggeredItem(int index, Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _mainController, curve: Interval(index * 0.1, 1.0, curve: Curves.easeOut)),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(parent: _mainController, curve: Interval(index * 0.1, 1.0, curve: Curves.easeOutBack))
        ),
        child: Padding(padding: const EdgeInsets.only(bottom: 16), child: child),
      ),
    );
  }

  Widget _buildBackgroundOrbs() {
    return Stack(
      children: [
        Positioned(top: -100, right: -50, child: _orb(300, Colors.purpleAccent.withOpacity(0.15))),
        Positioned(bottom: -50, left: -50, child: _orb(250, Colors.pinkAccent.withOpacity(0.1))),
      ],
    );
  }

  Widget _orb(double size, Color color) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60), child: Container(color: Colors.transparent)),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)]),
        boxShadow: [BoxShadow(color: Colors.purpleAccent.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: const Column(
        children: [
          Icon(Icons.assignment_ind_rounded, color: Colors.white, size: 55),
          SizedBox(height: 12),
          Text("Faculty Portal", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1)),
          Text("Create your educator profile", style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _inputField(TextEditingController controller, String label, IconData icon, {bool obscure = false, TextInputType keyboard = TextInputType.text}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboard,
          style: const TextStyle(color: Colors.white),
          validator: (v) => v == null || v.trim().isEmpty ? "Required" : null,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.purpleAccent.shade100),
            labelText: label,
            labelStyle: const TextStyle(color: Colors.white38),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.purpleAccent)),
          ),
        ),
      ),
    );
  }

  Widget _designationDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1))
      ),
      child: DropdownButtonFormField<String>(
        value: selectedDesignation,
        dropdownColor: const Color(0xFF1A1A2E),
        style: const TextStyle(color: Colors.white),
        items: designations.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
        onChanged: (v) => setState(() => selectedDesignation = v!),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.work_outline, color: Colors.purpleAccent.shade100),
          labelText: "Designation",
          labelStyle: const TextStyle(color: Colors.white38, fontSize: 12),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)]),
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : _registerTeacher,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))
        ),
        child: isLoading
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text("REGISTER FACULTY", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.white)),
      ),
    );
  }

  // ================= LOGIC =================

  Future<void> _registerTeacher() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    try {
      final user = await AuthService().registerWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        userData: {
          'role': 'teacher',
          'email': emailController.text.trim(),
          'createdAt': Timestamp.now(),
        },
      );

      if (user == null) throw Exception("Registration failed");

      await FirebaseFirestore.instance.collection('teachers').doc(user.uid).set({
        'name': nameController.text.trim(),
        'employeeId': employeeIdController.text.trim(),
        'phone': phoneController.text.trim(),
        'department': departmentController.text.trim(),
        'designation': selectedDesignation,
        'email': emailController.text.trim(),
        'uid': user.uid,
        'createdAt': Timestamp.now(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Teacher account verified and created!"), backgroundColor: Colors.purpleAccent));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.redAccent));
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
}