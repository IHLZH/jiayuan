import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../common_ui/styles/app_colors.dart';
import 'comment_vm.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({super.key});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  CommentViewModel vm = CommentViewModel();

  @override
  void initState() {
    super.initState();
    vm.getComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor3,
      appBar: AppBar(
        title: Text("用户评价",
            style: TextStyle(color: Colors.black, fontSize: 20.sp)),
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor4,
      ),
      body: _keeperEvaluation(),
    );
  }

  Widget _keeperEvaluation() {
    return Container(
        margin:
            EdgeInsets.only(left: 15.w, right: 15.w, bottom: 60.h, top: 8.h),
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            // 清除默认内边距
            itemCount: vm.evaluations?.length,
            itemBuilder: (context, index) => Container(
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            clipBehavior: Clip.hardEdge,
                            child: Image.network(
                              vm.evaluations?[index].avatar ?? '',
                              width: 35,
                              height: 35,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Text(
                            '  ${vm.evaluations?[index].nickName}',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Row(
                                      children: List.generate(
                                          (vm.evaluations?[index].rating
                                                  ?.round() ??
                                              0),
                                          (index) => Icon(Icons.star_rounded,
                                              color: Colors.red, size: 18)),
                                    ),
                                    Spacer(),
                                    //评价日期
                                    Text(
                                      '${DateFormat('yyyy-MM-dd').format(vm.evaluations![index].time ?? DateTime.now())}',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text(
                                  '${vm.evaluations?[index].content}',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            GridView.builder(
                                padding: EdgeInsets.zero,
                                // 确保没有额外的内边距
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                    vm.evaluations?[index].images?.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        childAspectRatio: 1),
                                itemBuilder: (context, index1) => ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        width: 50.h,
                                        height: 50.h,
                                        vm.evaluations?[index]
                                                .images?[index1] ??
                                            '',
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                          ],
                        ),
                      )
                    ],
                  ),
                )));
  }
}
