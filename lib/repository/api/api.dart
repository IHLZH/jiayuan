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


}