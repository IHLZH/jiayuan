import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class ImageUtils {
  //获取本地图片 需要异步 对于return值 _pickedFile 的显示方法： FileImage(File(_pickedFile!.path))
  static Future<XFile?> getImage() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  //图片传输时转FromData
  static Future<FormData> toFromData(XFile image) async {
    return FormData.fromMap({"file": await MultipartFile.fromFile(image.path)});
  }
}
