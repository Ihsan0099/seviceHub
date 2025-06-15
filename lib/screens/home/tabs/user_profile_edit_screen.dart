import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';


import '../../usersmodels/user_model.dart';

class UserEditProfileScreen extends StatefulWidget {
  final UserModel userModel;

  const UserEditProfileScreen({super.key, required this.userModel});

  @override
  State<UserEditProfileScreen> createState() => _UserEditProfileScreenState();
}

class _UserEditProfileScreenState extends State<UserEditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  File? _image;
  bool _isUploading = false;
  final picker = ImagePicker();
  String? _uploadedImageUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userModel.name);
    _emailController = TextEditingController(text: widget.userModel.email);
    _uploadedImageUrl = widget.userModel.profileImageUrl;
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
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
      }
    } catch (e) {
      print('Upload error: $e');
    }
    return null;
  }

  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isUploading = true);

    try {
      String? imageUrl = _uploadedImageUrl;

      if (_image != null) {
        final uploaded = await _uploadImageToCloudinary(_image!);
        if (uploaded != null) imageUrl = uploaded;
      }

      final updatedUser = UserModel(
        uid: user.uid,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        profileImageUrl: imageUrl,
        phoneNumber: widget.userModel.phoneNumber,
        isEmailVerified: user.emailVerified,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update(updatedUser.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated')),
      );

      Navigator.pop(context, updatedUser);
    } catch (e) {
      print('Save error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: _isUploading ? null : _saveProfile,
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 64,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : (_uploadedImageUrl != null && _uploadedImageUrl!.isNotEmpty
                        ? NetworkImage(_uploadedImageUrl!)
                        : const AssetImage('assets/images/placeholder.jpg')) as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: const Icon(Icons.edit, size: 16, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              readOnly: true,
            ),
            if (_isUploading)
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
