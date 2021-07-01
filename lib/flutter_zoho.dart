import 'dart:async';

import 'package:flutter/services.dart';

class FlutterZoho {
  static const MethodChannel _channel = const MethodChannel('flutter_zoho');

  static Future<String?> initZoho(Map<String, dynamic> args) async {
    try {
      return _channel.invokeMethod('initZoho', args);
    } on PlatformException catch (e) {
      throw 'Error ${e.message}';
    }
  }

  static Future<String?> showNativeView(Map<String, dynamic> args) async {
    try {
      return _channel.invokeMethod('showNativeView', args);
    } on PlatformException catch (e) {
      throw 'Error ${e.message}';
    }
  }

  static Future<String?> changeLanguage(Map<String, dynamic> args) async {
    try {
      return _channel.invokeMethod('changeLanguage', args);
    } on PlatformException catch (e) {
      throw 'Error ${e.message}';
    }
  }

  static Future<String?> logout() async {
    try {
      return _channel.invokeMethod('logout');
    } on PlatformException catch (e) {
      throw 'Error ${e.message}';
    }
  }
}
