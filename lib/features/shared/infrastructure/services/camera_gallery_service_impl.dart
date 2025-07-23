import 'package:image_picker/image_picker.dart';

import 'camera_gallery_service.dart';

final ImagePicker _picker = ImagePicker();

class CameraGalleryServiceImpl extends CameraGalleryService {
  // This class implements the CameraGalleryService interface.
  // It provides methods to take a photo and select a photo from the gallery.

  @override
  Future<String?> takePhoto() async {
    // Capture a photo.
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (photo == null) {
      return null;
    }
    print('Photo taken: ${photo.path}');
    // Return the path of the captured photo.
    return photo.path;
  }

  @override
  Future<String?> selectPhoto() async {
    // Implementation for selecting a photo from the gallery
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    if (photo == null) {
      return null;
    }
    print('Photo taken: ${photo.path}');
    // Return the path of the selected photo.
    return photo.path;
  }
}
