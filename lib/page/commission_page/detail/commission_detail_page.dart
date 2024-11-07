import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/common_ui/buttons/red_button.dart';
import 'package:jiayuan/page/commission_page/commission_vm.dart';
import 'package:jiayuan/page/commission_page/detail/commission_detail_vm.dart';
import 'package:jiayuan/repository/model/commission_data.dart';
import 'package:jiayuan/route/route_utils.dart';
import 'package:provider/provider.dart';

import '../../../common_ui/styles/app_colors.dart';

class CommissionDetailPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CommissionDetailPageState();
  }
}

class _CommissionDetailPageState extends State<CommissionDetailPage>{
  CommissionDetailViewModel _commissionDetailViewModel = CommissionDetailViewModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    _commissionDetailViewModel.commission = ModalRoute.of(context)?.settings.arguments as Commission;
    _commissionDetailViewModel.getUserById(0);

    return ChangeNotifierProvider(
        create: (context){
          return _commissionDetailViewModel;
        },
        child: Consumer<CommissionDetailViewModel>(
            builder: (context, vm, child){
              return Scaffold(
                resizeToAvoidBottomInset: false, // 禁止布局被键盘顶掉
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back_ios_new),
                                onPressed: () {
                                  RouteUtils.pop(context);
                                },
                              ),
                              Text(
                               "委托详情" ,
                                style: TextStyle(
                                    color: AppColors.textColor2b,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.share),
                                onPressed: () {

                                },
                              ),
                            ],
                          ),
                        )
                    )
                ),
                body: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 50.h,
                                width: 50.w,
                                child: CircleAvatar(
                                  radius: 25.r,
                                  child: Image.network(vm.user!.userAvatar),
                                ),
                              ),
                              Text(
                                vm.user?.nickName ?? "数据获取失败",
                                style: TextStyle(
                                    color: AppColors.textColor2b
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                vm.commission.price.toString(),
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
                          Text(
                            "委托类型:",
                            style: TextStyle(
                                color: AppColors.textColor2b,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                          SizedBox(width: 10.w,),
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
                              CommissionViewModel.CommissionTypes[vm.commission.commissionType].typeText,
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "委托时间:",
                            style: TextStyle(
                                color: AppColors.textColor2b,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                          SizedBox(width: 10.w,),
                          Text(
                            vm.commission.expectTime.toString(),
                            style: TextStyle(
                              color: AppColors.textColor2b,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "委托地址:",
                            style: TextStyle(
                                color: AppColors.textColor2b,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                          SizedBox(width: 10.w,),
                          Expanded(
                              child: Wrap(
                                children: [
                                  Text(
                                    (vm.commission.province + vm.commission.city + vm.commission.county + vm.commission.address),
                                    style: TextStyle(
                                      color: AppColors.textColor2b,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              )
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2), // 阴影颜色
                                offset: Offset(0, 2), // 阴影偏移量
                                blurRadius: 2, // 模糊半径
                                spreadRadius: 0.5, // 扩展半径
                              ),
                            ]
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "联系方式:",
                              style: TextStyle(
                                  color: AppColors.textColor2b,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                            Text(
                              vm.user?.userPhoneNumber ?? "数据获取失败",
                              style: TextStyle(
                                  color: AppColors.textColor2b,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                            IconButton(
                                onPressed: (){},
                                icon: Icon(Icons.phone)
                            )
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "委托备注:",
                                style: TextStyle(
                                    color: AppColors.textColor2b,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.w,),
                          Container(
                            width: 300.w,
                            height: 300.h,
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(color: Colors.black)
                            ),
                            child: Expanded(
                                child: Wrap(
                                  children: [
                                    Text(
                                      "这是一条备注~",
                                      style: TextStyle(
                                        color: AppColors.textColor2b,
                                        fontSize: 14.sp,
                                      ),
                                    )
                                  ],
                                )
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: Container(
                  height: 50.h,
                  width: double.infinity,
                  decoration:BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: AppButton(
                            type: AppButtonType.minor,
                            buttonText: "与ta联系",
                            buttonTextStyle: TextStyle(
                              color: AppColors.textColor2b
                            ),
                          )
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                          child: AppButton(
                            type: AppButtonType.main,
                            buttonText: "我想接",
                          )
                      ),
                    ],
                  )
                ),
              );
            }
        ),
    );
  }
}