// file_storage_manager.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;
import 'package:http_parser/http_parser.dart';

import '../../../local_storage/local_storage.dart';


class FileStorageManager {
  static const String requestFilesDir = 'request_files';
  
  static Future<Directory> getRequestFilesDirectory() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final requestFilesDirectory = Directory(path.join(appDocDir.path, requestFilesDir));
    
    if (!await requestFilesDirectory.exists()) {
      await requestFilesDirectory.create(recursive: true);
    }
    
    return requestFilesDirectory;
  }

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
    
    if (compressImage && _isImageFile(originalFileName)) {
      newFile = await _compressImage(file, newFilePath, quality: imageQuality);
    } else {
      newFile = await file.copy(newFilePath);
    }
    
    final mimeType = _getMimeType(originalFileName);
    
    return RequestFile(
      filePath: newFile.path,
      fieldName: fieldName,
      fileName: originalFileName,
      mimeType: mimeType,
    );
  }

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

  static Future<File> _compressImage(File file, String outputPath, {int quality = 80}) async {
    try {
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      
      if (image == null) {
        return await file.copy(outputPath);
      }
      
      final compressedImage = img.encodeJpg(image, quality: quality);
      final compressedFile = File(outputPath);
      await compressedFile.writeAsBytes(compressedImage);
      
      return compressedFile;
    } catch (e) {
      print('Image compression failed: $e');
      return await file.copy(outputPath);
    }
  }

  static bool _isImageFile(String fileName) {
    final extension = path.extension(fileName).toLowerCase();
    return ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'].contains(extension);
  }

  static String _getMimeType(String fileName) {
    final extension = path.extension(fileName).toLowerCase();
    
    // Return proper MIME types with type/subtype format
    switch (extension) {
      case '.jpg':
        return 'image/jpeg';
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
      case '.mp4':
        return 'video/mp4';
      case '.mp3':
        return 'audio/mpeg';
      case '.doc':
        return 'application/msword';
      case '.docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case '.xls':
        return 'application/vnd.ms-excel';
      case '.xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      default:
        // Fallback to octet-stream for unknown types
        return 'application/octet-stream';
    }
  }

  // Add a method to safely parse MIME type
  static MediaType? safeParseMediaType(String mimeType) {
    try {
      return MediaType.parse(mimeType);
    } catch (e) {
      print('⚠️ Invalid MIME type "$mimeType", falling back to octet-stream. Error: $e');
      return MediaType('application', 'octet-stream');
    }
  }

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

  // New method to check available storage space
  static Future<int> getAvailableStorageSpace() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final stat = directory.statSync();
      // This is a simplified calculation - you might want to use a proper package
      // for accurate available space calculation
      return 1024 * 1024 * 100; // Return 100MB as a safe default
    } catch (e) {
      print('Error checking available space: $e');
      return 1024 * 1024 * 50; // Return 50MB as fallback
    }
  }

  // New method to validate file before queuing
  static Future<bool> validateFile(File file, {int maxSizeInMB = 10}) async {
    try {
      if (!await file.exists()) {
        return false;
      }
      
      final fileSize = await file.length();
      final maxSize = maxSizeInMB * 1024 * 1024;
      
      if (fileSize > maxSize) {
        print('File too large: ${fileSize / (1024 * 1024)}MB');
        return false;
      }
      
      return true;
    } catch (e) {
      print('Error validating file: $e');
      return false;
    }
  }
}