import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Biodata Mahasiswa',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Use named initial route and animated onGenerateRoute for consistent transitions
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case '/register':
            page = const RegisterScreen();
            break;
          case '/profile':
            page = const ProfileScreen();
            break;
          case '/login':
          default:
            page = const LoginScreen();
            break;
        }

        return PageRouteBuilder(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 450),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final offsetTween = Tween(begin: const Offset(0, 0.25), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeOut));
            return SlideTransition(
              position: animation.drive(offsetTween),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
        );
      },
    );
  }
}
