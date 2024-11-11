import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/common_ui/app_bar/app_search_bar.dart';
import 'package:jiayuan/common_ui/dialog/dialog_factory.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';
import 'package:jiayuan/page/commission_page/search/commission_search_vm.dart';
import 'package:jiayuan/repository/model/commission_data.dart';
import 'package:jiayuan/repository/model/commission_data1.dart';
import 'package:jiayuan/route/route_utils.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common_ui/buttons/red_button.dart';
import '../../../common_ui/dialog/loading.dart';
import '../../../common_ui/input/app_input.dart';
import '../../../route/route_path.dart';
import '../commission_vm.dart';

class CommissionSearchPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CommissionSearchPageState();
  }
}

class _CommissionSearchPageState extends State<CommissionSearchPage> with SingleTickerProviderStateMixin{

  TextEditingController _searchController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();

  CommissionSearchViewModel _commissionSearchViewModel = CommissionSearchViewModel();
  //刷新控制器
  RefreshController _refreshController = RefreshController();

  late TabController _tabController;

  bool isSearch = false;

  bool? synthesisCheck; //选择综合排序
  bool? priceCheck; //选择价格排序
  bool? distanceCheck; //选择距离排序

  bool? priceHigh; //价格是否从高到低

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _getHisory();
  }

  Future<void> _getHisory() async {
    await _commissionSearchViewModel.getSearchHistory();
    setState(() {
    });
  }

  Future<void> _deleteHistory() async {
    await _commissionSearchViewModel.deleteSearchHistory();
    setState(() {
      _getHisory();
    });
  }

  Future<void> _search(String searchMessage) async {
    isSearch = true;
    synthesisCheck = true;
    priceCheck = false;
    distanceCheck = false;
    if(searchMessage != "")_commissionSearchViewModel.saveSearchHistory(searchMessage);
    Loading.showLoading();
    await _commissionSearchViewModel.getSearchCommission({
      "search":searchMessage,
      "page":1,
      "size":11
    });
    setState(() {
      Loading.dismissAll();
    });
  }

  void _back(){
    if(isSearch){
      isSearch = false;
      _getHisory();
      setState(() {
      });
    }else{
      RouteUtils.pop(context);
    }
  }

  //点击综合排序
  void _checkSynthesis(){
    if(synthesisCheck!)return;
    synthesisCheck = true;
    priceCheck = false;
    distanceCheck = false;

    //发起网络请求

    setState(() {
    });
  }

  void _checkPrice(){
    if(priceCheck!){
      priceHigh = !(priceHigh!);
    }else{
      priceCheck = true;
      priceHigh = false;
      synthesisCheck = false;
      distanceCheck = false;
    }

    //发起网络请求

    setState(() {
    });
  }

  void _checkDistance(){
    if(distanceCheck!)return;
    distanceCheck = true;
    priceCheck = false;
    synthesisCheck = false;

    //发起网络请求

    setState(() {
    });
  }

  @override
  void dispose() {
    Loading.dismissAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context){
        return _commissionSearchViewModel;
      },
      child: Consumer<CommissionSearchViewModel>(
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
                          height: 250.h,
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back_ios_new),
                                onPressed: () {
                                  _back();
                                },
                              ),
                              Expanded(
                                  child: AppSearchBar(
                                    controller: _searchController,
                                    showLeftMenu: false,
                                    searchType: SearchType.circle,
                                  )
                              ),
                              TextButton(
                                  onPressed: (){
                                    _search(_searchController.text);
                                  },
                                  child: Text(
                                    "搜索",
                                    style: TextStyle(
                                        color: AppColors.textColor2b,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600
                                    ),
                                  )
                              ),
                              SizedBox(
                                width: 10.w,
                              )
                            ],
                          ),
                        )
                    )
                ),
              body: SafeArea(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white
                      ),
                      child: isSearch ? _Result(vm) : _History(vm),
                    )
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
      )
    );
  }

  Widget _History(CommissionSearchViewModel vm){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "历史搜索",
                style: TextStyle(
                    color: AppColors.textColor2b,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: IconButton(
                  onPressed: (){
                    showDialog(
                        context: context,
                        builder: (context){
                          return AlertDialog(
                            title: Text("删除历史搜索"),
                            content: Text("确定要删除全部历史搜索吗？"),
                            actions: [
                              AppButton(
                                onTap: (){
                                  Navigator.of(context).pop();
                                },
                                type: AppButtonType.minor,
                                buttonText: "取消",
                                buttonTextStyle: TextStyle(
                                  color: AppColors.textColor2b
                                ),
                              ),
                              SizedBox(height: 5.h,),
                              AppButton(
                                onTap: (){
                                  _deleteHistory();
                                  Navigator.of(context).pop();
                                },
                                type: AppButtonType.main,
                                buttonText: "确定",
                              )
                            ],
                          );
                        }
                    );
                  },
                  icon: Icon(Icons.delete)
              )
            ),

          ],
        ),
        Row(
          children: [
            Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: _SearchHistory(vm.searchHistory),
                  ),
                )
            )
          ],
        )
      ],
    );
  }

  Widget _Result(CommissionSearchViewModel vm){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                onPressed: (){
                  _checkSynthesis();
                },
                child: Text(
                    "综合排序",
                  style: TextStyle(
                    color: synthesisCheck! ? AppColors.appColor : AppColors.textColor2b,
                    fontWeight: FontWeight.w500
                  ),
                )
            ),
            TextButton(
                onPressed: (){
                  _checkPrice();
                },
                child: Row(
                  children: [
                    Text(
                      "价格",
                      style: TextStyle(
                          color: priceCheck! ? AppColors.appColor : AppColors.textColor2b,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    Icon(
                      _getPriceIcon(),
                      color: priceCheck! ? AppColors.appColor : AppColors.textColor2b,
                    )
                  ],
                ),
            ),
            TextButton(
                onPressed: (){
                  _checkDistance();
                },
                child: Text(
                    "距离",
                  style: TextStyle(
                      color: distanceCheck! ? AppColors.appColor : AppColors.textColor2b,
                      fontWeight: FontWeight.w500
                  ),
                )
            ),
            Container(
              width: 1, // 设置分割线的宽度
              height: 45, // 设置分割线的高度
              color: Colors.black26, // 设置分割线的颜色
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Builder(
                  builder: (context) =>GestureDetector(
                    onTap: (){
                      Scaffold.of(context).openEndDrawer();
                    },
                    child: Row(
                      children: [
                        Text(
                            "筛选",
                            style: TextStyle(
                                color: AppColors.textColor2b
                            )
                        ),
                        Icon(Icons.filter_list)
                      ],
                    ),
                  ),
              ),
            )
          ],
        ),
        Expanded(
            child: _SearchResult()
        )
      ],
    );
  }

  IconData _getPriceIcon(){
    if(priceCheck!){
      return (priceHigh!) ? Icons.arrow_drop_down_outlined : Icons.arrow_drop_up_outlined;
    }
    return Icons.arrow_right;
  }

  Widget _SearchResult(){
    return SmartRefresher(
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
      child: ListView.builder(
        itemCount: _commissionSearchViewModel.searchCommissionList.length,
        itemBuilder: (context, index) {
          CommissionData1 commission = _commissionSearchViewModel.searchCommissionList[index];
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
                            (commission.days ?? "今天") + commission.expectStartTime!.hour.toString() + ":" + commission.expectStartTime!.minute.toString(),
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
                                    fontSize: 12.sp,
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
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.appColor, // 渐变起始颜色
                                    AppColors.endColor,      // 渐变结束颜色
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16.r)
                            ),
                            child: Text(
                              CommissionViewModel.CommissionTypes[commission.keeperId ?? 0].typeText,
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          Text(
                            "内容：" + (commission.commissionDescription ?? "家政员招募中~"),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis, // 超出部分用省略号表示
                            style: TextStyle(
                                color: AppColors.textColor2b,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500
                            ),
                          )
                        ],
                      ),

                      Row(
                        children: [
                          Icon(Icons.location_on_outlined),
                          Text(
                            commission.commissionId.toString() + "km",
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
        },
      ),
    );
  }


  List<Widget> _SearchHistory(List<String> searchHistory){
    List<String> reverseSearchHistory = searchHistory.reversed.toList();
    Set<String> searchHistorySet = Set();
    for (var value in reverseSearchHistory){
      searchHistorySet.add(value);
    }
    List<Widget> searchHistoryList = [];
    for (var value in searchHistorySet) {
      searchHistoryList.add(
        GestureDetector(
          onTap: (){
            _searchController.text = value;
            _search(value);
          },
          child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                value,
                style: TextStyle(
                    color: AppColors.textColor2b,
                    fontSize: 14.sp
                ),
              )
          ),
        )
      );
    }
    return searchHistoryList;
  }
}