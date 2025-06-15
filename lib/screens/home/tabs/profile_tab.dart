import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../usersmodels/user_model.dart';
import 'user_profile_edit_screen.dart'; // Check if path/class is correct
import '../../ui/auth/auth_screen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late Future<UserModel?> _userData;

  @override
  void initState() {
    super.initState();
    _userData = _fetchUserData();
  }

  Future<UserModel?> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  Future<void> _refreshUserData() async {
    final newData = await _fetchUserData();
    setState(() {
      _userData = Future.value(newData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final currentUser = await _userData;
              if (currentUser == null) return;

              final updatedUser = await Navigator.push<UserModel>(
                context,
                MaterialPageRoute(
                  builder: (context) => UserEditProfileScreen(userModel: currentUser),
                ),
              );

              if (updatedUser != null) {
                setState(() {
                  _userData = Future.value(updatedUser);
                });
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<UserModel?>(
        future: _userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("User not found"));
          }

          final user = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: user.profileImageUrl != null
                              ? NetworkImage(user.profileImageUrl!)
                              : null,
                          child: user.profileImageUrl == null
                              ? const Icon(Icons.person, size: 60, color: Colors.black)
                              : null,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.name,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionTitle(context, 'Account Settings'),
                _buildSettingItem(context, Icons.person_outline, 'Personal Information', () {}),
                _buildSettingItem(context, Icons.location_on_outlined, 'Addresses', () {}),
                _buildSettingItem(context, Icons.payment_outlined, 'Payment Methods', () {}),
                _buildSettingItem(context, Icons.notifications_outlined, 'Notifications', () {}),
                const SizedBox(height: 16),
                _buildSectionTitle(context, 'Support'),
                _buildSettingItem(context, Icons.help_outline, 'Help Center', () {}),
                _buildSettingItem(context, Icons.info_outline, 'About Us', () {}),
                _buildSettingItem(context, Icons.privacy_tip_outlined, 'Privacy Policy', () {}),
                _buildSettingItem(context, Icons.description_outlined, 'Terms of Service', () {}),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const AuthScreen()),
                              (route) => false,
                        );
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'App Version 1.0.0',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
