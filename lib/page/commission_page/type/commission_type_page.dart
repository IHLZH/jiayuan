import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:jiayuan/common_ui/buttons/red_button.dart';
import 'package:jiayuan/common_ui/dialog/loading.dart';
import 'package:jiayuan/common_ui/input/app_input.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';
import 'package:jiayuan/page/commission_page/type/commission_type_vm.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../repository/model/commission_data.dart';
import '../../../route/route_path.dart';
import '../../../route/route_utils.dart';
import '../commission_vm.dart';

class CommissionTypePage extends StatefulWidget{

  final int id;

  CommissionTypePage({super.key, required this.id});

  @override
  State<StatefulWidget> createState() {
    return _CommissionTypePageState();
  }
}

class _CommissionTypePageState extends State<CommissionTypePage>{

  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();

  CommissionTypeViewModel _commissionTypeViewModel = CommissionTypeViewModel();
  //刷新控制器
  RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    Loading.showLoading();
    _commissionTypeViewModel.getCommissionByType(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((duration){
      Loading.dismissAll();
    });
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return _commissionTypeViewModel;
      },
      child: Consumer<CommissionTypeViewModel>(
          builder: (context, vm, child){
            return Scaffold(
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(kToolbarHeight),
                  child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.appColor, // 渐变起始颜色
                            Colors.white,      // 渐变结束颜色
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.sp),
                        height: 250.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back_ios_new),
                              onPressed: () {
                                RouteUtils.pop(context);
                              },
                            ),
                            Container(
                              alignment: Alignment.center,
                                child: Text(
                                  "接委托",
                                  style: TextStyle(
                                      color: AppColors.textColor2b,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                            ),
                            Builder(
                                builder: (context) =>GestureDetector(
                                  onTap: (){
                                    Scaffold.of(context).openEndDrawer();
                                  },
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Text(
                                          "筛选",
                                          style: TextStyle(
                                              color: AppColors.textColor2b
                                          ),
                                        ),
                                        Icon(Icons.filter_list),
                                      ],
                                    ),
                                  ),
                                )
                            ),
                          ],
                        ),
                      )
                  )
              ),
              body: SafeArea(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Expanded(
                          child: SmartRefresher(
                            controller: _refreshController,
                            enablePullUp: true,
                            enablePullDown: true,
                            header: ClassicHeader(),
                            footer: ClassicFooter(),
                            onLoading: (){
                              print("loading...");
                            },
                            onRefresh: (){
                              print("refresh...");
                            },
                            child: CustomScrollView(
                              slivers: [
                                SliverToBoxAdapter(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(top: 10.h, left: 10.h),
                                        child: CTypeIcon(index: widget.id),
                                      ),
                                      SizedBox(width: 5.w,),
                                      Text(
                                        CommissionViewModel.CommissionTypes[widget.id].typeText,
                                        style: TextStyle(
                                            color: AppColors.textColor2b
                                        ),
                                      ),
                                      SizedBox(width: 5.w,),
                                      Text(
                                        (vm.commissionList.length > 999) ? "999+" : (vm.commissionList.length.toString()) + "个相关委托",
                                        style: TextStyle(
                                            color: AppColors.textColor2b
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                SliverToBoxAdapter(
                                  child: MasonryGridView.count(
                                    crossAxisCount: 2,
                                    itemCount: vm.commissionList.length,
                                    itemBuilder: (context, index){
                                      return Container(
                                        height: (index % 2 == 0) ? 250.h : 300.h,
                                        padding: EdgeInsets.all(10),
                                        child: CommissionCard(vm.commissionList[index]),
                                      );
                                    },
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(), // 禁止内部滚动
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
              ),
              endDrawer: Drawer(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        children: [
                          Text(
                            "价格",
                            style: TextStyle(
                              color: AppColors.textColor2b,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: AppInput(
                                controller: _minPriceController,
                                hintText: "最低价格(元)",
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly, // 只允许数字输入
                                  LengthLimitingTextInputFormatter(6),   // 限制最大长度为6位
                                ],
                              )
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Text(
                              "-",
                              style: TextStyle(
                                color: AppColors.textColor2b,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                              child: AppInput(
                                controller: _maxPriceController,
                                hintText: "最高价格(元)",
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly, // 只允许数字输入
                                  LengthLimitingTextInputFormatter(6),   // 限制最大长度为6位
                                ],
                              )
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Divider(
                        color: Colors.grey,    // 线条颜色
                        height: 1,             // 整体高度，包括间距
                        thickness: 1,          // 线条粗细
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        children: [
                          Text(
                            "距离",
                            style: TextStyle(
                              color: AppColors.textColor2b,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: AppInput(
                                controller: _distanceController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly, // 只允许数字输入
                                  LengthLimitingTextInputFormatter(5),   // 限制最大长度为6位
                                ],
                              )
                          ),
                          Text(
                            "km以内",
                            style: TextStyle(
                              color: AppColors.textColor2b,
                              fontSize: 14.sp,
                            ),
                          )
                        ],
                      ),
                      Spacer(),
                      Column(
                        children: [
                          AppButton(
                            onTap: (){
                              _distanceController.clear();
                              _maxPriceController.clear();
                              _minPriceController.clear();
                            },
                            type: AppButtonType.minor,
                            buttonText: "重置",
                            buttonTextStyle: TextStyle(
                              color: AppColors.textColor2b
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          AppButton(
                            onTap: (){
                              vm.distance = double.tryParse(_distanceController.text) ?? 99999.0;
                              double minPrice = double.tryParse(_minPriceController.text) ?? 0.0;
                              double maxPrice = double.tryParse(_maxPriceController.text) ?? 999999.99;
                              if(maxPrice >= minPrice){
                                vm.maxPrice = maxPrice;
                                vm.minPrice = minPrice;
                              }else{
                                showToast("价格区间填写有误，请检查！");
                              }
                            },
                            type: AppButtonType.main,
                            buttonText: "确定",
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              endDrawerEnableOpenDragGesture: false,
            );
          }
      ),
    );
  }

  Widget CommissionCard(Commission commission){
    return Material(
      elevation: 5,
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: (){
          RouteUtils.pushForNamed(
              context,
              RoutePath.commissionDetail,
              arguments: commission
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (commission.days ?? "") + commission.expectTime.hour.toString() + ":" + commission.expectTime.minute.toString(),
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                      ),
                      Text(
                        commission.distance.toString() + "km",
                        style: TextStyle(
                            color: AppColors.textColor2b,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ],
                  ),

                ],),

              //SizedBox(height: 10.h,),

              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              AppColors.appColor, // 渐变起始颜色
                              AppColors.endColor,      // 渐变结束颜色
                            ],
                        ),
                        borderRadius: BorderRadius.circular(16.r)
                    ),
                    child: Text(
                      CommissionViewModel.CommissionTypes[commission.commissionType].typeText,
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  )
                ],
              ),

              //SizedBox(height: 10.h,),

              Row(
                children: [
                  Text(
                    commission.isLong ? "服务周期: " : "服务时长: ",
                    style: TextStyle(
                        color: AppColors.textColor2b,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  SizedBox(width: 5.w,),
                  Text(
                    commission.estimatedTime.toString() + (commission.isLong ? "月" : "小时"),
                    style: TextStyle(
                        color: AppColors.textColor2b,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ],
              ),

              //SizedBox(height: 10.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    commission.county,
                    style: TextStyle(
                        color: AppColors.textColor2b,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  SizedBox(width: 5.w,),
                  Expanded(
                    child: Text(
                      commission.address + "诚朴园三号楼204",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis, // 超出部分用省略号表示
                      style: TextStyle(
                          color: AppColors.textColor2b,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  )
                ],
              ),

              //SizedBox(height: 5.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    commission.price.toString(),
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  Text(
                    "元",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget CTypeIcon({
    required int index,
  }){
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
            colors: [
              AppColors.appColor, // 渐变起始颜色
              AppColors.endColor,      // 渐变结束颜色
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
        ),
      ),
      child: Icon(
        CommissionViewModel.CommissionTypes[index].icon,
        size: 30,
        color: Colors.white,
      ),
    );
  }
}