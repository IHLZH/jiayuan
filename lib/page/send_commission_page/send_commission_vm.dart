import 'package:flutter/cupertino.dart';

class SendCommissionViewModel with ChangeNotifier{
  int? selectedDuration ;
  DateTime? selectedDate ;

  String? phoneNumber;

  bool checkCommisssion(){

    return false ;
  }

  void updateSelectedDuration(int duration){
    selectedDuration = duration;
    notifyListeners();
  }

  void updateSelectedDate(DateTime date){
    selectedDate = date;
    notifyListeners();
  }



}