import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';

class CustomKeyboard extends StatelessWidget {
  final TextEditingController priceController ;
  final TextEditingController tempPriceController ;
  final ValueChanged<String> onKeyboardTap;
  final VoidCallback onBackspace;
  final VoidCallback onConfirm;
  final VoidCallback onSwitchKeyboard;

  const CustomKeyboard({
    required this.priceController,
    required this.tempPriceController,
    required this.onKeyboardTap,
    required this.onBackspace,
    required this.onConfirm,
    required this.onSwitchKeyboard
  });

  @override
  Widget build(BuildContext context) {
    return _buildCustomKeyboard();
  }


  // 自定义键盘布局
  Widget _buildCustomKeyboard() {
    return TextSelectionTheme(
      data: TextSelectionThemeData(
        selectionColor: Colors.green,//选中文字背景颜色
        selectionHandleColor: Colors.greenAccent,
        cursorColor: Colors.greenAccent,//光标颜色
      ),child: Container(
      height: 350,
      color: Colors.white,
      child: Column(
        children: [
          // 顶部显示区域，包含价格输入框和退格键
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    autofocus: true,
                    cursorColor: AppColors.appColor,
                    controller: tempPriceController,
                    keyboardType: TextInputType.none,
                    //调整光标下水滴型
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: "0.00",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 数字键盘区域
          Expanded(
            child: Column(
              children: [
                // 第一行
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: Column(
                        children: [
                          _buildKeyboardButton(
                              "1", () => onKeyboardTap("1")),
                          _buildKeyboardButton(
                              "4", () => onKeyboardTap("4")),
                          _buildKeyboardButton(
                              "7", () => onKeyboardTap("7")),
                          _buildKeyboardButton(
                              ".", () => onKeyboardTap(".")),
                        ],
                      )),
                      Expanded(child: Column(
                        children: [
                          _buildKeyboardButton(
                              "2", () => onKeyboardTap("2")),
                          _buildKeyboardButton(
                              "5", () => onKeyboardTap("5")),
                          _buildKeyboardButton(
                              "8", () => onKeyboardTap("8")),
                          _buildKeyboardButton(
                              "0", () => onKeyboardTap("0")),
                        ],
                      )),
                      Expanded(child: Column(
                        children: [
                          _buildKeyboardButton(
                              "3", () => onKeyboardTap("3")),
                          _buildKeyboardButton(
                              "6", () => onKeyboardTap("6")),
                          _buildKeyboardButton(
                              "9", () => onKeyboardTap("9")),
                          _buildSwitchKeyboardButton(),
                        ],
                      )),
                      Expanded(
                          child: Column(
                            children: [
                              _buildDeleteButton(),
                              _buildConfirmButton(),
                            ],
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  // 数字按钮
  Widget _buildKeyboardButton(String label, VoidCallback? onTap) {
    return Expanded(
      child: Container(
        decoration: (BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        )),
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Text(
              label,
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  // 删除按钮
  Widget _buildDeleteButton() {
    return Expanded(
      child: Container(
        decoration: (BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        )),
        child: Center(
          child: IconButton(
            icon: Icon(Icons.backspace, color: Colors.black54),
            onPressed: onBackspace,
          ),
        ),
      ),
    );
  }

  // 确认按钮
  Widget _buildConfirmButton() {
    return Expanded(
      child: Container(
        decoration: (BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        )),
        child: TextButton(
          onPressed: onConfirm,
          child: Center(
            child: Text(
              "确定",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  // 切换键盘按钮
  Widget _buildSwitchKeyboardButton() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(1),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: IconButton(
            icon: Icon(Icons.keyboard, color: Colors.black54),
            onPressed: onSwitchKeyboard,
          ),
        ),
      ),
    );
  }

}

