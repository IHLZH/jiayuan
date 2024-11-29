import 'package:dio/dio.dart';


import '../../http/dio_instance.dart';
import '../../utils/global.dart';
import '../model/certificate.dart';


class CertificateApi {
    static CertificateApi instance = CertificateApi._();
    CertificateApi._();
    //证书保存
    Future<bool> saveCert(Certificate certificate) async {
      try {
        final Response response = await DioInstance.instance().post(
            path: "/keeper/certificate/save",
            data:certificate.toJson(),
            options: Options(headers: {"Authorization": Global.token}));
        if(response.data['code'] == 200){
          print('上传证书成功');
          return true ;
        }
        else {
          print('上传证书失败${response.data}');
        }
      } catch (e) {
        print("上传证书失败 网络请求异常" + e.toString());
      }
      return false;
    }

    //获取证书信息
    Future<List<Certificate>> getCertInfo() async {
      List<Certificate> certInfo = [];
      try {
        final Response response = await DioInstance.instance().post(
            path: "/keeper/certificate/list",
            options: Options(headers: {"Authorization": Global.token}));
        print('获取证书信息成功');
        if (response.data['code'] == 200){
          print("${response.data}");
          certInfo = response.data['data']
              .map<Certificate>((e) => Certificate.fromJson(e))
              .toList();
        }

        else {
          print('获取证书信息失败');
        }
      } catch (e) {
        print("获取证书信息失败 网络请求异常" + e.toString());
      }
      return certInfo;
    }

}
