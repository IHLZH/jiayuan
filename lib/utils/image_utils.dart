import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageUtils {
  // 请求相册权限
  Future<bool> requestGalleryPermission() async {
    PermissionStatus status = await Permission.photos.request();
    if (status.isGranted) {
      return true;
    } else {}
    return false;
  }

  //获取本地图片 需要异步 对于return值 _pickedFile 的显示方法： FileImage(File(_pickedFile!.path))
  static Future<XFile?> getImage() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  //获取相机拍摄图片
  static Future<XFile?> getCameraImage() async {
    return await ImagePicker().pickImage(source: ImageSource.camera);
  }

  //图片传输时转FromData
  static Future<FormData> toFromData(XFile image) async {
    return FormData.fromMap({"file": await MultipartFile.fromFile(image.path)});
  }

  //动态压缩图片 压缩到指定大小附近
  static Future<List<int>?> compressIfNeededToMemory(XFile file, double maxSizeMB) async {
    int fieldSize = await file.length();
     print('原始文件大小 ${fieldSize/((1024 * 1024))}MB');
    if (fieldSize > maxSizeMB * 1024 * 1024) {
      int quality = 95; // 初始质量
      int minQuality = 10; // 最低质量阈值
      List<int>? compressedBytes;
      while (quality >= minQuality) {
       // print('尝试压缩，质量: $quality');
        try {
          compressedBytes = await FlutterImageCompress.compressWithFile(
            file.path,
            quality: quality,
          );
          if (compressedBytes == null) {
            throw Exception("压缩失败");
          }
          int compressedSize = compressedBytes.length;
         // print('压缩后文件大小: ${compressedSize / (1024 * 1024)} MB');
          if (compressedSize <= maxSizeMB * 1024 * 1024) {
            print('压缩成功，压缩质量为$quality');
            print('压缩后文件大小: ${compressedSize / (1024 * 1024)} MB');
            return compressedBytes;
          }
          // 如果文件仍然过大，降低质量
          quality -= 5;
        } catch (e) {
          print('压缩出错: $e');
          return null;
        }                                                                                                                                                                                               ;
      }
    } else {
      return await file.readAsBytes();
    }
  }
}
