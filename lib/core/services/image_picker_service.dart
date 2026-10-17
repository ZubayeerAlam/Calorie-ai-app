import 'package:image_picker/image_picker.dart';

import '../constants/app_constants.dart';

/// Wraps image_picker so features don't depend on it directly.
class ImagePickerService {
  ImagePickerService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  Future<XFile?> pickFromCamera() => _picker.pickImage(
    source: ImageSource.camera,
    imageQuality: AppConstants.imageQuality,
  );

  Future<XFile?> pickFromGallery() => _picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: AppConstants.imageQuality,
  );
}
