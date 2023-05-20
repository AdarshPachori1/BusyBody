import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if #available(iOS 9.0, *) {
      // Request authorization for HealthKit on app launch
      let healthKitChannel = FlutterMethodChannel(name: "healthkit", binaryMessenger: (window.rootViewController as! FlutterViewController).binaryMessenger)
      healthKitChannel.invokeMethod("requestAuthorization", arguments: nil)
    }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}


