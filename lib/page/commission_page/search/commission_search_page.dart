import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/common_ui/app_bar/app_search_bar.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';
import 'package:jiayuan/page/commission_page/search/commission_search_vm.dart';
import 'package:jiayuan/route/route_utils.dart';
import 'package:provider/provider.dart';

class CommissionSearchPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CommissionSearchPageState();
  }
}

class _CommissionSearchPageState extends State<CommissionSearchPage> with SingleTickerProviderStateMixin{

  TextEditingController _searchController = TextEditingController();

  CommissionSearchViewModel _commissionSearchViewModel = CommissionSearchViewModel();

  late TabController _tabController;

  bool isSearch = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _commissionSearchViewModel.getSearchHistory();
  }

  void _search(String searchMessage){
    isSearch = true;
    _commissionSearchViewModel.searchCommission(searchMessage);
    setState(() {});
  }

  void _back(){
    if(isSearch){
      isSearch = false;
      setState(() {
      });
    }else{
      RouteUtils.pop(context);
    }
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
                )
            );
          }
      )
    );
  }

  Widget _History(CommissionSearchViewModel vm){
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                "历史搜索",
                style: TextStyle(
                    color: AppColors.textColor2b,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600
                ),
              ),
            )
          ],
        ),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Wrap(
                spacing: 5,
                children: _SearchHistory(vm.searchHistory),
              ),
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
          children: [
            TextButton(
                onPressed: (){

                },
                child: Text("综合排序")
            ),
            TextButton(
                onPressed: (){

                },
                child: Text("价格")
            ),
            TextButton(
                onPressed: (){

                },
                child: Text("距离")
            ),
            Container(
              width: 1, // 设置分割线的宽度
              height: 45, // 设置分割线的高度
              color: Colors.black26, // 设置分割线的颜色
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
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
            )
          ],
        ),
        _SearchResult(0)
      ],
    );
  }

  Widget _SearchResult(int type){
    return ListView.builder(
      itemCount: _commissionSearchViewModel.searchResult.length,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(10),
          height: 100.h,
          child: Text("data"),
        );
      },
    );
  }


  List<Widget> _SearchHistory(List<String> searchHistory){
    List<Widget> searchHistoryList = [];
    for (var value in searchHistory) {
      searchHistoryList.add(
        Container(
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
        )
      );
    }
    return searchHistoryList;
  }
}