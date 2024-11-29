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

  // 并发任务多图片上传
  Future<List<String>> uploadMultipleImages(List<XFile> files, String path,
      {required Map<String, dynamic>? queryParameters}) async {
    //显示加载动画
    EasyLoading.instance.maskColor = Colors.transparent;
    EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.cubeGrid;
    EasyLoading.show(
      status: "上传中...",
      maskType: EasyLoadingMaskType.custom,
    );
    //构建并发压缩任务列表
    List<String> imageUrls = List.filled(files.length, "");
    bool isSuccess = false;
    List<Future> uploadTasks = files.map((file) async {
      isSuccess = false;
      //获取当前文件的索引
      int index = files.indexOf(file);
      //图片压缩处理
      List<int>? imageData =
          await ImageUtils.compressIfNeededToMemory(file, 0.5);
      //转化为字节流时必须要指定文件名  不然无法c
      FormData formData = FormData.fromMap({
        "files": await MultipartFile.fromBytes(imageData!,
            filename: file.path.split('/').last),
      });

      try {
        Response response = await DioInstance.instance().post(
          path: path,
          queryParameters: queryParameters,
          data: formData,
          options: Options(
              contentType: 'multipart/form-data',
              headers: {'Authorization': Global.token}),
        );
        print('测试asdasdasdasdasdasdasd');
        if (response.statusCode == 200) {
          // 将返回的图片地址赋值给对应的索引
          print("上传成功: ${response.data}");
          isSuccess = true;
          imageUrls[index] = response.data["data"];
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

  //单任务多图片上传
  Future<List<String>> uploadMultipleImages2(List<XFile> files, String path,
      {required Map<String, dynamic>? queryParameters}) async {
    //显示加载动画
    EasyLoading.instance.maskColor = Colors.transparent;
    EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.cubeGrid;
    EasyLoading.show(
      status: "上传中...",
      maskType: EasyLoadingMaskType.custom,
    );
    //构建并发压缩上传任务列表
    List<String> imageUrls = List.filled(files.length, "");
    Map<int, MultipartFile> imageDataMap = {};
    bool isSuccess = false;
    List<Future> uploadTasks = files.map((file) async {
      isSuccess = false;
      //获取当前文件的索引
      int index = files.indexOf(file);
      //图片压缩处理
      List<int>? imageData =
          await ImageUtils.compressIfNeededToMemory(file, 0.5);
      imageDataMap[index] = await MultipartFile.fromBytes(imageData!,
          filename: files[index].path.split('/').last);
    }).toList();
    await Future.wait(uploadTasks);
    FormData formData = FormData();
    for (int i = 0; i < imageUrls.length; i++) {
      formData.files.add(MapEntry("files", imageDataMap[i]!));
    }
    try {
      Response response = await DioInstance.instance().post(
        path: path,
        queryParameters: queryParameters,
        data: formData,
        options: Options(
            contentType: 'multipart/form-data',
            headers: {'Authorization': Global.token}),
      );
      if (response.statusCode == 200) {
        // 将返回的图片地址赋值给对应的索引
        print("上传成功: ${response.data}");
        isSuccess = true;
        imageUrls = response.data["data"];
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
    EasyLoading.dismiss();
    return imageUrls;
  }

  //单图片上传
  Future<String> uploadImage(XFile file, String path) async {
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
    List<int>? imageData = await ImageUtils.compressIfNeededToMemory(file, 0.5);
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromBytes(imageData!,
          filename: file.path.split('/').last),
    });
    //把formData转化为图片存储到指定位置
    // 打印上传文件信息
    try {
      // 发起 POST 请求上传文件
      Response response = await DioInstance.instance().post(
        path: path,
        queryParameters: {"userId": Global.userInfo!.userId},
        data: formData,
        options: Options(
            contentType: 'multipart/form-data',
            headers: {'Authorization': Global.token}),
      );
      if (response.statusCode == 200) {
        imageUrl = response.data["data"];
        print("上传成功: ${response.data['message']}");
        // 保存token
        if (response.headers.map.containsKey('Authorization') &&
            response.headers["authorization"]!.isNotEmpty) {
          final List<String> token =
              response.headers["Authorization"] as List<String>;
          Global.token = token.first;
        }

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

  //delete 删除图片方式 post
  Future<void> deleteImage(String imageFileUrl, String path) async {
    try {
      Response response = await DioInstance.instance().post(
        path: path,
        queryParameters: {"fileName": imageFileUrl.substring(("http://62.234.165.111:8080/upload/pictures/keeper/work_photo/").length)},
        options: Options(headers: {'Authorization': Global.token}),
      );
      if (response.data['code'] == 200) {
        print("post删除成功: ${response.data['message']}");
      } else {
        print("删除失败，状态: ${response.data['data']}");
      }
    } catch (e) {
      print("删除出错: $e");
    }
  }

  //delete 删除图片  delete
  Future<void> deleteImage2(String imageFileUrl, String path) async {
    try {
      Response response = await DioInstance.instance().delete(
        path: path,
        queryParameters: {"url": imageFileUrl},
        options: Options(headers: {'Authorization': Global.token}),
      );
      if (response.data['code'] == 200) {
        print("删除成功: ${response.data['message']}");
      } else {
        print("删除失败，状态码: ${response.data['data']}");
      }
    } catch (e) {
      print("删除出错: $e");
    }
  }
}
