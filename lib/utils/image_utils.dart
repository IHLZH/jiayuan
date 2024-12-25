import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
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
  static Future<List<int>?> compressIfNeededToMemory(
      XFile file, double maxSizeMB) async {
    int fieldSize = await file.length();
    print('原始文件大小 ${fieldSize / ((1024 * 1024))}MB');
    // //获取图片原始分辨率
    // img.Image? decoder = img.decodeImage(await file.readAsBytes());
    // if (decoder == null) {
    //   throw Exception("无法解码图片");
    // }
    // int originalWidth = decoder.width;
    // int originalHeight = decoder.height;
    // //print('原始图片分辨率 $originalWidth x $originalHeight');
    // // 计算目标压缩尺寸，设定宽度为 1200px 或 1500px（根据需要进行调整）
    // int targetWidth = 1200;
    // // 或者根据分辨率比例动态计算图片高度
    // int targetHeight = (originalHeight * (targetWidth / originalWidth)).toInt();
    if (fieldSize > maxSizeMB * 1024 * 1024) {
      int maxQuality = 100; // 初始质量
      int minQuality = 0; // 最低质量阈值
      List<int>? compressedBytes;
      while (minQuality <= maxQuality) {
        int quality = minQuality + ((maxQuality - minQuality) ~/ 2);
        // print('尝试压缩，质量: $quality');
        try {
          compressedBytes = await FlutterImageCompress.compressWithFile(
            file.path,
            quality: quality,
            // minHeight: targetHeight,
            // minWidth: targetWidth,
          );
          if (compressedBytes == null) {
            throw Exception("压缩失败");
          }
          int compressedSize = compressedBytes.length;
          // print('压缩后文件大小: ${compressedSize / (1024 * 1024)} MB');
          // 判断压缩后的文件大小是否在目标大小附近10的范围，是则，不再压缩
          if ((compressedSize - maxSizeMB * 1024 * 1024).abs() <=
              maxSizeMB * 1024 * 1024 * 0.10) {
            print('压缩成功，压缩质量为$quality');
            print('压缩后文件大小: ${compressedSize / (1024 * 1024)} MB');
            return compressedBytes;
          }
          if (compressedSize > maxSizeMB * 1024 * 1024) {
            maxQuality = quality; //减小质量范围
          }
          if (compressedSize < maxSizeMB * 1024 * 1024) {
            minQuality = quality ; //增加质量范围
          }
          // 7%的阈值，就算成功  最多压缩五次
          if ((maxQuality - minQuality) <= 6) {
            print('压缩成功，压缩质量为$quality');
            print('压缩后文件大小: ${compressedSize / (1024 * 1024)} MB');
            return compressedBytes;
          }
        } catch (e) {
          showToast('压缩出错');
          return null;
        }
        ;
      }
    } else {
      return await file.readAsBytes();
    }
  }

  // 显示全屏图像的对话框方法
  void _showFullImageDialog(BuildContext context, String url) {
    showDialog(
      context: context,
      barrierDismissible: true, // 用户可以点击空白区域关闭对话框
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Hero(
                tag: 'avatar-userAvatar',
                child: Image(
                  image: CachedNetworkImageProvider(url),
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: IconButton(
                      highlightColor: Colors.black.withOpacity(0.2),
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
