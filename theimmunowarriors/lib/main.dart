import 'package:flutter/material.dart';
import 'package:theimmunowarriors/screens/auth/auth_screen.dart';
import 'package:theimmunowarriors/screens/dashboard/dashboard_screen.dart';
import 'package:theimmunowarriors/screens/dashboard/holo_simulateur_combat.dart';

void main() {
  runApp(const ImmunoWarriorsApp());
}

class ImmunoWarriorsApp extends StatelessWidget {
  const ImmunoWarriorsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ImmunoWarriors',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF00FEC0),
          secondary: const Color(0xFF009EFD),
        ),
      ),
      home: const AuthWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isAuthenticated = false;

  void _handleLogin() {
    setState(() {
      _isAuthenticated = true;
    });
  }

  void _handleLogout() {
    setState(() {
      _isAuthenticated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isAuthenticated
        ? DashboardScreen(onLogout: _handleLogout)
        : AuthScreen(onLoginSuccess: _handleLogin);
  }
}