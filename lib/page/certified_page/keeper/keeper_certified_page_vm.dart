import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class KeeperCertifiedPageViewModel with ChangeNotifier{

  XFile? idCardFront;

  XFile? idCardOther;

  XFile? selfAvatar;

  String name = "";
  String idCard = "";
  String phoneNumber = "";

}