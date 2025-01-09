import 'package:flutter/material.dart';
import 'package:hangman/utils/utils.dart';

class CustomKeyboard extends StatelessWidget {
  final void Function(String) onKeyPress;

  const CustomKeyboard.MyKeyboard({
    Key? key,
    required this.onKeyPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final List<List<String>> keys = [
    //   ['A', 'B', 'C', 'D', 'E', 'F', 'G'],
    //   ['H', 'I', 'J', 'K', 'L', 'M', 'N'],
    //   ['O', 'P', 'Q', 'R', 'S', 'T', 'U'],
    //   ['V', 'W', 'X', 'Y', 'Z']
    // ];

    final List<List<String>> keys = [
      ['A', 'B', 'C', 'D', 'E'],
      ['F', 'G', 'H', 'I', 'J'],
      ['K', 'L', 'M', 'N', 'O'],
      ['P', 'Q', 'R', 'S', 'T'],
      ['U', 'V', 'W', 'X', 'Y', 'Z'],
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: keys.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: row.map((key) {
            return Expanded(
              child: _buildKey(key),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  Widget _buildKey(String key) {
    return InkWell(
      onTap: () => onKeyPress(key),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Text(
            key,
            style: retroStyle(20, Colors.white, FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
