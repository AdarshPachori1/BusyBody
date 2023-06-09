import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:health/health.dart';
import 'package:flutter/services.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  List<HealthDataPoint> sleepData = [];
  bool performOnce = false;
  HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
  int counterSleepingPeriod = 1;
  void requestAuthorization() async {
    try {
      bool isAuthorized = await health.requestAuthorization(
        [
          HealthDataType.SLEEP_IN_BED,
        ],
      );
      if (isAuthorized) {
        // Authorization granted, proceed with accessing sleep data
        // Define the query parameters
        final endDate = DateTime.now();
        final startDate = endDate.subtract(const Duration(hours: 24));
        //final startDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
        //final endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);

        // Query the sleep data
        List<HealthDataPoint> results = await health.getHealthDataFromTypes(
          startDate,
          endDate,
          [
            HealthDataType.SLEEP_IN_BED,
          ],
        );
        setState(() {
          sleepData = results;
        });
      } else {
        // Authorization denied or error occurred
        print('Authorization failed');
      }
    } on PlatformException catch (e) {
      print('Authorization request failed: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    double heightOfScreen = MediaQuery.of(context).size.height;
    double widthOfScreen = MediaQuery.of(context).size.width;
    if (!performOnce) {
      requestAuthorization();
      performOnce = true;
    }

    return sleepData.isEmpty
        ? const CircularProgressIndicator(value: null)
        : Column(
            children: [
              const Text("Sleeping Behavior in the past 24 hours"),
              ...sleepData.reversed.map(
                (dataPoint) {
                  final startDate = dataPoint.dateFrom;
                  final endDate = dataPoint.dateTo;
                  final sleepDuration = endDate.difference(startDate).inHours;

                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 20.0),
                    height: 0.6 * heightOfScreen,
                    width: 0.9 * widthOfScreen,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "During Sleeping period #${counterSleepingPeriod++}"),
                          Text("You began sleeping exactly at $startDate. "),
                          Text("You stopped Sleeping at $endDate."),
                          Text("In total, you slept $sleepDuration hours. "),
                          Text(
                              "More precisely, you slept for ${dataPoint.value} ${dataPoint.unitString == "MINUTE" ? "minutes" : dataPoint.unitString}.")
                        ],
                      ),
                    ),
                  );
                },
              ).toList(),
              sleepData
                          .map((dataPoint) {
                            return dataPoint.dateTo
                                .difference(dataPoint.dateFrom)
                                .inHours;
                          })
                          .toList()
                          .reduce((value, element) => value + element) >=
                      8
                  ? const Text("Great job meeting sleeping goal of 8 hours")
                  : const Text("Sleep a bit more to meet your sleeping goal!"),
            ],
          );
  }
}
