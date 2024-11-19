import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/common_ui/app_bar/app_search_bar.dart';
import 'package:jiayuan/common_ui/dialog/dialog_factory.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';
import 'package:jiayuan/page/commission_page/search/commission_search_vm.dart';
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


  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _commissionSearchViewModel.getHisory();
  }

  Future<void> _back() async {
    _reset();
    if(_commissionSearchViewModel.isSearch){
      _commissionSearchViewModel.isSearch = false;
      await _commissionSearchViewModel.getHisory();
      setState(() {
      });
    }else{
      RouteUtils.pop(context);
    }
  }

  Future<void> _search() async {
    if(_searchController.text != ""){
      Loading.showLoading();
      await _commissionSearchViewModel.search(_searchController.text);
      _commissionSearchViewModel.refreshList();
      Loading.dismissAll();
    }else{
      showToast("请输入搜索内容");
    }
  }

  Future<void> _siftCommission() async {
    await _commissionSearchViewModel.siftCommission();
  }

  Future<void> _backToHistory() async {
    _commissionSearchViewModel.isSearch = false;
    await _commissionSearchViewModel.getHisory();
    setState(() {
    });
  }

  void _reset(){
    _distanceController.clear();
    _maxPriceController.clear();
    _minPriceController.clear();
    _commissionSearchViewModel.distance = 9999;
    _commissionSearchViewModel.minPrice = 0.0;
    _commissionSearchViewModel.maxPrice = 999999;
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
                                    onChanged: (value){
                                      if(value.length == 0){
                                        _backToHistory();
                                      }
                                    },
                                    showLeftMenu: false,
                                    searchType: SearchType.circle,
                                  )
                              ),
                              TextButton(
                                  onPressed: (){
                                    _search();
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
                      child: vm.isSearch ? _Result(vm) : _History(vm),
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
                                _reset();
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
                            Builder(
                                builder: (context){
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
                                }
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
                                  vm.deleteHistory();
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
    return vm.searchCommissionList.isEmpty ? Center(
      child: Container(
        child: Column(
          children: [
            Image.asset(
              height: 200.h,
              width: 200.w,
              "assets/images/search_no_result.png",
            ),
            Text(
              "没有找到你想要的委托/(ㄒoㄒ)/~~",
              style: TextStyle(
                color: AppColors.appColor,
                fontSize: 16.sp
              ),
            )
          ],
        ),
      )
    ) : Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                onPressed: (){
                  vm.checkSynthesis();
                },
                child: Text(
                    "综合排序",
                  style: TextStyle(
                    color: vm.synthesisCheck! ? AppColors.appColor : AppColors.textColor2b,
                    fontWeight: FontWeight.w500
                  ),
                )
            ),
            TextButton(
                onPressed: (){
                  vm.checkPrice();
                },
                child: Row(
                  children: [
                    Text(
                      "价格",
                      style: TextStyle(
                          color: vm.priceCheck! ? AppColors.appColor : AppColors.textColor2b,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    Icon(
                      _getPriceIcon(),
                      color: vm.priceCheck! ? AppColors.appColor : AppColors.textColor2b,
                    )
                  ],
                ),
            ),
            TextButton(
                onPressed: (){
                  vm.checkDistance();
                },
                child: Text(
                    "距离",
                  style: TextStyle(
                      color: vm.distanceCheck! ? AppColors.appColor : AppColors.textColor2b,
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
    if(_commissionSearchViewModel.priceCheck!){
      return (_commissionSearchViewModel.priceHigh!) ? Icons.arrow_drop_down_outlined : Icons.arrow_drop_up_outlined;
    }
    return Icons.arrow_right;
  }

  Widget _SearchResult(){
    return SmartRefresher(
      controller: _commissionSearchViewModel.refreshController,
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
      onLoading: _commissionSearchViewModel.onLoading,
      onRefresh: _commissionSearchViewModel.onRefresh,
      child: _commissionSearchViewModel.isLoading ? Center(
        child: CircularProgressIndicator(
          backgroundColor: AppColors.appColor,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.endColor),
        ),
      ) : ListView.builder(
        controller: _commissionSearchViewModel.scrollController,
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
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.appColor, // 渐变起始颜色
                                    AppColors.endColor,      // 渐变结束颜色
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16.r)
                            ),
                            child: Text(
                              commission.typeName,
                              style: TextStyle(
                                  color: Colors.black45,
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
            _search();
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