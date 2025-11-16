import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/mahasiswa.dart';
import '../services/api_service.dart';

class AddEditMahasiswaScreen extends StatefulWidget {
  final Mahasiswa? mahasiswa;
  final bool isEdit;
  
  const AddEditMahasiswaScreen({
    Key? key, 
    this.mahasiswa,
    this.isEdit = false,
  }) : super(key: key);

  @override
  _AddEditMahasiswaScreenState createState() => _AddEditMahasiswaScreenState();
}

class _AddEditMahasiswaScreenState extends State<AddEditMahasiswaScreen> {
  final _formKey = GlobalKey<FormState>();
  final api = ApiService();
  bool _isLoading = false;
  
  late TextEditingController namaController;
  late TextEditingController nimController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController fakultasController;
  late TextEditingController prodiController;
  late TextEditingController angkatanController;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.mahasiswa?.nama ?? '');
    nimController = TextEditingController(text: widget.mahasiswa?.nim ?? '');
    emailController = TextEditingController(text: widget.mahasiswa?.email ?? '');
    passwordController = TextEditingController();
    fakultasController = TextEditingController(text: widget.mahasiswa?.fakultas ?? '');
    prodiController = TextEditingController(text: widget.mahasiswa?.prodi ?? '');
    angkatanController = TextEditingController(text: widget.mahasiswa?.angkatan ?? '');
  }

  @override
  void dispose() {
    namaController.dispose();
    nimController.dispose();
    emailController.dispose();
    passwordController.dispose();
    fakultasController.dispose();
    prodiController.dispose();
    angkatanController.dispose();
    super.dispose();
  }

  Future<void> _saveMahasiswa() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    final data = {
      'nama': namaController.text.trim(),
      'nim': nimController.text.trim(),
      'email': emailController.text.trim(),
      'fakultas': fakultasController.text.trim(),
      'prodi': prodiController.text.trim(),
      'angkatan': angkatanController.text.trim(),
    };

    if (!widget.isEdit && passwordController.text.isNotEmpty) {
      data['password'] = passwordController.text;
    }
    
    bool success;
    if (widget.isEdit) {
      success = await api.updateMahasiswa(widget.mahasiswa!.id, data);
    } else {
      success = await api.createMahasiswa(data);
    }
    
    setState(() => _isLoading = false);
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.isEdit ? 'Update' : 'Tambah'} mahasiswa berhasil!')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.isEdit ? 'Update' : 'Tambah'} mahasiswa gagal')),
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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    ),
                    Text(
                      widget.isEdit ? 'Edit Mahasiswa' : 'Tambah Mahasiswa',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Form
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF667eea),
                            Color(0xFF764ba2),
                          ],
                        ),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                          ),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(24),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  const SizedBox(height: 20),
                                  
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
                                  
                                  if (!widget.isEdit)
                                    _buildTextField(
                                      controller: passwordController,
                                      label: 'Password',
                                      icon: Icons.lock_outline,
                                      obscureText: true,
                                      validator: (v) => (v == null || v.length < 6) ? 'Minimal 6 karakter' : null,
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
                                  
                                  const SizedBox(height: 32),
                                  
                                  // Save Button
                                  Container(
                                    width: double.infinity,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Colors.white, Color(0xFFF0F0F0)],
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
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
                                      onPressed: _isLoading ? null : _saveMahasiswa,
                                      child: _isLoading
                                          ? const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                color: Color(0xFF667eea),
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : Text(
                                              widget.isEdit ? 'Update' : 'Simpan',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF667eea),
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}