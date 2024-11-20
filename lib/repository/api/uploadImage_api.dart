import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiayuan/http/dio_instance.dart';

import '../../utils/global.dart';

class UploadImageApi {
  static UploadImageApi instance = UploadImageApi._();

  UploadImageApi._();

  Future<List<String>> uploadMultipleImages(List<XFile> files) async {
    //显示加载动画
    EasyLoading.instance.maskColor = Colors.transparent;
    EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.cubeGrid;
    EasyLoading.show(
      status: "上传中...",
      maskType: EasyLoadingMaskType.custom,
    );
    //构建并发上传任务列表
    List<String> filePaths = files.map((file) => file.path).toList();
    List<String> imageUrls = List.filled(filePaths.length, "");
    bool isSuccess = false;
    List<Future> uploadTasks = filePaths.map((filePath) async {
      //获取当前文件的索引
      int index = filePaths.indexOf(filePath);
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath),
      });
      try {
        Response response = await DioInstance.instance().post(
          path: "/test/upload",
          data: formData,
          options: Options(
              contentType: 'multipart/form-data',
              headers: {'token': Global.token}),
        );
        if (response.statusCode == 200) {
          // imageUrls[index] = response.data["message"];
          isSuccess = true;
          print("上传成功: ${response.data}");
        } else {
          print("上传失败，状态码: ${response.statusCode}");
        }
      } catch (e) {
        print("上传出错: $e");
      }
    }).toList();
    if (isSuccess)
      EasyLoading.showSuccess('上传成功');
    else
      EasyLoading.showError('上传失败');
    EasyLoading.dismiss();
    return imageUrls;
  }


  Future<String> uploadImage(XFile file) async {
    //显示加载动画
    EasyLoading.instance.maskColor = Colors.transparent;
    EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.cubeGrid;
    EasyLoading.show(
      status: "上传中...",
      maskType: EasyLoadingMaskType.custom,
    );
    String imageUrl = "";
    bool isSuccess = false;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path),
    });
    try {
      // 发起 POST 请求上传文件
      Response response = await DioInstance.instance().post(
        path: "/test/upload",
        data: formData,
        options: Options(
            contentType: 'multipart/form-data',
            headers: {'token': Global.token}),
      );
      if (response.statusCode == 200) {
        // imageUrl = response.data["message"];
        print("上传成功: ${response.data}");
        isSuccess = true;
      } else {
        print("上传失败，状态码: ${response.statusCode}");
      }
    } catch (e) {
      print("上传出错: $e");
    }
    if (isSuccess)
      EasyLoading.showSuccess('上传成功');
    else
      EasyLoading.showError('上传失败');
    return imageUrl;
  }
}
