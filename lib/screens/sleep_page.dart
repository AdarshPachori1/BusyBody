import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:health_kit_reporter/health_kit_reporter.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  // void requestAuthorization() async {
  //   await requestAuthorizationHealthKit().then((result) {
  //     print("HealthKit authorization result: $result");
  //   });
  // }

  // void requestAuthorization() async {
  //   try {
  //     final readTypes = <String>[];
  //     readTypes.addAll(QuantityType.values.map((e) => e.identifier));
  //     final writeTypes = <String>[
  //       QuantityType.stepCount.identifier,
  //     ];
  //     final isRequested =
  //         await HealthKitReporter.requestAuthorization(readTypes, writeTypes);
  //     if (isRequested) {
  //       // read data/write data/observe data
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  void requestAuthorization() async {
    try {
      final readTypes = <String>[];
      readTypes.addAll(QuantityType.values.map((e) => e.identifier));
      final writeTypes = <String>[
        QuantityType.stepCount.identifier,
      ];
      final isRequested =
          await HealthKitReporter.requestAuthorization(readTypes, writeTypes);
      if (isRequested) {
        // read data/write data/observe data
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // requestAuthorization();
    requestAuthorization();
    return const Text("Sleep Page");
  }
}
