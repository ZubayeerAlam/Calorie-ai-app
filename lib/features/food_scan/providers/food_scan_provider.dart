import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/services/image_picker_service.dart';
import '../../../core/services/permission_service.dart';

enum ScanStatus { idle, picking, picked, permissionDenied, error }

class FoodScanProvider extends ChangeNotifier {
  FoodScanProvider(this._picker, this._permissions);

  final ImagePickerService _picker;
  final PermissionService _permissions;

  ScanStatus _status = ScanStatus.idle;
  XFile? _image;
  bool _permanentlyDenied = false;

  ScanStatus get status => _status;
  XFile? get image => _image;
  bool get permanentlyDenied => _permanentlyDenied;

  Future<void> captureFromCamera() async {
    final result = await _permissions.requestCamera();
    if (result != AppPermissionResult.granted) {
      _permanentlyDenied = result == AppPermissionResult.permanentlyDenied;
      _setStatus(ScanStatus.permissionDenied);
      return;
    }
    await _pick(_picker.pickFromCamera);
  }

  // Gallery uses the system photo picker, which needs no runtime permission.
  Future<void> pickFromGallery() => _pick(_picker.pickFromGallery);

  Future<void> openSettings() => _permissions.openSettings();

  void clear() {
    _image = null;
    _setStatus(ScanStatus.idle);
  }

  Future<void> _pick(Future<XFile?> Function() picker) async {
    _setStatus(ScanStatus.picking);
    try {
      final file = await picker();
      _image = file ?? _image;
      _setStatus(_image != null ? ScanStatus.picked : ScanStatus.idle);
    } catch (e) {
      debugPrint('Image pick failed: $e');
      _setStatus(ScanStatus.error);
    }
  }

  void _setStatus(ScanStatus status) {
    _status = status;
    notifyListeners();
  }
}
