import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
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
}
