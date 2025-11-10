import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;

import '../../../local_storage/domain/domain.dart'; // For image compression

class FileStorageManager {
  static const String requestFilesDir = 'request_files';
  
  // Get the directory for storing request files
  static Future<Directory> getRequestFilesDirectory() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final requestFilesDir = Directory(path.join(appDocDir.path, FileStorageManager.requestFilesDir));
    
    if (!await requestFilesDir.exists()) {
      await requestFilesDir.create(recursive: true);
    }
    
    return requestFilesDir;
  }

  // Save file and return RequestFile object
  static Future<RequestFile> saveFile({
    required File file,
    required String fieldName,
    String? customFileName,
    bool compressImage = true,
    int imageQuality = 80,
  }) async {
    final requestFilesDir = await getRequestFilesDirectory();
    final originalFileName = path.basename(file.path);
    final fileExtension = path.extension(originalFileName);
    final fileName = customFileName ?? '${DateTime.now().millisecondsSinceEpoch}$fileExtension';
    final newFilePath = path.join(requestFilesDir.path, fileName);
    
    File newFile;
    
    // Compress image if it's an image and compression is enabled
    if (compressImage && _isImageFile(originalFileName)) {
      newFile = await _compressImage(file, newFilePath, quality: imageQuality);
    } else {
      newFile = await file.copy(newFilePath);
    }
    
    // Get MIME type
    final mimeType = _getMimeType(originalFileName);
    
    return RequestFile(
      filePath: newFile.path,
      fieldName: fieldName,
      fileName: originalFileName,
      mimeType: mimeType,
    );
  }

  // Save image from bytes (useful for camera)
  static Future<RequestFile> saveImageFromBytes({
    required Uint8List bytes,
    required String fieldName,
    required String fileName,
    bool compressImage = true,
    int imageQuality = 80,
  }) async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File(path.join(tempDir.path, fileName));
    await tempFile.writeAsBytes(bytes);
    
    return saveFile(
      file: tempFile,
      fieldName: fieldName,
      customFileName: fileName,
      compressImage: compressImage,
      imageQuality: imageQuality,
    );
  }

  // Compress image
  static Future<File> _compressImage(File file, String outputPath, {int quality = 80}) async {
    try {
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      
      if (image == null) {
        return await file.copy(outputPath);
      }
      
      // Compress the image
      final compressedImage = img.encodeJpg(image, quality: quality);
      final compressedFile = File(outputPath);
      await compressedFile.writeAsBytes(compressedImage);
      
      return compressedFile;
    } catch (e) {
      // If compression fails, return original file
      print('Image compression failed: $e');
      return await file.copy(outputPath);
    }
  }

  // Check if file is an image
  static bool _isImageFile(String fileName) {
    final extension = path.extension(fileName).toLowerCase();
    return ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'].contains(extension);
  }

  // Get MIME type from file extension
  static String _getMimeType(String fileName) {
    final extension = path.extension(fileName).toLowerCase();
    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.bmp':
        return 'image/bmp';
      case '.webp':
        return 'image/webp';
      case '.pdf':
        return 'application/pdf';
      case '.txt':
        return 'text/plain';
      case '.json':
        return 'application/json';
      default:
        return 'application/octet-stream';
    }
  }

  // Delete file
  static Future<void> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error deleting file $filePath: $e');
    }
  }

  // Clean up old files (optional: call periodically)
  static Future<void> cleanupOldFiles({Duration maxAge = const Duration(days: 7)}) async {
    try {
      final requestFilesDir = await getRequestFilesDirectory();
      final files = requestFilesDir.listSync();
      final cutoffTime = DateTime.now().subtract(maxAge);
      
      for (final file in files) {
        if (file is File) {
          final stat = await file.stat();
          if (stat.modified.isBefore(cutoffTime)) {
            await file.delete();
          }
        }
      }
    } catch (e) {
      print('Error cleaning up old files: $e');
    }
  }

  // Get file size for a request
  static Future<int> getRequestTotalSize(List<RequestFile> files) async {
    int totalSize = 0;
    for (final file in files) {
      final fileObj = File(file.filePath);
      if (await fileObj.exists()) {
        totalSize += await fileObj.length();
      }
    }
    return totalSize;
  }
}