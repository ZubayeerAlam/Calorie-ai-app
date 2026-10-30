import 'package:cal_ai_app/core/services/image_picker_service.dart';
import 'package:image_picker/image_picker.dart';

/// Test double for the camera and gallery: returns a fixed photo path.
class FakeImagePicker extends ImagePickerService {
  FakeImagePicker({this.path = '/tmp/fake_meal.jpg'});

  final String path;

  @override
  Future<XFile?> pickFromCamera() async => XFile(path);

  @override
  Future<XFile?> pickFromGallery() async => XFile(path);
}
