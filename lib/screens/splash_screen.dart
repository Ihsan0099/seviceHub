import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ihsantech/screens/home/home_screen.dart';
import 'package:ihsantech/screens/home/provider_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_screen.dart';
import 'ui/auth/auth_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    await Future.delayed(const Duration(seconds: 2)); // splash delay

    final prefs = await SharedPreferences.getInstance();
    bool onboardingSeen = prefs.getBool('onboarding_seen') ?? false;

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String? role = await _getUserRole(user.uid);
      if (!mounted) return;

      if (role == 'user') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else if (role == 'provider') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProviderHomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AuthScreen()),
        );
      }
    } else {
      // User is not logged in
      if (onboardingSeen) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AuthScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      }
    }
  }
  Future<String?> _getUserRole(String uid) async {
    final usersDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (usersDoc.exists) {
      return 'user';
    }

    final providersDoc = await FirebaseFirestore.instance.collection('providers').doc(uid).get();
    if (providersDoc.exists) {
      return 'provider';
    }

    return null; // UID not found in either collection
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.handyman_outlined,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              'Service Finder',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Find trusted local services',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

