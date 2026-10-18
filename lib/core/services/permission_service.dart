import 'package:permission_handler/permission_handler.dart';

enum AppPermissionResult { granted, denied, permanentlyDenied }

/// Wraps permission_handler so features don't depend on it directly.
class PermissionService {
  Future<AppPermissionResult> requestCamera() => _request(Permission.camera);

  /// Android step counting. (On iOS the system asks for Motion access
  /// itself the first time steps are read.)
  Future<AppPermissionResult> requestActivityRecognition() =>
      _request(Permission.activityRecognition);

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
