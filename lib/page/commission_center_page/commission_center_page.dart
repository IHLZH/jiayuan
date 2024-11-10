import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/common_ui/buttons/red_button.dart';
import 'package:jiayuan/page/commission_center_page/commission_center_vm.dart';
import 'package:provider/provider.dart';

import '../../common_ui/styles/app_colors.dart';

class CommissionCenterPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CommissionCenterState();
  }
}

class _CommissionCenterState extends State<CommissionCenterPage>{

  CommissionCenterViewModel _centerViewModel = CommissionCenterViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return _centerViewModel;
      },
      child: Consumer<CommissionCenterViewModel>(
          builder: (context, vm, child){
            return Scaffold(
              body: Stack(
                children: [
                  Container(
                    height: 240.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.endColor, // 渐变起始颜色
                          Theme.of(context).colorScheme.background,      // 渐变结束颜色
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        backgroundColor: Colors.transparent,
                        pinned: true,
                        title: Text("委托中心"),
                        centerTitle: true,
                        actions: [
                          IconButton(
                              onPressed: (){},
                              icon: Icon(Icons.info_outline)
                          )
                        ],
                      ),

                      SliverToBoxAdapter(
                        child: _KeeperCard(),
                      ),

                      SliverToBoxAdapter(
                        child: _Orders(),
                      ),

                      SliverToBoxAdapter(
                        child: _MoreService(),
                      ),


                    ],
                  )
                ],
              ),
            );
          }
      ),
    );
  }

  Widget _KeeperCard(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white,width: 1),
          gradient: LinearGradient(
            colors: [
              AppColors.endColor, // 渐变起始颜色
              Colors.white38,      // 渐变结束颜色
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      child: ClipOval(
                        child: Image.network("https://i1.hdslb.com/bfs/face/ff445d09efe51be21b6d8170e746699899fb9c52.jpg@92w_92h.avif"),
                      )
                    ),
                    SizedBox(width: 5.w,),
                    Text(
                      "用户名",
                      style: TextStyle(
                          fontSize: 18.sp
                      ),
                    )
                  ],
                ),
                AppButton(
                  onTap: (){

                  },
                  buttonHeight: 25.h,
                  buttonWidth: 75.w,
                  type: AppButtonType.main,
                  buttonText: "去接单>",
                  radius: 32.r,
                  margin: EdgeInsets.symmetric(),
                )
              ],
            ),
            SizedBox(height: 10.h,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _Achievement("100", "完成单数"),
                  _Achievement("10", "工作经验"),
                  _Achievement("4.9", "综合评分"),
                ],
              ),
            )
          ],
        ),
      )
    );
  }

  Widget _Achievement(String num, String title){
    return Container(
      child: Column(
        children: [
          Text(
            num.toString(),
            style: TextStyle(
                fontSize: 20.sp
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp
            ),
          )
        ],
      ),
    );
  }

  Widget _Orders(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.endColor,width: 1)
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            SizedBox(height: 5.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "服务订单",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.textColor2b,
                    fontWeight: FontWeight.w600
                  ),
                ),
                Text(
                  "更多",
                  style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600
                  ),
                )
              ],
            ),
            SizedBox(height: 10.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _TitleIcon(Icons.access_time_rounded, "待服务"),
                _TitleIcon(Icons.hourglass_empty, "服务中"),
                _TitleIcon(Icons.monetization_on_outlined, "待支付"),
                _TitleIcon(Icons.download_done, "已完成"),
              ],
            ),
            SizedBox(height: 5.h,),
          ],
        ),
      ),
    );
  }

  Widget _TitleIcon(IconData icon, String title){
    return Container(
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: <Color>[AppColors.appColor, AppColors.endColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(bounds);
            },
            child: Icon(
                icon,
                size: 32,
                color: Colors.white
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp
            ),
          )
        ],
      ),
    );
  }

  Widget _MoreService(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.endColor)
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            SizedBox(height: 5,),
            Row(
              children: [
                Text(
                  "常用服务",
                  style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.textColor2b,
                      fontWeight: FontWeight.w600
                  ),
                )
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _TitleIcon(Icons.account_circle, "个人信息"),
                _TitleIcon(Icons.history, "浏览记录"),
                _TitleIcon(Icons.menu_book, "证书认证"),
                _TitleIcon(Icons.comment, "用户评论"),

              ],
            ),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _TitleIcon(Icons.money, "收益中心"),
                _TitleIcon(Icons.class_outlined, "家政培训"),
                _TitleIcon(Icons.help_outline, "常见问题"),
                _TitleIcon(Icons.more_horiz, "更多服务"),
              ],
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}