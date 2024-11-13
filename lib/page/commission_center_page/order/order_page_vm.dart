import 'package:flutter/widgets.dart';
import 'package:jiayuan/repository/model/commission_data.dart';


class OrderPageViewModel with ChangeNotifier{

  //待服务
  List<Commission> unServed = [];
  //服务中
  List<Commission> inService = [];
  //待支付
  List<Commission> unPay = [];
  //已完成
  List<Commission> down = [];

  List<Commission> getStatusOrder(int id){
    switch(id){
      case 1:
        return unServed;
      case 2:
        return inService;
      case 3:
        return unPay;
      case 4:
        return down;
      default: return [];
    }
  }

  void getOrders(){
    unServed = [
      Commission(
          commissionType: 1,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学诚朴园三号楼204",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,2,12,30),
          estimatedTime: 2,
          commissionStatus: 1,
          isLong: false
      ),
      Commission(
          commissionType: 1,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学诚朴园三号楼204",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,3,12,30),
          estimatedTime: 2,
          commissionStatus: 1,
          isLong: false
      ),
      Commission(
          commissionType: 1,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学诚朴园三号楼204",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,4,12,30),
          estimatedTime: 2,
          commissionStatus: 1,
          isLong: false
      ),
    ];

    inService = [
      Commission(
        commissionType: 1,
        province: "河北省",
        city: "石家庄",
        county: "裕华区",
        address: "河北师范大学诚朴园三号楼204",
        userPhone: "19358756689",
        distance: 1.5,
        price: 255.25,
        expectTime: DateTime(2024,11,4,12,30),
        estimatedTime: 2,
        commissionStatus: 2,
        isLong: false
    ),
      Commission(
          commissionType: 1,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学诚朴园三号楼204",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,5,12,30),
          estimatedTime: 2,
          commissionStatus: 2,
          isLong: false
      ),];

    unPay = [
      Commission(
          commissionType: 1,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学诚朴园三号楼204",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,2,12,30),
          estimatedTime: 2,
          commissionStatus: 3,
          isLong: false
      ),
      Commission(
          commissionType: 1,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学诚朴园三号楼204",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,2,12,30),
          estimatedTime: 2,
          commissionStatus: 3,
          isLong: false
      ),
    ];

    down = [
      Commission(
          commissionType: 1,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学诚朴园三号楼204",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,3,12,30),
          estimatedTime: 2,
          commissionStatus: 4,
          isLong: false
      ),
      Commission(
          commissionType: 1,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学诚朴园三号楼204",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,4,12,30),
          estimatedTime: 2,
          commissionStatus: 4,
          isLong: false
      ),
    ];
  }

}