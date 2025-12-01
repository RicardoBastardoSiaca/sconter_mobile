// local_image_service.dart
import 'dart:io';
import 'dart:typed_data';

// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'local_image_service.g.dart';

class LocalImageService {
  /// Get local file path for display
  static Future<String?> getLocalImagePath(String? filePath) async {
    if (filePath == null || filePath.isEmpty) return null;
    
    final file = File(filePath);
    if (await file.exists()) {
      return filePath;
    }
    return null;
  }

  /// Convert local file to Uint8List for Image.memory
  static Future<Uint8List?> getLocalImageBytes(String? filePath) async {
    if (filePath == null || filePath.isEmpty) return null;
    
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.readAsBytes();
      }
    } catch (e) {
      print('Error reading local image: $e');
    }
    return null;
  }

  /// Check if a file exists locally
  static Future<bool> isImageAvailableLocally(String? filePath) async {
    if (filePath == null || filePath.isEmpty) return false;
    return await File(filePath).exists();
  }
}