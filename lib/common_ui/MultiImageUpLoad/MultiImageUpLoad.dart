import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiayuan/repository/api/uploadImage_api.dart';

class MultiImageUploadWidget extends StatefulWidget {
  @override
  _MultiImageUploadWidgetState createState() => _MultiImageUploadWidgetState();

  //传入一个回调函数，通过回调函数来拿到服务器上传到的图片地址
  final Function(List<String> imageUrls) onImageSelected;

  MultiImageUploadWidget(this.onImageSelected);
}

class _MultiImageUploadWidgetState extends State<MultiImageUploadWidget> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _imageFiles = [];
  final List<String> _imageUrls = [];

  void initState() {
    super.initState();
  }

  //从相册选择图片
  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    // 确保总数不超过6张
    if (pickedFiles.length  > 0) {
      _imageUrls.addAll(await UploadImageApi.instance.uploadMultipleImages(
          pickedFiles.take(6 - _imageFiles.length).toList(),''));
      _imageFiles.addAll(pickedFiles.take(6 - _imageFiles.length));
      setState(() {

      });
    }
    widget.onImageSelected(_imageUrls);
  }

  void _removeImage(int index) {
    setState(() {
      // 删除选中的图片
      _imageFiles.removeAt(index);
    });
    // 调用回调函数将图片传递到父组件
    widget.onImageSelected(_imageUrls);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: GridView.builder(
            padding: EdgeInsets.only(top: 10),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _imageFiles.length <= 5 ? _imageFiles.length + 1 : 6,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              if (index == _imageFiles.length && index < 6) {
                return GestureDetector(
                    onTap: _pickImages,
                    child: DottedBorder(
                        borderType: BorderType.RRect,
                        dashPattern: const [5, 5],
                        //设置虚线之间的间隔和长度
                        color: Colors.grey,
                        radius: const Radius.circular(10),
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add),
                              _imageFiles.length >= 1
                                  ? Text(
                                "还可上传 ${6 - _imageFiles.length}张",
                                style: TextStyle(fontSize: 12),
                              )
                                  : Text("上传图片"),
                            ],
                          ),
                        )));
              } else {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(_imageFiles[index].path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: GestureDetector(
                        onTap: () => _removeImage(index),
                        child: Icon(Icons.close, size: 18, color: Colors.white),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
