import 'package:flutter/material.dart';
import 'dart:ui';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with TickerProviderStateMixin {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nimController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fakultasController = TextEditingController();
  final TextEditingController prodiController = TextEditingController();
  final TextEditingController angkatanController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> registerMahasiswa() async {
    setState(() => _isLoading = true);
    final api = ApiService();
    final success = await api.register({
      'nama': namaController.text.trim(),
      'nim': nimController.text.trim(),
      'email': emailController.text.trim(),
      'password': passwordController.text,
      'fakultas': fakultasController.text.trim(),
      'prodi': prodiController.text.trim(),
      'angkatan': angkatanController.text.trim(),
    });
    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registrasi berhasil!")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registrasi gagal")),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
          prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.8)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFF6B73FF),
            ],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _slideAnimation.value),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Back Button
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Header
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                          border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                        ),
                        child: const Icon(
                          Icons.person_add,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Glass Card
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  const Text(
                                    'Create Account',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Daftar sebagai mahasiswa baru',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  
                                  _buildTextField(
                                    controller: namaController,
                                    label: 'Nama Lengkap',
                                    icon: Icons.person_outline,
                                    validator: (v) => (v == null || v.isEmpty) ? 'Nama tidak boleh kosong' : null,
                                  ),
                                  
                                  _buildTextField(
                                    controller: nimController,
                                    label: 'NIM',
                                    icon: Icons.badge_outlined,
                                    validator: (v) => (v == null || v.isEmpty) ? 'NIM tidak boleh kosong' : null,
                                  ),
                                  
                                  _buildTextField(
                                    controller: emailController,
                                    label: 'Email',
                                    icon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (v) => (v == null || !v.contains('@')) ? 'Email tidak valid' : null,
                                  ),
                                  
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                                    ),
                                    child: TextFormField(
                                      controller: passwordController,
                                      obscureText: _obscurePassword,
                                      style: const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                                        prefixIcon: Icon(Icons.lock_outline, color: Colors.white.withOpacity(0.8)),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                            color: Colors.white.withOpacity(0.8),
                                          ),
                                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.all(16),
                                      ),
                                      validator: (v) => (v == null || v.length < 6) ? 'Minimal 6 karakter' : null,
                                    ),
                                  ),
                                  
                                  _buildTextField(
                                    controller: fakultasController,
                                    label: 'Fakultas',
                                    icon: Icons.school_outlined,
                                    validator: (v) => (v == null || v.isEmpty) ? 'Fakultas tidak boleh kosong' : null,
                                  ),
                                  
                                  _buildTextField(
                                    controller: prodiController,
                                    label: 'Program Studi',
                                    icon: Icons.book_outlined,
                                    validator: (v) => (v == null || v.isEmpty) ? 'Program Studi tidak boleh kosong' : null,
                                  ),
                                  
                                  _buildTextField(
                                    controller: angkatanController,
                                    label: 'Angkatan',
                                    icon: Icons.calendar_today_outlined,
                                    keyboardType: TextInputType.number,
                                    validator: (v) => (v == null || v.isEmpty) ? 'Angkatan tidak boleh kosong' : null,
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  
                                  // Register Button
                                  Container(
                                    width: double.infinity,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                      ),
                                      onPressed: _isLoading
                                          ? null
                                          : () {
                                              if (_formKey.currentState?.validate() ?? false) {
                                                registerMahasiswa();
                                              }
                                            },
                                      child: _isLoading
                                          ? const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const Text(
                                              'Daftar Sekarang',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  
                                  // Login Link
                                  TextButton(
                                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'Sudah punya akun? ',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 16,
                                        ),
                                        children: const [
                                          TextSpan(
                                            text: 'Masuk di sini',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}