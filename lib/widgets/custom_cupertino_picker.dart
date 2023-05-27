import 'package:flutter/cupertino.dart';

class CustomCupertinoPicker extends StatefulWidget {
  const CustomCupertinoPicker({super.key});

  @override
  State<CustomCupertinoPicker> createState() => _CustomCupertinoPickerState();
}

class _CustomCupertinoPickerState extends State<CustomCupertinoPicker> {
  int _selectedFruit = 0;
  final double _kItemExtent = 32.0;
  final List<String> _fruitNames = <String>[
    "4' 1\"",
    "4' 2\"",
    "4' 3\"",
    "4' 4\"",
    "4' 5\"",
    "4' 6\"",
    "4' 7\"",
    "4' 8\"",
    "4' 9\"",
    "4' 10\"",
    "4' 11\"",
    "5' 0\"",
    "5' 1\"",
    "5' 2\"",
    "5' 3\"",
    "5' 4\"",
    "5' 5\"",
    "5' 6\"",
    "5' 7\"",
    "5' 8\"",
    "5' 9\"",
    "5' 10\"",
    "5' 11\"",
    "6' 0\"",
    "6' 1\"",
    "6' 2\"",
    "6' 3\"",
    "6' 4\"",
    "6' 5\"",
    "6' 6\"",
    "6' 7\"",
    "6' 8\"",
    "6' 9\"",
    "6' 10\"",
    "6' 11\"",
    "7' 0\"",
  ];

  // This shows a CupertinoModalPopup with a reasonable fixed height which hosts CupertinoPicker.
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              // color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const Text('Height: '),
          CupertinoButton(
            padding: EdgeInsets.zero,
            // Display a CupertinoPicker with list of fruits.
            onPressed: () => _showDialog(
              CupertinoPicker(
                magnification: 1.22,
                squeeze: 1.2,
                useMagnifier: true,
                itemExtent: _kItemExtent,
                // This is called when selected item is changed.
                onSelectedItemChanged: (int selectedItem) {
                  setState(() {
                    _selectedFruit = selectedItem;
                  });
                },
                children:
                    List<Widget>.generate(_fruitNames.length, (int index) {
                  return Center(
                    child: Text(
                      _fruitNames[index],
                    ),
                  );
                }),
              ),
            ),
            // This displays the selected fruit name.
            child: Text(
              _fruitNames[_selectedFruit],
              style: const TextStyle(
                fontSize: 22.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
