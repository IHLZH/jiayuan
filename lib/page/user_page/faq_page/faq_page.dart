
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/page/user_page/faq_page/faq_page_vm.dart';
import 'package:provider/provider.dart';

import '../../../common_ui/styles/app_colors.dart';
import '../../../route/route_path.dart';
import '../../../route/route_utils.dart';

class FaqPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context){
          return FaqViewModel();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            "常见问题",
                            style: TextStyle(
                                color: AppColors.textColor2b,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                        TextButton(
                            onPressed: (){
                              RouteUtils.pushForNamed(context, RoutePath.feedbackPage);
                            },
                            child: Text(
                              "反馈",
                              style: TextStyle(
                                  color: Colors.red
                              ),
                            )
                        )
                      ],
                    ),
                  )
              )
          ),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Consumer<FaqViewModel>(
                builder: (context, vm, child){
                  return ListView.builder(
                      itemCount: vm.faqList.length,
                      itemBuilder: (context, index){
                        return _faqItem(vm.faqList[index], index);
                      }
                  );
                }
            )
          ),
        )
    );
  }

  Widget _faqItem(Faq faq, int index){
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            children: [
              Wrap(
                children: [
                  Text(
                    "${index + 1}.${faq.question ?? ""}?",
                    style: TextStyle(
                        color: AppColors.textColor2b,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 5,),
          Wrap(
            children: [
              Text(
                "a: ${faq.answer ?? ""}",
                style: TextStyle(
                    color: AppColors.textColor7d,
                    fontSize: 14.sp,
                ),
              )
            ],
          ),
          SizedBox(height: 10,),
          Container(
            height: 1,
            color: AppColors.backgroundColor6,
          )
        ],
      ),
    );
  }
}