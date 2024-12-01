import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:jiayuan/common_ui/%20autoHeightPageView/autoHeightPageView.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';
import 'package:jiayuan/route/route_path.dart';
import 'package:jiayuan/route/route_utils.dart';
import 'package:provider/provider.dart';

import '../../common_ui/banner/home_banner_widget.dart';
import 'keeper_vm.dart';

class Keeperpage extends StatefulWidget {
  final int keeperId;

  const Keeperpage({Key? key, required this.keeperId}) : super(key: key);

  @override
  State<Keeperpage> createState() => _KeeperpageState();
}

class _KeeperpageState extends State<Keeperpage>
    with SingleTickerProviderStateMixin {
  late final KeeperViewModel keeperViewModel;

  @override
  void initState() {
    super.initState();
    keeperViewModel = KeeperViewModel();
    keeperViewModel.getKeeperDataDetail(widget.keeperId);
    // 使用 addPostFrameCallback 确保在构建完成后执行异步操作
  }

  void dispose() {
    super.dispose();
  }

  bool isMeasureHeight = true;
  var _height;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => keeperViewModel,
      child: Consumer<KeeperViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: AppColors.appColor,
                elevation: 0,
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (vm.error != null) {
            return Scaffold(
              body: Center(child: Text('加载失败: ${vm.error}')),
            );
          }

          if (vm.keeperData == null) {
            return Scaffold(
              body: Center(child: Text('无数据')),
            );
          }

          return Scaffold(
            backgroundColor: Colors.grey.shade100,
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    child: AppBar(
                      centerTitle: true,
                      backgroundColor: AppColors.appColor,
                      elevation: 0,
                      actions: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  if (isMeasureHeight)
                    Offstage(
                      child: HeightMeasureWidget(
                          child: _keeperInfo(),
                          onHeightChanged: (height) {
                            _height = height;
                            // print("测量高度 ${_height} ");
                            setState(() {
                              isMeasureHeight = false;
                            });
                          }),
                      offstage: true,
                    ),
                  if (!isMeasureHeight)
                    Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: _keeperPersonInfo(),
                          ),
                          SliverToBoxAdapter(child: _keeperIntroduction()),
                          SliverToBoxAdapter(
                            child: _keeperEvaluation(),
                          )
                        ],
                      ),
                    )
                ],
              ),
            ),
            bottomSheet: Container(
              height: 60.h,
              color: Colors.white70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      height: 60.h,
                      child: ElevatedButton(
                        onPressed: () {
                          vm.addFavorite();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite_border,
                              color: vm.isFavorite ? Colors.red : Colors.black,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(vm.isFavorite ? '收藏成功' : '是否收藏')
                          ],
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(AppColors.appColor)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: Container(
                      height: 60.h,
                      child: ElevatedButton(
                        onPressed: () async {
                          final bool? isCancel = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                    content: Text('确定拨打电话吗？'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                          child: Text('取消')),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                          child: Text('确定'))
                                    ],
                                  ));
                          if (isCancel == true) {
                            try {
                              await keeperViewModel.makePhoneCall(
                                  keeperViewModel.keeperData!.contact!);
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              }
                            }
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text('电话咨询'),
                          ],
                        ),
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(5),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _keeperDecoration() {
    return Container(
      height: 420.h,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(15.0),
        gradient: LinearGradient(
          colors: [AppColors.appColor, AppColors.endColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _keeperPersonInfo() {
    _height = isMeasureHeight ? 680.h : _height;
    return Consumer<KeeperViewModel>(
        builder: (context, vm, child) => Container(
              height: _height + 280.h,
              child: Stack(
                children: [
                  BannerWidget(
                    dotType: BannerDotType.none,
                    bannerData: vm.keeperData?.keeperImages,
                    height: 280.h,
                  ),
                  Positioned(
                    top: 260.h, // 调整这个值来控制重叠程度
                    left: 0.w,
                    right: 0.w,
                    child: _keeperDecoration(),
                  ),
                  Positioned(
                    top: 280.h,
                    left: 0,
                    right: 0,
                    child: _keeperInfo(),
                  ),
                ],
              ),
            ));
  }

  Widget _keeperInfo() {
    return Container(
      margin: EdgeInsets.only(left: 12.w, right: 12.w),
      padding:
          EdgeInsets.only(left: 15.w, right: 15.w, top: 15.h, bottom: 15.h),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15.0.w)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            //切割圆形
            CircleAvatar(
                radius: 40,
                backgroundImage: keeperViewModel.keeperData?.avatar != null
                    ? NetworkImage(keeperViewModel.keeperData!.avatar ?? '')
                    : AssetImage(
                        'assets/images/drawkit-grape-pack-illustration-18.png')),
            Row(
              // 设置文本基线
              textBaseline: TextBaseline.alphabetic,
              // 设置文本对齐方式
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Text(
                  "   ${keeperViewModel.keeperData?.realName}",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  '   ${keeperViewModel.keeperData?.workExperience}年经验',
                  style: TextStyle(color: Colors.black, fontSize: 14.sp),
                )
              ],
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Divider(
          height: 1,
          indent: 15,
          endIndent: 15,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              ' ${keeperViewModel.keeperData?.city}',
              style: TextStyle(color: Colors.black, fontSize: 14.sp),
            ),
            Text(
              '     ${keeperViewModel.keeperData?.age}岁',
              style: TextStyle(color: Colors.black, fontSize: 14.sp),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(5.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.endColor),
          margin: EdgeInsets.only(left: 6.w, top: 7.h, bottom: 10.h),
          child: Text('工作内容'),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(' 标签: ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400)),
            Expanded(
              child: Text(' ${keeperViewModel.keeperData?.tags} ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400)),
            )
          ],
        ),
        SizedBox(
          height: 5,
        ),
        // ${keeperViewModel.keeperData?.tags}
        Text(
          ' 完成单数  ${keeperViewModel.keeperData?.completedOrders}',
          style: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400),
        ),
        Text(' 评分' '  ${keeperViewModel.keeperData?.rating}分',
            style: TextStyle(
                color: Colors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400)),
        Container(
          padding: EdgeInsets.all(5.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.endColor),
          margin: EdgeInsets.only(left: 6.w, top: 7.h, bottom: 10.h),
          child: Text('获取证书'),
        ),
        //照片
        Container(
          height: 100.h,
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(15.0.w)),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: keeperViewModel.keeperData?.certificates?.length,
            itemBuilder: (context, index) {
              return Container(
                width: 130.w,
                margin: EdgeInsets.only(right: 10.w),
                child: CachedNetworkImage(
                imageUrl:   keeperViewModel.keeperData?.certificates?[index] ?? '',
                  placeholder: (context, url) => CircularProgressIndicator(),
                  fit: BoxFit.fill,
                ),
              );
            },
          ),
        ),
      ]),
    );
  }

  Widget _keeperIntroduction() {
    return Container(
      margin: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 15.h, top: 15.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 33.h,
            width: 88.w,
            decoration: BoxDecoration(
              color: AppColors.endColor,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Center(
              child: Text(
                '关于TA     ',
                style: TextStyle(color: Colors.black, fontSize: 16.sp),
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(
                  left: 10.w, right: 15.w, top: 9.h, bottom: 15.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('自我介绍',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500)),
                  SizedBox(height: 10.h),
                  Text('${keeperViewModel.keeperData?.introduction}',
                      style: TextStyle(color: Colors.black, fontSize: 14.sp))
                ],
              ))
        ],
      ),
    );
  }

  Widget _keeperEvaluation() {
    return Container(
      margin: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 15.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 10.w, right: 15.w),
                decoration: BoxDecoration(
                  color: AppColors.endColor,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Text(
                  '顾客评价',
                  style: TextStyle(color: Colors.black, fontSize: 16.sp),
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  RouteUtils.pushForNamed(context, RoutePath.commentPage,arguments: keeperViewModel.keeperData?.keeperId);
                },
                child: Text(
                  '查看全部评价',
                  style: TextStyle(color: Colors.black, fontSize: 14.sp,),
                ),
              )
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          Divider(height: 1, indent: 18, endIndent: 18),
          Container(
              margin: EdgeInsets.only(
                  left: 10.w, right: 15.w, bottom: 60.h, top: 8.h),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  // 清除默认内边距
                  itemCount:
                      (keeperViewModel.keeperData?.evaluations?.isNotEmpty ??
                              false)
                          ? 1
                          : 0,
                  itemBuilder: (context, index) => Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                ClipOval(
                                  clipBehavior: Clip.hardEdge,
                                  child: Image.network(
                                    keeperViewModel.keeperData
                                            ?.evaluations?[index].avatar ??
                                        '',
                                    width: 35,
                                    height: 35,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Text(
                                  '   ${keeperViewModel.keeperData?.evaluations?[index].nickName}',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Row(
                                        children: List.generate(
                                            (keeperViewModel
                                                    .keeperData
                                                    ?.evaluations?[index]
                                                    ?.rating
                                                    ?.round() ??
                                                0),
                                            (index) => Icon(Icons.star,
                                                color: Colors.yellow,
                                                size: 15)),
                                      ),
                                      Spacer(),
                                      //评价日期
                                      Text(
                                          '${DateFormat('yyyy-MM-dd').format(keeperViewModel.keeperData?.evaluations?[index].time ?? DateTime.now())}'),
                                    ],
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    '${keeperViewModel.keeperData?.evaluations?[index].content}',
                                    style: TextStyle(color: Colors.black,fontSize: 15.sp),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              child: GridView.builder(
                                  padding: EdgeInsets.zero,
                                  // 确保没有额外的内边距
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: keeperViewModel.keeperData
                                      ?.evaluations?[index].images?.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                          childAspectRatio: 1),
                                  itemBuilder: (context, index1) => Container(
                                        child: Image.network(
                                          width: 50.h,
                                          height: 50.h,
                                          keeperViewModel
                                                  .keeperData
                                                  ?.evaluations?[index]
                                                  .images?[index1] ??
                                              '',
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                            ),
                            SizedBox(height: 10),
                            Divider(height: 1),
                          ],
                        ),
                      )))
        ],
      ),
    );
  }
}
