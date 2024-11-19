import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';
import 'package:jiayuan/page/evaluation_page/evalutation_vm.dart';
import 'package:provider/provider.dart';

import '../../common_ui/MultiImageUpLoad/MultiImageUpLoad.dart';
import '../../route/route_utils.dart';

class EvalutationPage extends StatefulWidget {
  @override
  State<EvalutationPage> createState() => _EvalutationPageState();
}

class _EvalutationPageState extends State<EvalutationPage>
    with TickerProviderStateMixin {
  EvalutationViewModel _viewModel = EvalutationViewModel();

  late List<List<AnimationController>> _animatedControllers;
  late List<List<Animation<double>>> _animations;

  void _ImageChanged(List<XFile> images) {
    _viewModel.imageUrls = images;
  }

  @override
  void initState() {
    super.initState();
    _animatedControllers = List.generate(
        3,
        (row) => List.generate(5, (col) {
              return AnimationController(
                  vsync: this, duration: Duration(milliseconds: 100));
            }));

    _animations = _animatedControllers.map((rowControllers) {
      return rowControllers.map((controller) {
        return Tween(begin: 1.0, end: 1.2).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInOut));
      }).toList();
    }).toList();
  }

  @override
  void dispose() {
    for (var row in _animatedControllers) {
      for (var controller in row) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  void handleHitStar(int rowIndex, int starIndex) {
    _viewModel.updateRating(rowIndex, starIndex + 1);

    for (var controller in _animatedControllers[rowIndex]) {
      controller.reset();
      controller.removeStatusListener((status) {});
    }

    Future<void> animateStarsSequentially() async {
      for (int i = 0; i <= starIndex; i++) {
        if (!mounted) return;

        await _animatedControllers[rowIndex][i].forward();
        await _animatedControllers[rowIndex][i].reverse();
        Future.delayed(Duration(milliseconds: 100));
      }
    }

    animateStarsSequentially();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EvalutationViewModel>(
      create: (context) => _viewModel,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.grey[200],
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  AppColors.primaryColor,
                  Colors.white,
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  title: Text("评价"),
                  centerTitle: true,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () {
                      RouteUtils.pop(context);
                    },
                  ),
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    _TakeOrdersWidget(), //接单
                    Container(
                      color: Colors.white,
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        indent: 22,
                        endIndent: 22,
                      ),
                    ),
                    MultiImageUploadWidget(_ImageChanged), //图片上传
                    _ServiceEvaluationWidgetState(), //内容评价
                    //打分
                    _HitStartsWidget(),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _TakeOrdersWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.person, color: Colors.black, size: 24),
          SizedBox(width: 8),
          Text(
            "刘子恒",
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          Spacer(),
          Material(
            child: InkWell(
              onTap: () {
                print("点击了");
              },
              child: Icon(Icons.phone, color: Colors.black, size: 24),
            ),
          )
        ],
      ),
    );
  }

  Widget _ServiceEvaluationWidgetState() {
    return Selector<EvalutationViewModel, String?>(
        selector: (context, viewModel) => viewModel.evaluationContent,
        builder: (context, evaluationContent, child) {
          return Container(
            color: Colors.white,
            child: TextField(
              decoration: InputDecoration(
                hintText: "✎ 呼起键盘，添加小标签，写更有帮助性的评价吧",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(10),
              ),
              maxLines: 5,
              maxLength: 200,
              onChanged: (text) {
                _viewModel.updateEvaluationContent(text);
              },
            ),
          );
        });
  }

  Widget _HitStartsWidget() {
    return Selector<EvalutationViewModel, ({List<int> rating, bool isChanged})>(
        selector: (context, vm) => (rating: vm.rating, isChanged: vm.isChanged),
        builder: (context, data, child) {
          return Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    context.read<EvalutationViewModel>().updateIsChanged();
                  },
                  child: Row(
                    children: [
                      Text('本次服务打分'),
                      Spacer(),
                      Text('满意请给5星哦'),
                      data.isChanged
                          ? Icon(Icons.arrow_drop_down)
                          : Icon(Icons.arrow_drop_up)
                    ],
                  ),
                ),
                data.isChanged
                    ? Container()
                    : ListView.builder(
                        padding: EdgeInsets.all(0),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.rating.length,
                        itemBuilder: (context, rowIndex) {
                          return Container(
                            margin: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                switch (rowIndex) {
                                  0 => Text('服务质量'),
                                  1 => Text('服务态度'),
                                  2 => Text('服务满意度'),
                                  _ => Text('服务态度')
                                },
                                Spacer(),
                                Row(
                                  children: List.generate(5, (starIndex) {
                                    return GestureDetector(
                                      onTap: () {
                                        handleHitStar(rowIndex, starIndex);
                                      },
                                      child: AnimatedBuilder(
                                        animation:
                                            _animatedControllers[rowIndex]
                                                [starIndex],
                                        builder: (context, child) =>
                                            Transform.scale(
                                          // 使用 Transform.scale
                                          scale: _animations[rowIndex]
                                                  [starIndex]
                                              .value,
                                          child: Icon(
                                            Icons.star_rounded,
                                            color: starIndex <
                                                    data.rating[rowIndex]
                                                ? Colors.red
                                                : Colors.grey,
                                            size: 30, // 固定图标大小
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                )
                              ],
                            ),
                          );
                        },
                      ),
              ],
            ),
          );
        });
  }
}

void main() {
  runApp(MaterialApp(home: EvalutationPage()));
}
