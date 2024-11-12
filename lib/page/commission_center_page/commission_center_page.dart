import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/common_ui/buttons/red_button.dart';
import 'package:jiayuan/page/commission_center_page/commission_center_vm.dart';
import 'package:provider/provider.dart';

import '../../common_ui/chart/indicator.dart';
import '../../common_ui/styles/app_colors.dart';

class CommissionCenterPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CommissionCenterState();
  }
}

class _CommissionCenterState extends State<CommissionCenterPage>{

  CommissionCenterViewModel _centerViewModel = CommissionCenterViewModel();

  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    
  }

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
                    height: 300.h,
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

                      SliverToBoxAdapter(
                        child: _MonthData()
                      )
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
                  buttonWidth: 90.w,
                  type: AppButtonType.main,
                  buttonText: "修改信息>",
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
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: (){},
        splashColor: Colors.grey[300],
        highlightColor: Theme.of(context).primaryColor.withAlpha(30),
        borderRadius: BorderRadius.circular(16),
        child: Container(
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
        ),
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
                _TitleIcon(Icons.account_circle, "认证信息"),
                _TitleIcon(Icons.history, "浏览记录"),
                _TitleIcon(Icons.menu_book, "我的证书"),
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

  Widget _MonthData(){
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
                  "本月数据",
                  style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.textColor2b,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      "本月接单(单)"
                    ),
                    Text(
                      "10",
                      style: TextStyle(
                          fontSize: 40.sp
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 1, // 分割线的宽度
                  height: 50, // 分割线的高度，可以根据需要调整
                  color: Colors.grey, // 分割线的颜色
                ),
                Column(
                  children: [
                    Text(
                        "本月收入(元)"
                    ),
                    Text(
                      "255.25",
                      style: TextStyle(
                          fontSize: 40.sp
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              height: 180,
              width: double.infinity,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  sections: _buildPieChartSections(),
                  centerSpaceRadius: 40, // 中间空白区域的半径
                  sectionsSpace: 2, // 扇区之间的间距
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Indicator(
                  color: Colors.blue,
                  text: '居家保洁',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Colors.orange,
                  text: '收纳整理',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Colors.green,
                  text: '专业养护',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Colors.red,
                  text: '家庭保健',
                  isSquare: true,
                ),
                SizedBox(
                  height: 18,
                ),
              ],
            ),
          ]
        ),
      )
    );
  }

  List<PieChartSectionData> _buildPieChartSections(){
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.orange,
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.green,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.red,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}