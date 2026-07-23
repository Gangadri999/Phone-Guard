import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/auth_service.dart';

class StudentRegisterPage extends StatefulWidget {
  const StudentRegisterPage({super.key});

  @override
  State<StudentRegisterPage> createState() => _StudentRegisterPageState();
}

class _StudentRegisterPageState extends State<StudentRegisterPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final nameController = TextEditingController();
  final rollNoController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  String selectedYear = "1st Year";
  String selectedBranch = "CSE";
  String selectedSection = "A";

  final years = ["1st Year", "2nd Year", "3rd Year", "4th Year"];
  final branches = ["CSE", "ECE", "EEE", "MECH", "CIVIL", "IT"];
  final sections = ["A", "B", "C", "D"];

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
    rollNoController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Student Registration", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Background Blobs for consistency
          _buildBackground(),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _staggeredItem(0, _buildHeader()),
                    const SizedBox(height: 30),
                    
                    // Input Fields Group
                    _staggeredItem(1, _inputField(nameController, "Full Name", Icons.person_outline_rounded)),
                    _staggeredItem(2, _inputField(rollNoController, "Roll Number", Icons.badge_outlined)),
                    _staggeredItem(3, _inputField(emailController, "Email Address", Icons.alternate_email_rounded, keyboard: TextInputType.emailAddress)),
                    _staggeredItem(4, _inputField(phoneController, "Phone Number", Icons.phone_android_rounded, keyboard: TextInputType.phone)),
                    
                    // Academic Grid
                    _staggeredItem(5, Row(
                      children: [
                        Expanded(child: _dropdown("Year", selectedYear, years, (v) => setState(() => selectedYear = v!))),
                        const SizedBox(width: 10),
                        Expanded(child: _dropdown("Branch", selectedBranch, branches, (v) => setState(() => selectedBranch = v!))),
                      ],
                    )),
                    _staggeredItem(6, _dropdown("Section", selectedSection, sections, (v) => setState(() => selectedSection = v!))),
                    
                    _staggeredItem(7, _inputField(passwordController, "Secure Password", Icons.lock_open_rounded, obscure: true)),
                    
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

  // ================= UI BUILDERS =================

  Widget _buildBackground() {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(top: -50, left: -50, child: _blob(200, Colors.blueAccent.withOpacity(0.15))),
          Positioned(bottom: 100, right: -100, child: _blob(300, Colors.indigoAccent.withOpacity(0.1))),
        ],
      ),
    );
  }

  Widget _blob(double size, Color color) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50), child: Container(color: Colors.transparent)),
    );
  }

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

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(colors: [Colors.blueAccent, Colors.indigoAccent]),
        boxShadow: [BoxShadow(color: Colors.blueAccent.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: const Column(
        children: [
          Icon(Icons.auto_stories_rounded, color: Colors.white, size: 50),
          SizedBox(height: 12),
          Text("Academic Profile", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          Text("Join the student community", style: TextStyle(color: Colors.white70)),
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
          validator: (v) => v == null || v.isEmpty ? "Required" : null,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.white70),
            labelText: label,
            labelStyle: const TextStyle(color: Colors.white38),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.blueAccent)),
          ),
        ),
      ),
    );
  }

  Widget _dropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.1))),
      child: DropdownButtonFormField<String>(
        value: value,
        dropdownColor: const Color(0xFF1A1A2E),
        style: const TextStyle(color: Colors.white),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(labelText: label, labelStyle: const TextStyle(color: Colors.white38, fontSize: 12), border: InputBorder.none, prefixIcon: const Icon(Icons.layers_outlined, color: Colors.white70)),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(colors: [Colors.blueAccent, Colors.indigoAccent]),
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : _registerStudent,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
        child: isLoading
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text("CREATE ACCOUNT", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.white)),
      ),
    );
  }

  // ================= LOGIC =================

  Future<void> _registerStudent() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    try {
      final user = await AuthService().registerWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        userData: {
          'role': 'student',
          'email': emailController.text.trim(),
          'createdAt': Timestamp.now(),
        },
      );

      if (user == null) throw Exception("Registration failed");

      await FirebaseFirestore.instance.collection('students').doc(user.uid).set({

  'name': nameController.text.trim(),
  'rollNo': rollNoController.text.trim(),
  'phone': phoneController.text.trim(),

  // 🔥 IMPORTANT FIX
  'department': selectedBranch,

  // Convert "3rd Year" → "3"
  'year': selectedYear[0],

  'section': selectedSection,

  // 🔥 CLASS ID (VERY IMPORTANT)
  'classId': "${selectedBranch}_${selectedYear[0]}_$selectedSection",

  'email': emailController.text.trim(),
  'uid': user.uid,

  // 🔥 REQUIRED FIELDS
  'online': false,
  'teachingMode': false,

  'createdAt': Timestamp.now(),
});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile Created Successfully!"), backgroundColor: Colors.green));
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