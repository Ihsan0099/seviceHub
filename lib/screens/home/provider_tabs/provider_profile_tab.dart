import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../providermodels/providermodel.dart';
import '../../ui/auth/auth_screen.dart';
import 'edit_profile_screen.dart';

class ProviderProfileTab extends StatefulWidget {
  const ProviderProfileTab({super.key});

  @override
  State<ProviderProfileTab> createState() => _ProviderProfileTabState();
}

class _ProviderProfileTabState extends State<ProviderProfileTab> {
  late Future<ProviderModel?> _providerData;

  @override
  void initState() {
    super.initState();
    _providerData = _fetchProviderData();
  }

  Future<ProviderModel?> _fetchProviderData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final snapshot = await FirebaseFirestore.instance
        .collection('providers')
        .doc(user.uid)
        .get();

    if (snapshot.exists) {
      return ProviderModel.fromMap(snapshot.data()!);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final provider = await _providerData;
              if (provider == null) return;

              final updatedProvider = await Navigator.push<ProviderModel>(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(provider: provider),
                ),
              );

              if (updatedProvider != null) {
                setState(() {
                  _providerData = Future.value(updatedProvider);
                });
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<ProviderModel?>(
        future: _providerData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No data found."));
          }

          final provider = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                // Profile Header with Avatar
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: provider.photoUrl != null
                              ? NetworkImage(provider.photoUrl!)
                              : const AssetImage('assets/images/placeholder.jpg') as ImageProvider,
                          child: provider.photoUrl == null
                              ? const Icon(Icons.person, size: 50, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          provider.fullName,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          provider.serviceType,
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Business Info Section
                _buildSectionTitle(context, 'Business Information'),
                _buildInfoItem(context, Icons.business, 'Business Name', provider.businessName),
                _buildInfoItem(context, Icons.location_on, 'Address', provider.address),
                _buildInfoItem(context, Icons.phone, 'Phone', provider.phone),
                _buildInfoItem(context, Icons.email, 'Email', provider.email),

                const SizedBox(height: 16),

                // Account Settings Section
                _buildSectionTitle(context, 'Account Settings'),
                _buildSettingItem(context, Icons.person_outline, 'Personal Information', () {}),
                _buildSettingItem(context, Icons.event_available, 'Availability', () {}),
                _buildSettingItem(context, Icons.home_repair_service, 'Services', () {}),
                _buildSettingItem(context, Icons.payment, 'Payment Methods', () {}),
                _buildSettingItem(context, Icons.notifications, 'Notifications', () {}),

                const SizedBox(height: 16),

                // Support Section
                _buildSectionTitle(context, 'Support'),
                _buildSettingItem(context, Icons.help_outline, 'Help Center', () {}),
                _buildSettingItem(context, Icons.info_outline, 'About Us', () {}),
                _buildSettingItem(context, Icons.privacy_tip_outlined, 'Privacy Policy', () {}),
                _buildSettingItem(context, Icons.description_outlined, 'Terms of Service', () {}),

                const SizedBox(height: 16),

                // Logout Button
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

                // App Version
                Text(
                  'App Version 1.0.0',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
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

  Widget _buildInfoItem(
      BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}