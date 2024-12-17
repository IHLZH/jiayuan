import 'package:flutter/cupertino.dart';

class FaqViewModel with ChangeNotifier{
  
  List<Faq> faqList = [
    Faq(question: "如何发布委托", answer: "点击“发委托”页面中服务类型下的图标，选择所需的家政服务类型，填写委托详情，例如服务时间、地点等信息，确认无误后提交即可发布委托。"),
    Faq(question: "如何联系家政员", answer: "在“发委托”页面，点击“探索家缘”区域，会根据您的需求推荐合适的家政员，您可以直接点击家政员头像进入聊天界面进行沟通。"),
    Faq(question: "如何分类查找委托", answer: "在“接委托”页面，点击上方的分类图标，例如清洁、搬家、维修等，根据分类筛选可用的委托任务，选择后可查看详细信息并接取。"),
    Faq(question: "如何添加好友", answer: "在聊天页面的右上角，点击“三个点”图标，选择“添加好友”功能，输入对方的用户名或扫描好友二维码，即可完成添加。"),
    Faq(question: "如何创建群聊", answer: "在“消息”界面，点击右上角的“群聊”按钮，选择群聊成员，设置群名称后即可创建群聊，方便多人沟通和协作。"),
    Faq(question: "如何接取委托", answer: "完成实名认证后，系统会授予家政员身份，您可以在“接委托”页面找到适合的任务，点击接取按钮后即可开始服务。"),
    Faq(question: "如何实名认证", answer: "进入“我的”页面，点击“家政员认证”，选择适合您的认证方式（如上传身份证照片或通过手机号验证），提交后等待审核即可完成认证。"),
    Faq(question: "如何修改密码", answer: "在“我的”页面中，点击“设置”，选择“修改密码”选项，输入当前密码后设置新密码，确认无误后提交即可完成修改。"),
    Faq(question: "如何绑定邮箱", answer: "进入“我的”页面的“设置”选项，选择“绑定邮箱”，输入您的邮箱地址并完成验证操作，成功后您的账号将与邮箱绑定。"),
    Faq(question: "如何使用AI客服", answer: "点击屏幕右侧的悬浮球，弹出快捷菜单后选择“客服”图标，AI客服会提供实时解答，包括使用问题和功能咨询，帮助您快速解决问题。"),
    Faq(question: "如何查看收入", answer: "进入“服务中心”页面，找到“收益中心”模块，点击进入后可查看详细收入数据，包括历史收入记录和结算明细，方便您随时掌握收益情况。"),
  ];
}

class Faq{
  String? question;
  String? answer;
  
 Faq({required String question, required String answer}){
   this.question = question;
   this.answer = answer;
 }
}