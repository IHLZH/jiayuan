import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/page/user_page/faq_page/faq_page_vm.dart';
import 'package:provider/provider.dart';

import '../../../common_ui/styles/app_colors.dart';
import '../../../route/route_utils.dart';
import '../../order_page/evaluation_page/evalutation_vm.dart';

class FeedBackPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context){
          return FaqViewModel();
        },
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor3,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(70, 219, 201, 1), // 渐变起始颜色
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
                      children: [
                        IconButton(
                            onPressed: (){
                              RouteUtils.pop(context);
                            },
                            icon: Icon(Icons.arrow_back_ios_new)
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          alignment: Alignment.center,
                          child: Text(
                            "意见反馈",
                            style: TextStyle(
                                color: AppColors.textColor2b,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              )
          ),
          body: Container(
            child: _ServiceEvaluationWidgetState(),
          ),
        ),
    );
  }

  Widget _ServiceEvaluationWidgetState() {
    return Selector<FaqViewModel, String?>(
        selector: (context, viewModel) => viewModel.evaluationContent,
        builder: (context, evaluationContent, child) {
          return Container(
            color: Colors.white,
            child: TextField(
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                hintText: "✎ 呼起键盘，添加小标签，写更有帮助性的评价吧",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(10),
              ),
              maxLines: 5,
              maxLength: 200,
              onChanged: (text) {

              },
            ),
          );
        });
  }
}

