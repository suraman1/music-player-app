import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  String? imagePath;
  final picker = ImagePicker();

  Future<void> loadProfile() async {
    final pref = await SharedPreferences.getInstance();
    imagePath = pref.getString('image_path');
    notifyListeners();
  }

  Future<void> pickImage() async {
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final pref = await SharedPreferences.getInstance();
    await pref.setString('image_path', image.path);
    imagePath = image.path;
    notifyListeners();
  }

  Future<void> removeProfile() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove('image_path');
    imagePath = null;
    notifyListeners();
  }
}
