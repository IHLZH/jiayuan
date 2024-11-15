import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class EvalutationViewModel with ChangeNotifier{

  List<XFile>? imageUrls;

  String? evaluationContent ;

  List<int> rating = [5,5,5];

  bool isChanged = false;

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