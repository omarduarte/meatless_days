import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Todo: include disabled and loader
class DayTypeRadioButton extends StatelessWidget {
  final int radioValue;
  final int activeRadioValue;
  final Color activeColor;
  final String label;
  final Function onSelection;

  const DayTypeRadioButton({
    Key? key,
    required this.radioValue,
    required this.activeColor,
    required this.label,
    required this.onSelection,
    required this.activeRadioValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSelected = this.radioValue == this.activeRadioValue;

    return InkWell(
      onTap: () => onSelection(),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.white70,
          borderRadius: BorderRadius.circular(25),
          border:
              Border.all(color: isSelected ? Colors.transparent : activeColor),
        ),
        child: Row(
          children: [
            Radio(
              value: radioValue,
              groupValue: activeRadioValue,
              activeColor: Colors.white70,
              fillColor: RadioButtonStateColor(
                  defaultColor: activeColor, pressedColor: Colors.white70),
              onChanged: (_) => onSelection(),
            ),
            Text(
              label,
              style: TextStyle(
                  color: isSelected ? Colors.white : activeColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class RadioButtonStateColor extends MaterialStateColor {
  final Color defaultColor;
  final Color pressedColor;

  RadioButtonStateColor(
      {required this.defaultColor, required this.pressedColor})
      : super(defaultColor.value);

  @override
  Color resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return pressedColor;
    }
    return defaultColor;
  }
}
