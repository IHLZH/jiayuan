import 'package:dio/dio.dart';
import 'package:jiayuan/repository/model/commission_data1.dart';

import '../../http/dio_instance.dart';

class Api{
  static Api instance = Api._();
  Api._();

  // //获取首页轮播图banner
  // Future<List<HomeBannerData>?> getBanner() async {
  //   Response response = await DioInstance.getInstance().get(path: "/banner/json");
  //   //将获取到的Json数据进行转换
  //   HomeBannerListData bannerData = HomeBannerListData.fromJson(response.data);
  //   return bannerData.bannerList;
  // }

  Future<List<CommissionData1>> getRecommendCommission(Map<String, dynamic>? param) async {
    List<CommissionData1> commissionList = [];

    try{
      Response response = await DioInstance.instance().get(
          path: "/search_by_distance",
          param: param
      );

      if(response.statusCode == 200){
        int total = response.data['total'];
        print("共请求到" + total.toString() + "条数据");
        for(int i = 0; i < total; i++){
          commissionList.add(CommissionData1.fromJson(response.data['data'][i]));
        }
      }
    }catch(e){
      print("error:" + e.toString());
    }

    return commissionList;
  }






}