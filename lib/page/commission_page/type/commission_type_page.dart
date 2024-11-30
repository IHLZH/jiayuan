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
import 'package:jiayuan/repository/model/commission_data1.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../route/route_path.dart';
import '../../../route/route_utils.dart';
import '../../../utils/common_data.dart';
import '../../../utils/global.dart';
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


  @override
  void initState() {
    super.initState();
    _commissionTypeViewModel.isLoading = true;
    _commissionTypeViewModel.typeId = widget.id;
    _initData();
  }


  void dispose(){
    super.dispose();
  }

  Future<void> _initData() async {
    await _commissionTypeViewModel.initData();
    _commissionTypeViewModel.isLoading = false;
  }

  Future<void> _onLoading() async {
    await _commissionTypeViewModel.onLoading();
  }

  Future<void> _onRefresh() async {
    await _commissionTypeViewModel.onRefresh();
  }

  Future<void> _siftCommission() async {
    await _commissionTypeViewModel.siftCommission();
  }

  @override
  Widget build(BuildContext context) {
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
                            controller: vm.refreshController,
                            enablePullUp: true,
                            enablePullDown: true,
                            header: MaterialClassicHeader(
                              color: AppColors.appColor,
                              backgroundColor: AppColors.endColor,
                            ),
                            footer: ClassicFooter(
                              canLoadingText: "松开加载更多~",
                              loadingText: "努力加载中~",
                              noDataText: "已经到底了~",
                            ),
                            onLoading: _onLoading,
                            onRefresh: _onRefresh,
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
                                        CommonData.CommissionTypes[widget.id].typeText,
                                        style: TextStyle(
                                            color: AppColors.textColor2b,
                                          fontSize: 16.sp
                                        ),
                                      ),
                                      SizedBox(width: 5.w,),
                                      Text(
                                        (vm.commissionDataList.length > 999) ? "999+" : (vm.commissionDataList.length.toString()) + "个相关委托",
                                        style: TextStyle(
                                            color: AppColors.textColor2b,
                                            fontSize: 16.sp
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                vm.isLoading ? SliverToBoxAdapter(
                                  child: Center(
                                    heightFactor: 10.h,
                                    child: CircularProgressIndicator(
                                      backgroundColor: AppColors.appColor,
                                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.endColor),
                                    ),
                                  ),
                                ) : SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                            (context, index){
                                          return CommissionCard(vm.commissionDataList[index]);
                                        },
                                        childCount: vm.commissionDataList.length
                                    )
                                ),
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
                          Builder(builder: (context){
                            return AppButton(
                              onTap: (){
                                vm.distance = double.tryParse(_distanceController.text) ?? 99999.0;
                                double minPrice = double.tryParse(_minPriceController.text) ?? 0.0;
                                double maxPrice = double.tryParse(_maxPriceController.text) ?? 999999.99;
                                if(maxPrice >= minPrice){
                                  vm.maxPrice = maxPrice;
                                  vm.minPrice = minPrice;
                                  _siftCommission();
                                  Scaffold.of(context).closeEndDrawer();
                                }else{
                                  showToast("价格区间填写有误，请检查！");
                                }
                              },
                              type: AppButtonType.main,
                              buttonText: "确定",
                            );
                          }),
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

  Widget CommissionCard(CommissionData1 commission){
    return Container(
      padding: EdgeInsets.all(10),
      child: Material(
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
            height: 125.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      (commission.days ?? "今天") +
                          (commission.expectStartTime.hour.toString().length > 1 ? commission.expectStartTime.hour.toString() : ("0" + commission.expectStartTime.hour.toString())) +
                          ":" + (commission.expectStartTime.minute.toString().length > 1 ? commission.expectStartTime.minute.toString() : ("0" + commission.expectStartTime.minute.toString())),
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          commission.commissionBudget.toString(),
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
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600
                          ),
                        )
                      ],
                    )
                  ],
                ),

                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: AppColors.endColor,
                          borderRadius: BorderRadius.circular(16.r)
                      ),
                      child: Text(
                        commission.typeName,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    SizedBox(width: 5.w,),
                    Expanded(
                        child: Text(
                          "内容：" + (commission.commissionDescription ?? "家政员招募中~"),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis, // 超出部分用省略号表示
                          style: TextStyle(
                              color: AppColors.textColor2b,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500
                          ),
                        )
                    )
                  ],
                ),

                Row(
                  children: [
                    Icon(Icons.location_on_outlined),
                    Text(
                      commission.distance < 1
                          ? "${(commission.distance * 1000).round()}m"
                          : "${commission.distance.toStringAsFixed(1)}km",
                      style: TextStyle(
                          color: AppColors.textColor2b,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    SizedBox(width: 5.w,),
                    Text(
                      commission.county ?? "",
                      style: TextStyle(
                          color: AppColors.textColor2b,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    SizedBox(width: 5.w,),
                    Expanded(
                      child: Text(
                        commission.commissionAddress ?? "",
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
              ],
            ),
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
        CommonData.CommissionTypes[index].icon,
        size: 30,
        color: Colors.white,
      ),
    );
  }
}