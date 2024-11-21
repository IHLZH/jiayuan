import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiayuan/http/dio_instance.dart';

import '../../utils/global.dart';
import '../../utils/image_utils.dart';

class UploadImageApi {
  static UploadImageApi instance = UploadImageApi._();

  UploadImageApi._();

  //多图片上传
  Future<List<String>> uploadMultipleImages(List<XFile> files,String path) async {
    //显示加载动画
    EasyLoading.instance.maskColor = Colors.transparent;
    EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.cubeGrid;
    EasyLoading.show(
      status: "上传中...",
      maskType: EasyLoadingMaskType.custom,
    );
    //构建并发上传任务列表
    List<String> imageUrls = List.filled(files.length, "");
    bool isSuccess = false;
    List<Future> uploadTasks = files.map((file) async {
      isSuccess = false;
      //获取当前文件的索引
      int index = files.indexOf(file);
      //图片压缩处理
      List<int>? imageData = await ImageUtils.compressIfNeededToMemory(file, 5);
      //转化为字节流时必须要指定文件名  不然无法c
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromBytes(imageData!,
            filename: file.path.split('/').last),
      });
      try {
        Response response = await DioInstance.instance().post(
          path: path,
          queryParameters: {"userId": Global.userInfo!.userId},
          data: formData,
          options: Options(
              contentType: 'multipart/form-data',
              headers: {'token': Global.token}),
        );
        if (response.statusCode == 200) {
          // 将返回的图片地址赋值给对应的索引
           imageUrls[index] = response.data["data"];;
          isSuccess = true;
          print("上传成功: ${response.data}");
        } else {
          print("上传失败，状态码: ${response.statusCode}");
        }
      } catch (e) {
        print("上传出错: $e");
      }
    }).toList();
    await Future.wait(uploadTasks);
    if (isSuccess)
      EasyLoading.showSuccess('上传成功');
    else
      EasyLoading.showError('上传失败');
    EasyLoading.dismiss();
    return imageUrls;
  }

  //单图片上传
  Future<String> uploadImage(XFile file,String path) async {
    //显示加载动画
    EasyLoading.instance.maskColor = Colors.transparent;
    EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.cubeGrid;
    EasyLoading.show(
      status: "上传中...",
      maskType: EasyLoadingMaskType.custom,
    );
    String imageUrl = "";
    bool isSuccess = false;
    // 图片压缩处理
    List<int>? imageData = await ImageUtils.compressIfNeededToMemory(file, 5);
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromBytes(imageData!,
          filename: file.path.split('/').last),
    });

    try {
      // 发起 POST 请求上传文件
      Response response = await DioInstance.instance().post(
        path: path,
        queryParameters: {"userId": Global.userInfo!.userId},
        data: formData,
        options: Options(
            contentType: 'multipart/form-data',
            headers: {'token': Global.token}),
      );
      if (response.statusCode == 200) {
        imageUrl = response.data["data"];
        print("上传成功: ${response.data['message']}");
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
