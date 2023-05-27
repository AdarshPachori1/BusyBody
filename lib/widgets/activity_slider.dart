import 'package:flutter/cupertino.dart';

class ActivitySlider extends StatefulWidget {
  const ActivitySlider({super.key});

  @override
  State<ActivitySlider> createState() => _ActivitySliderState();
}

class _ActivitySliderState extends State<ActivitySlider> {
  double _currentSliderValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return CupertinoSlider(
      key: const Key('slider'),
      value: _currentSliderValue,
      // This allows the slider to jump between divisions.
      // If null, the slide movement is continuous.
      divisions: 4,
      // The maximum slider value
      max: 100,
      activeColor: CupertinoColors.systemPurple,
      thumbColor: CupertinoColors.systemPurple,
      // This is called when sliding is started.
      // onChangeStart: (double value) {
      //   setState(() {
      //     _sliderStatus = 'Sliding';
      //   });
      // },
      // // This is called when sliding has ended.
      // onChangeEnd: (double value) {
      //   setState(() {
      //     _sliderStatus = 'Finished sliding';
      //   });
      // },
      // This is called when slider value is changed.
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
      },
    );
  }
}
