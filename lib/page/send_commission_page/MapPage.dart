import 'dart:async';
import 'dart:math';

import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/scheduler.dart';

import '../../config.dart';

class MapPage extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;

  const MapPage({
    Key? key,
    this.initialLatitude,
    this.initialLongitude,
  }) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  ///地图通信中心
  AMapController? mapController;

  /// 定位插件
  AMapFlutterLocation? location;

  /// 权限状态
  PermissionStatus? permissionStatus;

  /// 相机位置
  CameraPosition? currentLocation;

  /// 地图类型
  late MapType _mapType;

  /// 周边数据
  List poisData = [];

  //
 BuildContext? _dialogContext;

  var markerLatitude;
  var markerLongitude;

  double? meLatitude;
  double? meLongitude;

  final TextEditingController _addressController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  // 当前选中的地址信息
  Map<String, dynamic>? _selectedLocation;

  Timer? _debounceTimer;

  FocusNode _addressFocusNode = FocusNode();
  bool _isDialogShowing = false;

  @override
  void initState() {
    super.initState();
    _mapType = MapType.normal;

    /// 设置Android和iOS的apikey，
    AMapFlutterLocation.setApiKey(ConstConfig.androidKey, ConstConfig.iosKey);

    /// 设置是否已经取得用户同意，如果未取得用户同意，高德定位SDK将不会工作,这里传true
    /// 设置是否已经取得用户同意，如果未取得用户同意，高德定位SDK将不会工作,这里传true
    AMapFlutterLocation.updatePrivacyAgree(true);

    /// 设置是否已经包含高德隐私政策并弹窗展示显示用户查看，如果未包含或者没有弹窗展示，高德定位SDK将不会工作,这里传true
    AMapFlutterLocation.updatePrivacyShow(true, true);

    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      markerLatitude = widget.initialLatitude;
      markerLongitude = widget.initialLongitude;

      currentLocation = CameraPosition(
        target: LatLng(widget.initialLatitude!, widget.initialLongitude!),
        zoom: 15,
      );

      Future.delayed(Duration(milliseconds: 500), () {
        _addMarker(LatLng(widget.initialLatitude!, widget.initialLongitude!));
        _getPoisData();
      });
    } else {
      requestPermission();
    }
  }

  Future<void> requestPermission() async {
    final status = await Permission.location.request();
    permissionStatus = status;
    switch (status) {
      case PermissionStatus.denied:
        print("拒绝");
        break;
      case PermissionStatus.granted:
        requestLocation();
        break;
      case PermissionStatus.limited:
        print("限制");
        break;
      default:
        print("其他状态");
        requestLocation();
        break;
    }
  }

  /// 请求位置
  void requestLocation() {
    bool hasInitialized = false; // 添加标记，确保只初始化一次

    location = AMapFlutterLocation()
      ..setLocationOption(AMapLocationOption(
        onceLocation: true,
        locationMode: AMapLocationMode.Battery_Saving,
      ))
      ..onLocationChanged().listen((event) {
        // 如果已经初始化过，直接返回
        if (hasInitialized) return;

        print("位置更新: $event");
        double? latitude = double.tryParse(event['latitude'].toString());
        double? longitude = double.tryParse(event['longitude'].toString());

        if (latitude != null && longitude != null) {
          hasInitialized = true; // 标记已初始化

          if (!mounted) return;
          setState(() {
            markerLatitude = latitude;
            markerLongitude = longitude;
            meLatitude = latitude;
            meLongitude = longitude;
            currentLocation = CameraPosition(
              target: LatLng(latitude, longitude),
              zoom: 15,
            );
          });

          _addMarker(LatLng(latitude, longitude));
          // 只在初始化时获取一次POI数据
          _getPoisData();

          // 获取完位置后立即停止定位
          location?.stopLocation();
        }
      });

    // 开始定位
    location?.startLocation();
  }

  void _onMapTap(LatLng position) {
    // 使用防抖处理状态更新
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      var _markerLatitude;
      if (!mounted) return;
      setState(() {
        markerLatitude = position.latitude;
        _markerLatitude = position.latitude;
        markerLongitude = position.longitude;
        _addMarker(position);
      });
      if(_markerLatitude!=markerLatitude){
        return;
      }
      _getPoisData();
      _getAddressFromLocation(position.latitude, position.longitude);
    });
  }

  // 添加根据坐标获取地址信息的方法
  Future<void> _getAddressFromLocation(double latitude, double longitude) async {
    try {
      var response = await Dio().get(
        'https://restapi.amap.com/v3/geocode/regeo',
        queryParameters: {
          'key': ConstConfig.webKey,
          'location': '$longitude,$latitude',
          'extensions': 'base',
        },
      );

      if (response.data['status'] == '1' &&
          response.data['regeocode'] != null) {
        var regeocode = response.data['regeocode'];
        var addressComponent = regeocode['addressComponent'];
        var formatted_address = matchAddress(regeocode['formatted_address']);

        // 构造位置信息
        Map<String, dynamic> locationInfo = {
          'name': formatted_address,
          'address': formatted_address,
          'pname': addressComponent['province'],
          'cityname': addressComponent['city'],
          'adname': addressComponent['district'],
        };

        // 显示确认对话框
        _showLocationConfirmDialog(locationInfo);
      }
    } catch (e) {
      print('获取地址信息失败: $e');
    }
  }

  void _onMapPoiTouched(AMapPoi poi) async {
    if (null == poi) return;

    if(_debounceTimer?.isActive ?? false){
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(Duration(milliseconds: 500), () async{
      var poiData = poi.toJson();
      print('获取到的poi信息：$poiData');

      // 更新标记位置
      setState(() {
        markerLatitude = poi.latLng?.latitude;
        markerLongitude = poi.latLng?.longitude;
        _addMarker(poi.latLng!);
        _getPoisData();
      });

      // 获取详细的地址信息
      try {
        var response = await Dio().get(
          'https://restapi.amap.com/v3/geocode/regeo',
          queryParameters: {
            'key': ConstConfig.webKey,
            'location': '${poi.latLng?.longitude},${poi.latLng?.latitude}',
            'extensions': 'base',
            'radius': 50,
          },
        );

        if (response.data['status'] == '1' &&
            response.data['regeocode'] != null) {
          var regeocode = response.data['regeocode'];
          var addressComponent = regeocode['addressComponent'];
          var formatted_address = matchAddress(regeocode['formatted_address']);

          print('获取到的地址信息：$regeocode');

          // 构造位置信息，使用 POI 的名称和逆地理编码的地址信息
          Map<String, dynamic> locationInfo = {
            'name': poi.name,
            // POI 点的名称
            'address': formatted_address,
            // 完整地址
            'pname': addressComponent['province'] ?? '',
            'cityname': addressComponent['city'] ?? '',
            'adname': addressComponent['district'] ?? '',
            'location': '${poi.latLng?.longitude},${poi.latLng?.latitude}',
            // 保存经纬度信息
            'latLng': [poi.latLng?.longitude, poi.latLng?.latitude],
            // 保存为数组格式
          };

          // 显示确认对话框
          _showLocationConfirmDialog(locationInfo);
        }
      } catch (e) {
        print('获取地址详细信息失败: $e');

        // 如果获取详细地址失败，至少显示 POI 的基本信息
        Map<String, dynamic> locationInfo = {
          'name': poi.name,
          'address': poi.name,
          'pname': '',
          'cityname': '',
          'adname': '',
          'location': '${poi.latLng?.longitude},${poi.latLng?.latitude}',
          'latLng': [poi.latLng?.longitude, poi.latLng?.latitude],
        };
        _showLocationConfirmDialog(locationInfo);
      }
    });

  }

  void _showLocationConfirmDialog(Map<String, dynamic> locationInfo) {
    // 如果对话框正在显示，先关闭它
    if (_isDialogShowing && _dialogContext != null) {
      Navigator.pop(_dialogContext!);
    }

    _isDialogShowing = true;
    
    showDialog(
      context: context,
      builder: (dialogContext) {
        _dialogContext = dialogContext;  // 保存新对话框的context
        return AlertDialog(
          title: Text('确认选择'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('是否选择该位置作为服务地点？'),
              SizedBox(height: 8),
              Text(
                '${locationInfo['name']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${locationInfo['address']}',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _dialogContext = null;
                _isDialogShowing = false;  // 重置标记
              },
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(context, {
                  'address': '${locationInfo['name']}, ${locationInfo['address']}',
                  'latitude': markerLatitude,
                  'longitude': markerLongitude,
                  'locationDetail': locationInfo,
                });
                _dialogContext = null;
                _isDialogShowing = false;  // 重置标记
              },
              child: Text('确定'),
            ),
          ],
        );
      },
    ).then((_) {
      // 确保对话框关闭时重置状态
      _dialogContext = null;
      _isDialogShowing = false;
    });
  }

  //需要先设置一个空的map赋值给AMapWidget的markers，否则后续无法添加marker
  final Map<String, Marker> _markers = <String, Marker>{};

  //添加一个marker
  void _addMarker(LatLng markPostion) async {
    _removeAll();
    final Marker marker = Marker(
      position: markPostion,
      //使用默认hue的方式设置Marker的图标
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );
    //调用setState触发AMapWidget的更新，从而完成marker的添加
    setState(() {
      //将新的marker添加到map里
      _markers[marker.id] = marker;
    });
    _changeCameraPosition(markPostion, zoom: 15);
  }

  /// 清除marker
  void _removeAll() {
    if (_markers.isNotEmpty) {
      setState(() {
        _markers.clear();
      });
    }
  }

  /// 改变中心点
  void _changeCameraPosition(LatLng markPostion, {double? zoom}) {
    mapController?.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: markPostion, zoom: zoom ?? 15, tilt: 30, bearing: 0),
      ),
      animated: true,
    );
  }

  @override
  void dispose() {
    // 确保在页面销毁时关闭对话框
    if (_isDialogShowing && _dialogContext != null) {
      Navigator.pop(_dialogContext!);
    }
    _poiDebounceTimer?.cancel();
    _debounceTimer?.cancel();
    location?.stopLocation();
    location?.destroy();
    mapController?.disponse();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("选择位置", style: TextStyle()),
      ),
      body: Stack(
        children: [
          // 底层地图和周边位置
          currentLocation == null
              ? Container()
              : Column(
                  children: [
                    // 搜索框
                    Container(
                      padding: EdgeInsets.all(16),
                      color: Colors.white,
                      child: TextField(
                        controller: _addressController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                        ],
                        autofocus: false,
                        focusNode: _addressFocusNode,
                        onTapOutside: (event) {
                          _addressFocusNode.unfocus();
                        },
                        decoration: InputDecoration(
                          hintText: '请输入详细地址（如：河北师范大学）',
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: _addressController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _addressController.clear();
                                      _searchResults.clear();
                                    });
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            _searchAddress();
                          } else {
                            setState(() {
                              _searchResults.clear();
                            });
                          }
                        },
                      ),
                    ),
                    // 地图和周边位置
                    Expanded(
                      child: Column(
                        children: [
                          // 地图部分
                          Expanded(
                            flex: 2,
                            child: _buildMap(),
                          ),
                          // 周边位置列表
                          Container(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('周边位置',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  height: 200,
                                  child: ListView.builder(
                                    itemCount: poisData.length,
                                    itemBuilder: (context, index) {
                                      final poi = poisData[index];
                                      return ListTile(
                                        title: Text(poi['name']),
                                        subtitle: poi['address'] is List ? Text(poi['address'].join('\n')) : Text(poi['address']),
                                        onTap: () => _showLocationConfirmDialog(poi),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          // 搜索结果覆盖层
          if (_searchResults.isNotEmpty)
            Positioned(
              top: 80,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.white,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _searchResults.length,
                  separatorBuilder: (context, index) => Divider(height: 1),
                  itemBuilder: (context, index) {
                    final result = _searchResults[index];
                    return ListTile(
                      title: Text(result['name']),
                      subtitle: Text(
                        '${result['pname']}${result['cityname']}${result['adname']}${result['address']}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        List<String> location = result['location'].split(',');
                        double longitude = double.parse(location[0]);
                        double latitude = double.parse(location[1]);
                        setState(() {
                          markerLatitude = latitude;
                          markerLongitude = longitude;
                          _searchResults.clear();
                          _addMarker(LatLng(latitude, longitude));
                          _changeCameraPosition(LatLng(latitude, longitude));
                        });
                        _showLocationConfirmDialog(result);
                      },
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 获取周边数据
  bool _isLoadingPois = false;
  Timer? _poiDebounceTimer;

  Future<void> _getPoisData() async {
    // 如果正在加载或组件已销毁，直接返回
    if (_isLoadingPois || !mounted) return;

    // 取消之前的定时器
    _poiDebounceTimer?.cancel();
    
    // 设置新的定时器
    _poiDebounceTimer = Timer(Duration(milliseconds: 500), () async {
      setState(() {
        _isLoadingPois = true;
        poisData = [];
      });

      try {
        var response = await Dio().get(
          'https://restapi.amap.com/v3/place/around',
          queryParameters: {
            'key': ConstConfig.webKey,
            'location': '$markerLongitude,$markerLatitude',
            'radius': '2000',
            'types': '120000|130000|141200',
            'offset': '20',
            'page': '1',
            'extensions': 'all',
            'sortrule': 'distance'
          },
        );

        if (mounted && response.data['status'] == '1' && response.data['pois'] != null) {
          setState(() {
            poisData = response.data['pois'];
            poisData.forEach((e) => print(e));
            poisData.forEach((e) =>  e['address'] = e['adname']+ e['address']?.split('|')?.map((e) => e.trim())?.join('\n')  );
            if (poisData.isNotEmpty && widget.initialLatitude == null) {
              _showLocationConfirmDialog(poisData[0]);
            }
          });
        }
      } catch (e) {
        print('获取周边数据失败: $e');
      } finally {
        if (mounted) {
          setState(() {
            _isLoadingPois = false;
          });
        }
      }
    });
  }

  // 添加搜索地址方法
  Future<void> _searchAddress() async {
    if (_addressController.text.isEmpty) return;

    try {
      var response = await Dio().get(
        'https://restapi.amap.com/v3/place/text',
        queryParameters: {
          'key': ConstConfig.webKey,
          'keywords': _addressController.text,
          'city': '全国',
          'extensions': 'all',
          'types': '120000|130000|141200',
        },
      );

      if (response.data['status'] == '1' && response.data['pois'] != null) {
        setState(() {
          _searchResults =
              List<Map<String, dynamic>>.from(response.data['pois']);
        });
      }
    } catch (e) {
      print('搜索地址失败: $e');
    }
  }

   // 匹配地址
  String matchAddress(String address) {

     String pattern = r'([省|市|自治区])(.*)';
     RegExp regExp = RegExp(pattern) ;
     RegExpMatch? match = regExp.firstMatch(address);
     if (match != null) {
       String matchedAddress = match.group(2)!;
       return matchedAddress;
     } else {
       return address;
     }
  }


  // 优化地图构建
  Widget _buildMap() {
    return RepaintBoundary(
      child: AMapWidget(
        privacyStatement: ConstConfig.amapPrivacyStatement,
        apiKey: ConstConfig.amapApiKeys,
        initialCameraPosition: currentLocation!,
        myLocationStyleOptions: MyLocationStyleOptions(true,),
        mapType: MapType.normal,
        minMaxZoomPreference: const MinMaxZoomPreference(3, 20),
        onPoiTouched: _onMapPoiTouched,
        onTap: _onMapTap,
        markers: Set<Marker>.of(_markers.values),
        onMapCreated: (AMapController controller) {
          if (mounted) {
            mapController = controller;
          }
        },
      ),
    );
  }
}
