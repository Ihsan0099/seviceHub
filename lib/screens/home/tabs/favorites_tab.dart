import 'package:flutter/material.dart';
import 'package:ihsantech/screens/service/service_details_screen.dart';
import 'package:ihsantech/screens/widgets/service_provider_card.dart';

class FavoritesTab extends StatefulWidget {
  const FavoritesTab({super.key});

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  final List<Map<String, dynamic>> _favoriteProviders = [
    {
      'name': 'Dr. Sarah Johnson',
      'profession': 'Dentist',
      'rating': 4.9,
      'reviews': 120,
      'distance': 2.5,
      'available': true,
    },
    {
      'name': 'Emma Thompson',
      'profession': 'House Cleaner',
      'rating': 4.8,
      'reviews': 95,
      'distance': 4.0,
      'available': true,
    },
    {
      'name': 'David Miller',
      'profession': 'Car Mechanic',
      'rating': 4.7,
      'reviews': 110,
      'distance': 7.8,
      'available': true,
    },
  ];

  void _removeFromFavorites(int index) {
    setState(() {
      _favoriteProviders.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Provider removed from favorites'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
      ),
      body: _favoriteProviders.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'No favorites yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add service providers to your favorites',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _favoriteProviders.length,
        itemBuilder: (context, index) {
          final provider = _favoriteProviders[index];
          return Dismissible(
            key: Key(provider['name']),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              color: Colors.red,
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            onDismissed: (direction) {
              _removeFromFavorites(index);
            },
            child: ServiceProviderCard(
              name: provider['name'],
              profession: provider['profession'],
              rating: provider['rating'],
              reviews: provider['reviews'],
              distance: provider['distance'],
              available: provider['available'],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceDetailsScreen(provider: provider,),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

