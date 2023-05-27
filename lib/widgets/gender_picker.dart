import 'package:flutter/cupertino.dart';

class GenderPicker extends StatefulWidget {
  const GenderPicker({super.key});

  @override
  State<GenderPicker> createState() => _GenderPickerState();
}

class _GenderPickerState extends State<GenderPicker> {
  final double _kItemExtent = 32.0;
  final List<String> _fruitNames = <String>[
    "Female",
    "Male",
    "Nonbinary",
    "Other",
    "Prefer not to say",
  ];

  int _selectedFruit = 0;

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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const Text('Gender: '),
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
