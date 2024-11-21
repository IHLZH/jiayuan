import 'package:flutter/material.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';
import 'package:jiayuan/page/commission_center_page/certificates/certificate_vm.dart';
import 'package:provider/provider.dart';

class CertificatePage extends StatefulWidget {
  const CertificatePage({super.key});

  @override
  State<CertificatePage> createState() => _CertificatePageState();
}

class _CertificatePageState extends State<CertificatePage> {
  CertificateVm certificateVm = CertificateVm();

  @override
  void initState() {
    super.initState();
    certificateVm.getCertificates();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => certificateVm,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            backgroundColor: AppColors.backgroundColor4,
            title: const Text(
              '行业证书',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            centerTitle: true,
          ),
          body: Consumer<CertificateVm>(
            builder: (context, certificateVm, child) {
              return ListView.builder(
                itemCount: certificateVm.certificates?.length,
                itemBuilder: (context, index) {
                  final certificate = certificateVm.certificates?[index];
                  return Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(certificate!.certificateName ?? '',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16)),
                            Spacer(),
                            switch (certificate.status) {
                              0 => Text(
                                  '待审核',
                                  style: TextStyle(color: Colors.red),
                                ),
                              1 => Text('已通过',
                                  style: TextStyle(color: Colors.red)),
                              2 => Text('未通过',
                                  style: TextStyle(color: Colors.red)),
                              _ => Text('已删除',
                                  style: TextStyle(color: Colors.red)),
                            }
                          ],
                        ),
                        const SizedBox(height: 10),
                        //图片
                        certificate.certificateUrl != null
                            ? Stack(
                                children: [
                                  Image.network(
                                    certificate.certificateUrl!,
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Image.asset(
                                        switch (certificate.status) {
                                          0 => 'assets/images/ToBeReviewed.png',
                                          1 => 'assets/images/reviewed.png',
                                          2 => 'assets/images/approved.png',
                                          _ => 'assets/images/delete.png'
                                        },
                                        color: Colors.red,
                                        width: 60,
                                        height: 60,
                                      ))
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
