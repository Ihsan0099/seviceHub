import 'package:flutter/material.dart';
import 'package:ihsantech/screens/widgets/service_provider_card.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _showFilters = false;

  // Filter options
  double _maxDistance = 10.0;
  double _minRating = 0.0;
  bool _onlyAvailable = false;
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Doctors',
    'Electricians',
    'Plumbers',
    'Drivers',
    'Cleaners',
    'Carpenters',
    'Painters',
    'Mechanics',
  ];

  final List<Map<String, dynamic>> _allProviders = [
    {
      'name': 'Dr. Aziz Ullah',
      'profession': 'Dentist',
      'rating': 4.9,
      'reviews': 120,
      'distance': 2.5,
      'available': true,
      'category': 'Doctors',
    },
    {
      'name': 'Dr. Atta Ullah',
      'profession': 'General Physician',
      'rating': 4.7,
      'reviews': 95,
      'distance': 3.8,
      'available': true,
      'category': 'Doctors',
    },
    {
      'name': 'Abdur rehman',
      'profession': 'Electrician',
      'rating': 4.7,
      'reviews': 85,
      'distance': 3.2,
      'available': true,
      'category': 'Electricians',
    },
    {
      'name': 'Muhammad Yasin',
      'profession': 'Plumber',
      'rating': 4.5,
      'reviews': 65,
      'distance': 1.8,
      'available': false,
      'category': 'Plumbers',
    },
    {
      'name': 'Asfandiyar khan',
      'profession': 'House Cleaner',
      'rating': 4.8,
      'reviews': 95,
      'distance': 4.0,
      'available': true,
      'category': 'Cleaners',
    },
    {
      'name': 'Malik Salman',
      'profession': 'Carpenter',
      'rating': 4.6,
      'reviews': 78,
      'distance': 5.5,
      'available': true,
      'category': 'Carpenters',
    },
    {
      'name': 'Munsif khan',
      'profession': 'Painter',
      'rating': 4.3,
      'reviews': 45,
      'distance': 6.2,
      'available': false,
      'category': 'Painters',
    },
    {
      'name': 'Sheer khan',
      'profession': 'Car Mechanic',
      'rating': 4.7,
      'reviews': 110,
      'distance': 7.8,
      'available': true,
      'category': 'Mechanics',
    },
  ];

  List<Map<String, dynamic>> get _filteredProviders {
    return _allProviders.where((provider) {
      // Apply search query filter
      if (_searchQuery.isNotEmpty) {
        final name = provider['name'].toString().toLowerCase();
        final profession = provider['profession'].toString().toLowerCase();
        final query = _searchQuery.toLowerCase();
        if (!name.contains(query) && !profession.contains(query)) {
          return false;
        }
      }

      // Apply category filter
      if (_selectedCategory != 'All' && provider['category'] != _selectedCategory) {
        return false;
      }

      // Apply distance filter
      if (provider['distance'] > _maxDistance) {
        return false;
      }

      // Apply rating filter
      if (provider['rating'] < _minRating) {
        return false;
      }

      // Apply availability filter
      if (_onlyAvailable && !provider['available']) {
        return false;
      }

      return true;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search for services...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.black),
          ),
          style: const TextStyle(color: Colors.white),
          autofocus: true,
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showFilters ? Icons.filter_list : Icons.filter_list_outlined,
            ),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_showFilters)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Category'),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isSelected = category == _selectedCategory;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              category,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Max Distance: '),
                      Text('${_maxDistance.toStringAsFixed(1)} km'),
                    ],
                  ),
                  Slider(
                    value: _maxDistance,
                    min: 1,
                    max: 20,
                    divisions: 19,
                    label: '${_maxDistance.toStringAsFixed(1)} km',
                    onChanged: (value) {
                      setState(() {
                        _maxDistance = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Min Rating: '),
                      Text(_minRating.toStringAsFixed(1)),
                    ],
                  ),
                  Slider(
                    value: _minRating,
                    min: 0,
                    max: 5,
                    divisions: 10,
                    label: _minRating.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() {
                        _minRating = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Checkbox(
                        value: _onlyAvailable,
                        onChanged: (value) {
                          setState(() {
                            _onlyAvailable = value ?? false;
                          });
                        },
                      ),
                      const Text('Show only available providers'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _maxDistance = 10.0;
                            _minRating = 0.0;
                            _onlyAvailable = false;
                            _selectedCategory = 'All';
                          });
                        },
                        child: const Text('Reset Filters'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showFilters = false;
                          });
                        },
                        child: const Text('Apply'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          Expanded(
            child: _filteredProviders.isEmpty
                ? const Center(
              child: Text(
                'No providers found',
                style: TextStyle(fontSize: 16),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredProviders.length,
              itemBuilder: (context, index) {
                final provider = _filteredProviders[index];
                return ServiceProviderCard(
                  name: provider['name'],
                  profession: provider['profession'],
                  rating: provider['rating'],
                  reviews: provider['reviews'],
                  distance: provider['distance'],
                  available: provider['available'],
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to service details
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

