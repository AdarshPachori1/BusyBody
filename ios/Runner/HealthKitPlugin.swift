import Flutter
import Foundation
import HealthKit

public class HealthKitPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "healthkit", binaryMessenger: registrar.messenger())
    let instance = HealthKitPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "requestAuthorization" {
      requestAuthorization(result: result)
    } else {
      result(FlutterMethodNotImplemented)
    }
  }

  private func requestAuthorization(result: @escaping FlutterResult) {
    if HKHealthStore.isHealthDataAvailable() {
      let healthStore = HKHealthStore()
      let allTypes = Set([
        HKObjectType.quantityType(forIdentifier: .heartRate)!,
        HKObjectType.quantityType(forIdentifier: .stepCount)!,
        // Add more HealthKit data types that you want to request authorization for
      ])
      healthStore.requestAuthorization(toShare: nil, read: allTypes) { (success, error) in
        result(success)
      }
    } else {
      result(false)
    }
  }
}