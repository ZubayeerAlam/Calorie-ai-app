import 'package:permission_handler/permission_handler.dart';

enum AppPermissionResult { granted, denied, permanentlyDenied }

/// Wraps permission_handler so features don't depend on it directly.
class PermissionService {
  Future<AppPermissionResult> requestCamera() => _request(Permission.camera);

  Future<bool> openSettings() => openAppSettings();

  Future<AppPermissionResult> _request(Permission permission) async {
    final status = await permission.request();
    if (status.isGranted || status.isLimited) {
      return AppPermissionResult.granted;
    }
    if (status.isPermanentlyDenied || status.isRestricted) {
      return AppPermissionResult.permanentlyDenied;
    }
    return AppPermissionResult.denied;
  }
}
