class LocationData{
  String? latitude = ""; //纬度
  String? longitude = ""; //经度
  String? country = ""; // 国家
  String? province = ""; // 省份
  String? city = ""; // 市
  String? district = ""; // 区
  String? street = ""; // 街道
  String? adCode = ""; // 邮编
  String? address = ""; // 详细地址
  String? cityCode = ""; //区号

  LocationData({
    this.latitude,
    this.longitude,
    this.country,
    this.province,
    this.city,
    this.district,
    this.street,
    this.adCode,
    this.address,
    this.cityCode
  });
}