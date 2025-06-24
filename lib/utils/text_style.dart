import 'package:flutter/material.dart';

TextStyle textMethod(
    Color color, double fontSize, FontWeight fontWeight, String fontFamily) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
    fontFamily: fontFamily,
  );
}

ListView listbuilderMethod(List items, Widget Function(dynamic) itemBuilder) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const ScrollPhysics(),
    itemCount: items.length,
    itemBuilder: (context, index) {
      final item = items[index];
      return itemBuilder(item);
    },
  );
}
