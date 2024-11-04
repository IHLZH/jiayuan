import 'package:flutter/widgets.dart';
import 'package:jiayuan/repository/model/commission_data.dart';

class CommissionSearchViewModel with ChangeNotifier{

  List<String> searchHistory = [];

  List<Commission> searchResult = [];

  double? minPrice;
  double? maxPrice;
  double? distance;


  void getSearchHistory(){
    searchHistory = [
      "保姆","月嫂","日常保洁","修管道"
    ];
  }

  void searchCommission(String searchMessage){
    searchResult = [
      Commission(
          commissionType: 1,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,2,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
      Commission(
          commissionType: 1,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,3,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
      Commission(
          commissionType: 1,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,4,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
      Commission(
          commissionType: 1,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,5,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
      Commission(
          commissionType: 1,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,2,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
      Commission(
          commissionType: 1,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,2,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
      Commission(
          commissionType: 1,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,3,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
      Commission(
          commissionType: 1,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,4,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
      Commission(
          commissionType: 1,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,2,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
      Commission(
          commissionType: 1,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,3,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
      Commission(
          commissionType: 1,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,4,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
    ];
  }

}