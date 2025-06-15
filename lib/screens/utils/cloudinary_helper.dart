import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryHelper {
  static const String cloudName = 'here put cloud name '; // Your cloud name
  static const String uploadPreset = 'ml_default'; // Make sure this is created in your Cloudinary dashboard

  static Future<String?> uploadImage(File imageFile) async {
    final uri = Uri.parse("put here cloudnary api key ");

    final request = http.MultipartRequest("POST", uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      final response = await request.send();
      final res = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['secure_url'];
      } else {
        print('Cloudinary upload error: ${res.body}');
        return null;
      }
    } catch (e) {
      print('Upload failed: $e');
      return null;
    }
  }
}
