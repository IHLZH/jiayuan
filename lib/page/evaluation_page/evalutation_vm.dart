import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class EvalutationViewModel with ChangeNotifier{
  // 评价图片
  List<XFile>? imageUrls;
  //评论内容
  String? evaluationContent ;
  //总评分
  double? totalRating ;
  //评价时间
  DateTime? evaluationTime ;
  //三个评分
  List<int> rating = [5,5,5];

  bool isChanged = true;

  updateRating(int index,int value){
    rating[index] = value;
    notifyListeners();
  }

  updateEvaluationContent(String value){
    evaluationContent = value;
    notifyListeners();
  }


  updateIsChanged() {
    isChanged = !isChanged;
    notifyListeners();
  }
}