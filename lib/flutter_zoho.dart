import 'dart:async';

import 'package:flutter/services.dart';

class FlutterZoho {
  static const MethodChannel _channel = const MethodChannel('flutter_zoho');

  // static Future<String?> showNativeView(Map<String, dynamic> args) async {
  //   try {
  //     return _channel.invokeMethod('showNativeView', args);
  //   } on PlatformException catch (e) {
  //     throw 'Error ${e.message}';
  //   }
  // }

  static Future<String?> showNativeView(
      {required String ordId,
      required String appId,
      required String accessToken}) async {
    try {
      return _channel.invokeMethod('showNativeView',
          {'ordId': ordId, 'appId': appId, 'accessToken': accessToken});
    } on PlatformException catch (e) {
      throw 'Error ${e.message}';
    }
  }
}
