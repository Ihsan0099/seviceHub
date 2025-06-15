import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ihsantech/screens/service/service_details_screen.dart';

class ServiceTypeScreen extends StatelessWidget {
  final String category;

  const ServiceTypeScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // Debug print to check category received
    print('ServiceTypeScreen built with category: $category');

    return Scaffold(
      appBar: AppBar(
        title: Text('$category Providers'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('providers').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No providers found.'));
          }

          // Filter documents by serviceType matching category (case insensitive)
          final filteredProviders = snapshot.data!.docs.where((doc) {
            final data = doc.data()! as Map<String, dynamic>;
            final serviceType = data['serviceType'] ?? '';
            return serviceType.toString().toLowerCase() == category.toLowerCase();
          }).toList();

          if (filteredProviders.isEmpty) {
            return const Center(child: Text('No providers found.'));
          }

          return ListView.builder(
            itemCount: filteredProviders.length,
            itemBuilder: (context, index) {
              final provider = filteredProviders[index].data()! as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: provider['photoUrl'] != null && provider['photoUrl'].toString().isNotEmpty
                      ? CircleAvatar(
                    backgroundImage: NetworkImage(provider['photoUrl']),
                    radius: 28,
                  )
                      : const CircleAvatar(
                    child: Icon(Icons.business, size: 28),
                    radius: 28,
                  ),
                  title: Text(provider['businessName'] ?? 'Unknown'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Address: ${provider['address'] ?? 'N/A'}'),
                      Text('Phone: ${provider['phone'] ?? 'N/A'}'),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ServiceDetailsScreen(provider: provider)),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
