import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../config/theme/theme.dart';
import '../utils/common_func.dart';
import 'custom_button.dart';

class ImagePickerButton extends StatelessWidget {
  const ImagePickerButton({
    super.key,
    this.onImageSelected,
    this.icon,
    this.size = 24,
    this.imageQuality = 50,
  });

  final Function(File)? onImageSelected;
  final IconData? icon;
  final double size;
  final int imageQuality;

  Future<PermissionStatus> _requestGalleryPermission() async {
    if (Platform.isAndroid) {
      // Check Android version
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        // Android 12 (API 32) or lower
        return await Permission.storage.request();
      }
      // Android 13 and above
      return await Permission.photos.request();
    }

    // For iOS
    return await Permission.photos.request();
  }

  Future<void> _handleImageSelection(BuildContext context) async {
    final result = await showModalBottomSheet<ImageSource?>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Nhập tự động từ hình thẻ chấm công',
                style: AppTheme.title(context),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Chụp hình'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Chọn hình từ thư viện'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (result == null) return;

    final permission =
        result == ImageSource.camera ? await Permission.camera.request() : await _requestGalleryPermission();

    if (!permission.isGranted) {
      if (context.mounted) {
        _showPermissionDeniedDialog(context);
      }
      return;
    }

    try {
      final image = await ImagePicker().pickImage(
        source: result,
        imageQuality: imageQuality,
      );

      if (image != null) {
        onImageSelected?.call(File(image.path));
      }
    } catch (e, s) {
      log(e, stacktrace: s);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lỗi chọn hình'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showPermissionDeniedDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quyền truy cập đã bị từ chối'),
        content: const Text(
          'Hãy cấp quyền lại trong cài đặt để sử dụng tính năng này',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text('Mở cài đặt'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomButton(
        color: Colors.green,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onPressed: () => _handleImageSelection(context),
        child: const Icon(
          Icons.auto_awesome,
          color: Colors.white,
        ),
      ),
    );
  }
}
