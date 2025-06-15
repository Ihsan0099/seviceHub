import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../providermodels/providermodel.dart';

class EditProfileScreen extends StatefulWidget {
  final ProviderModel provider;

  const EditProfileScreen({super.key, required this.provider});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _serviceTypeController;
  late TextEditingController _businessNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;

  File? _image;
  String? _uploadedImageUrl;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    final provider = widget.provider;
    _fullNameController = TextEditingController(text: provider.fullName);
    _serviceTypeController = TextEditingController(text: provider.serviceType);
    _businessNameController = TextEditingController(text: provider.businessName);
    _phoneController = TextEditingController(text: provider.phone);
    _emailController = TextEditingController(text: provider.email);
    _addressController = TextEditingController(text: provider.address);
    _uploadedImageUrl = provider.photoUrl;
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No image selected")),
      );
    }
  }

  Future<String?> _uploadImageToCloudinary(File imageFile) async {
    const cloudName = 'ddpz21lvd';
    const uploadPreset = 'ml_default';

    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final data = json.decode(responseData.body);
        return data['secure_url'];
      } else {
        print('Cloudinary upload failed: ${response.statusCode}');
        print('Response: ${responseData.body}');
      }
    } catch (e) {
      print('Cloudinary upload error: $e');
    }

    return null;
  }

  Future<void> _saveChanges() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isUploading = true);

    try {
      String? imageUrl = _uploadedImageUrl;

      if (_image != null) {
        final uploadedUrl = await _uploadImageToCloudinary(_image!);
        if (uploadedUrl != null) {
          imageUrl = uploadedUrl;
        }
      }

      final updatedProvider = ProviderModel(
        fullName: _fullNameController.text,
        serviceType: _serviceTypeController.text,
        businessName: _businessNameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        photoUrl: imageUrl ?? '',
        address: _addressController.text,
      );

      await FirebaseFirestore.instance
          .collection('providers')
          .doc(user.uid)
          .update(updatedProvider.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );

      Navigator.pop(context, updatedProvider);
    } catch (e) {
      print("Save error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save profile: $e")),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _serviceTypeController.dispose();
    _businessNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: _isUploading ? null : _saveChanges,
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 64,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : (_uploadedImageUrl != null && _uploadedImageUrl!.isNotEmpty)
                        ? NetworkImage(_uploadedImageUrl!)
                        : const AssetImage('assets/images/placeholder.jpg')
                    as ImageProvider,
                  ),
                  InkWell(
                    onTap: _isUploading ? null : _pickImage,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: const Icon(Icons.edit, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _isUploading
                ? const Center(child: CircularProgressIndicator())
                : TextButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text("Change Picture"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _fullNameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: _serviceTypeController,
              decoration: const InputDecoration(labelText: 'Service Type'),
            ),
            TextField(
              controller: _businessNameController,
              decoration: const InputDecoration(labelText: 'Business Name'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
          ],
        ),
      ),
    );
  }
}
