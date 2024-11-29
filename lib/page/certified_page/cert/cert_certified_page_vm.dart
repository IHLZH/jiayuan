import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:jiayuan/http/url_path.dart';
import 'package:jiayuan/repository/api/uploadImage_api.dart';
import 'package:oktoast/oktoast.dart';

import '../../../repository/api/certificate_api.dart';
import '../../../repository/model/certificate.dart';

class CertCertifiedPageViewModel with ChangeNotifier {
  XFile? certImage;
  String? certName;
  List<Certificate> _certificateList = [];

  get certificates => _certificateList;

  Future<void> getAllCertificates() async {
    _certificateList = await CertificateApi.instance.getCertInfo();
    notifyListeners();
  }

  Future<void> addCertificate() async {
    if(_certificateList.length >= 5){
      showToast('最多上传5张证书');
      return;
    }
    List<String> imageUrls = await UploadImageApi.instance.uploadMultipleImages(
        [certImage!], UrlPath.uploadCertificate,
        queryParameters: {});
    //上传失败时
    if (imageUrls == []) {
    } else {
      Certificate certificate = Certificate(
        certName: certName,
        imageUrl: imageUrls[0].substring("http://62.234.165.111:8080/upload/pictures/certificate/".length),
        status: 0,
      );
      print('上传的图片url ${certificate.imageUrl}');
      bool isSuccess = await CertificateApi.instance.saveCert(certificate);
      // bool isSuccess = true;
      if (isSuccess) {
        certImage == null;
        certName == null;
        certificate.imageUrl = "http://62.234.165.111:8080/upload/pictures/certificate/" + certificate.imageUrl!;
        _certificateList.insert(0, certificate);
        print('上传成功');
      } else {
        showToast('提交审核时，上传失败');
      }
    }
    notifyListeners();
  }
}
