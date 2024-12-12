import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationHelper {
  //工厂模式调用该类时，默认调用此方法，将实例对象返回出去
  static NotificationHelper? _instance = null;

  static NotificationHelper getInstance() {
    _instance ??= NotificationHelper._initial();
    return _instance!;
  }

  factory NotificationHelper() => _instance ??= NotificationHelper._initial();

  //创建命名构造函数
  NotificationHelper._initial() {
    initialize();
  }

  // FlutterLocalNotificationsPlugin实例
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // 常量定义
  static const String _channelId = 'your.channel.id';
  static const String _channelName = 'your channel name';
  static const String _channelDescription = 'your channel description';
  static const String _ticker = 'ticker';
  static const String _darwinNotificationCategoryPlain = 'plainCategory';

  // 初始化通知插件
  Future<void> initialize() async {
    try {
      final AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ikun');
      final DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
              requestSoundPermission: false,
              requestBadgePermission: false,
              requestAlertPermission: false,
          );
      final InitializationSettings initializationSettings =
          InitializationSettings(
              android: initializationSettingsAndroid,
              iOS: initializationSettingsIOS);
      await _notificationsPlugin.initialize(initializationSettings);
    } catch (e) {
      print('初始化通知插件失败: $e');
    }
  }

  Future<void> requestNotificationPermissions() async {
    if (await Permission.notification.isDenied) {
      final status = await Permission.notification.request();
      final status1 = await Permission.scheduleExactAlarm.request();
      //LogUtils.d("requestNotificationPermissions ：通知权限status1 $status1");
      if (status.isGranted) {
        //LogUtils.d("requestNotificationPermissions ：通知权限已授予");
        print('============ 通知权限已授予 ============');
      } else {
        //LogUtils.d("requestNotificationPermissions ：通知权限被拒绝");
        print('============ 通知权限被拒绝 ============');
      }
    } else {
      //LogUtils.d("requestNotificationPermissions ：通知权限已授予");
      print('========== 通知权限已授予 ===========');
    }
  }

  // 显示通知
  Future<void> showNotification(
      {required String title, required String body}) async {
    try {
      final AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        _channelId, _channelName, //通知渠道的id
        channelDescription: _channelDescription,
        //通知渠道的描述
        importance: Importance.max,
        //优先级
        priority: Priority.high,
        //优先级
        ticker: _ticker,
        //状态栏的提示
        // icon: '@mipmap/ikun',
        //通知的图标
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ikun'),
      );

      final DarwinNotificationDetails iosNotificationDetails =
          DarwinNotificationDetails(
              categoryIdentifier: _darwinNotificationCategoryPlain);

      final NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidNotificationDetails, iOS: iosNotificationDetails);

      await _notificationsPlugin.show(
        1,
        title,
        body,
        platformChannelSpecifics, //通知详情
      );
      print('========== 显示通知成功 ===========');
      print('========== icon: ${androidNotificationDetails.icon} ===========');
    } catch (e) {
      print('显示通知失败: $e');
    }
  }

//  周期性通知
//   Future<void> scheduleNotification({
//     required int id,
//     required String title,
//     required String body,
//   }) async {
//     const AndroidNotificationDetails androidNotificationDetails =
//     AndroidNotificationDetails('your.channel.id', 'your channel name',
//         channelDescription: 'your channel description',
//         importance: Importance.max,
//         priority: Priority.high,
//         ticker: 'ticker');
//
//     // ios的通知
//     const String darwinNotificationCategoryPlain = 'plainCategory';
//     const DarwinNotificationDetails iosNotificationDetails =
//     DarwinNotificationDetails(
//       categoryIdentifier: darwinNotificationCategoryPlain, // 通知分类
//     );
//     // 创建跨平台通知
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//         android: androidNotificationDetails, iOS: iosNotificationDetails);
// // 发起通知
//     await _notificationsPlugin.periodicallyShow(
//         id, title, body, RepeatInterval.everyMinute, platformChannelSpecifics);
//   }

// 定时通知
//   Future<void> zonedScheduleNotification({required int id,
//     required String title,
//     required String body,
//     required DateTime scheduledDateTime}) async {
//     const AndroidNotificationDetails androidNotificationDetails =
//     AndroidNotificationDetails('10001', '唤醒',
//         channelDescription: 'your channel description',
//         importance: Importance.max,
//         priority: Priority.high,
//         ticker: 'ticker');
//
//     // ios的通知
//     const String darwinNotificationCategoryPlain = 'plainCategory';
//     const DarwinNotificationDetails iosNotificationDetails =
//     DarwinNotificationDetails(
//       categoryIdentifier: darwinNotificationCategoryPlain, // 通知分类
//     );
//     // 创建跨平台通知
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//         android: androidNotificationDetails, iOS: iosNotificationDetails);
//
//     // 获取本地时区
//     final location = tz.getLocation(tz.local.name);
//     // 发起通知
//     _notificationsPlugin.zonedSchedule(
//       id, title, body,
//       TZDateTime.from(scheduledDateTime, location), // 使用本地时区的时间
//       platformChannelSpecifics,
//       uiLocalNotificationDateInterpretation:
//       UILocalNotificationDateInterpretation.wallClockTime, // 设置通知的触发时间是觉得时间
//     );
//   }

  /// 取消全部通知
  cancelAll() {
    _notificationsPlugin.cancelAll();
  }

  /// 取消对应ID的通知
  cancelId(int id) {
    _notificationsPlugin.cancel(id);
  }
}
