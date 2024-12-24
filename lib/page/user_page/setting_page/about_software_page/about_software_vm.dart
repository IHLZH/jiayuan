import 'package:jiayuan/utils/constants.dart';

class AboutSoftwareVm {
  //软件版本
  static String? version = Constants.APP_VERSION;

  //软件版本描述
  static String? versionDesc;

  //开发人员
  static List<String>? developer = Constants.DEVELOPER_LIST;

  //是否是生产环境
  static bool? isProductionEnv = Constants.IS_Production;

  //仓库地址
  static String? repoUrl = Constants.REPO_URL;
}