import 'package:flutter/material.dart';
import '../models/mahasiswa.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final api = ApiService();
  Mahasiswa? mahasiswa;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final data = await api.getProfile();
    setState(() {
      mahasiswa = data;
    });
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 450),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetTween = Tween(begin: const Offset(0.25, 0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOut));
        return SlideTransition(
          position: animation.drive(offsetTween),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Mahasiswa"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await api.logout();
              // use animated route
              Navigator.of(context).pushReplacement(_createRoute(const LoginScreen()));
            },
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: mahasiswa == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                key: const ValueKey('profile'),
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 36,
                              backgroundColor: Colors.purpleAccent,
                              child: Text(
                                (mahasiswa!.nama.isNotEmpty ? mahasiswa!.nama[0].toUpperCase() : '?'),
                                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(mahasiswa!.nama, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(mahasiswa!.email, style: const TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                        const Divider(height: 22),
                        const SizedBox(height: 6),
                        Text('NIM: ${mahasiswa!.nim}'),
                        const SizedBox(height: 6),
                        Text('Fakultas: ${mahasiswa!.fakultas}'),
                        const SizedBox(height: 6),
                        Text('Prodi: ${mahasiswa!.prodi}'),
                        const SizedBox(height: 6),
                        Text("Angkatan: ${mahasiswa!.angkatan}"),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.edit),
                                label: const Text('Edit Profil'),
                                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
