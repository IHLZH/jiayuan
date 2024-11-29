import 'package:flutter/cupertino.dart';

import '../../../repository/api/certificate_api.dart';
import '../../../repository/model/certificate.dart';

class CertificateVm with ChangeNotifier {
  List<Certificate> certificates = [];

  Future<void> getCertificates() async {
    certificates = await CertificateApi.instance.getCertInfo();
    certificates.addAll([
      Certificate(
        certName: "高级厨师证",
        imageUrl:
            "https://tse4-mm.cn.bing.net/th/id/OIP-C.-HYppYIUS3elNIfTOCpuiwHaFB?w=182&h=123&c=7&r=0&o=5&dpr=1.3&pid=1.7",
        status: 1,
      ),
      Certificate(
        certName: "月嫂证",
        imageUrl:
            "https://ts1.cn.mm.bing.net/th?id=OIP-C.DYMSXM9NbByEOFsL9Ah66wHaFZ&w=184&h=185&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2",
        status: 2,
      ),
      Certificate(
        certName: "育婴证",
        imageUrl:
            "https://ts1.cn.mm.bing.net/th?id=OIP-C.LOuBK5vtxaA7gtT3gccRhAHaEA&w=194&h=185&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2",
        status: 0,
      )
    ]);
    notifyListeners();
  }
}
