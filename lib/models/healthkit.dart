import 'package:flutter/services.dart';

const MethodChannel _channel = MethodChannel('healthkit');

Future<bool> requestAuthorizationHealthKit() async {
  try {
    final bool authorized = await _channel.invokeMethod('requestAuthorization');
    return authorized;
  } on PlatformException catch (e) {
    print('Failed to request authorization: ${e.message}');
    return false;
  }
}
