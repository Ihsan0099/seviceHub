import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class MapboxMapScreen extends StatefulWidget {
  const MapboxMapScreen({Key? key}) : super(key: key);

  @override
  State<MapboxMapScreen> createState() => _MapboxMapScreenState();
}

class _MapboxMapScreenState extends State<MapboxMapScreen> {
  final String mapboxToken =
      'pk.eyJ1IjoiYXR0YXVsbGFoMTMxNDAyNSIsImEiOiJjbTZidWdvbGswYmJxMmtzZGw2OGN3MDQ0In0.tGQ5FDy_IctoxWbEMIC6Vw';

  final PopupController _popupController = PopupController();
  final List<Marker> _markers = [];
  LatLng? _mapCenter;

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  Future<void> _loadMarkers() async {
    List<Marker> markers = [];
    LatLng? firstLocation;

    final providersSnapshot =
    await FirebaseFirestore.instance.collection('providers').get();

    for (var doc in providersSnapshot.docs) {
      final provider = doc.data();
      final address = Uri.encodeComponent(provider['location'] ?? '');
      if (address.isEmpty) continue;

      final url =
          'https://api.mapbox.com/geocoding/v5/mapbox.places/$address.json?access_token=$mapboxToken';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['features'] != null && data['features'].isNotEmpty) {
          final coords = data['features'][0]['center'];
          final latlng = LatLng(coords[1], coords[0]);

          if (firstLocation == null) firstLocation = latlng;

          markers.add(
            Marker(
              point: latlng,
              width: 40,
              height: 40,
              key: ValueKey(doc.id),
              child: GestureDetector(
                onTap: () {
                  _popupController.togglePopup(
                    Marker(
                      point: latlng,
                      key: ValueKey(doc.id),
                      width: 40,
                      height: 40,
                      child: const SizedBox(),
                    ),
                  );
                },
                child: const Icon(Icons.location_on, color: Colors.red, size: 30),
              ),
            ),
          );
        }
      }
    }

    setState(() {
      _mapCenter = firstLocation ?? const LatLng(34.0151, 71.5249); // Fallback: Peshawar
      _markers.addAll(markers);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_mapCenter == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Provider Locations")),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _mapCenter!,
          initialZoom: 10,
          onTap: (_, __) => _popupController.hideAllPopups(),
        ),
        children: [
          TileLayer(
            urlTemplate:
            'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/256/{z}/{x}/{y}@2x?access_token=$mapboxToken',
            additionalOptions: {
              'accessToken': mapboxToken,
              'id': 'mapbox/streets-v11',
            },
            userAgentPackageName: 'com.example.app',
          ),
          PopupMarkerLayer(
            options: PopupMarkerLayerOptions(
              markers: _markers,
              popupController: _popupController,
              popupDisplayOptions: PopupDisplayOptions(
                builder: (BuildContext context, Marker marker) {
                  final markerKey = marker.key;
                  String? id;
                  if (markerKey is ValueKey<String>) {
                    id = markerKey.value;
                  }

                  final providerRef = FirebaseFirestore.instance
                      .collection('providers')
                      .doc(id);

                  return FutureBuilder<DocumentSnapshot>(
                    future: providerRef.get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return const SizedBox();
                      }

                      final data = snapshot.data!.data() as Map<String, dynamic>;

                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.all(8),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          width: 250,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['name'] ?? 'Unnamed Provider',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('Location: ${data['location'] ?? 'N/A'}'),
                              Text('Phone: ${data['phone'] ?? 'N/A'}'),
                              Text('Email: ${data['email'] ?? 'N/A'}'),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
