import 'package:flutter/material.dart';

MaterialColor mycolor = MaterialColor(
  const Color.fromARGB(255, 65, 60, 88).value,
  const <int, Color>{
    900: Color.fromARGB(255, 65, 60, 88),
    800: Color.fromARGB(255, 103, 95, 138),
    700: Color.fromARGB(255, 163, 196, 188),
    600: Color.fromARGB(255, 169, 199, 191),
    500: Color.fromARGB(255, 191, 215, 181),
    400: Color.fromARGB(255, 196, 216, 187),
    300: Color.fromARGB(255, 231, 239, 197),
    200: Color.fromARGB(255, 220, 226, 193),
    100: Color.fromARGB(255, 242, 231, 201),
    50: Color.fromARGB(255, 242, 233, 208),
  },
);

List<Color> colors1 = [
  const Color.fromARGB(255, 65, 60, 88),
  const Color.fromARGB(255, 103, 95, 138),
  const Color.fromARGB(255, 163, 196, 188),
  const Color.fromARGB(255, 169, 199, 191),
  const Color.fromARGB(255, 191, 215, 181),
  const Color.fromARGB(255, 196, 216, 187),
  const Color.fromARGB(255, 231, 239, 197),
  const Color.fromARGB(255, 220, 226, 193),
  const Color.fromARGB(255, 242, 231, 201),
  const Color.fromARGB(255, 242, 233, 208)
];

List<Color> colorsGradient = [
  const Color.fromARGB(255, 163, 196, 188),
  const Color.fromARGB(255, 169, 199, 191),
  const Color.fromARGB(255, 191, 215, 181),
  const Color.fromARGB(255, 196, 216, 187),
  const Color.fromARGB(255, 231, 239, 197),
  const Color.fromARGB(255, 220, 226, 193),
  const Color.fromARGB(255, 242, 231, 201),
  const Color.fromARGB(255, 242, 233, 208)
];

BoxDecoration backgroundGradient([border]) {
  return BoxDecoration(borderRadius: border, gradient: LinearGradient(colors: colorsGradient, begin: Alignment.topCenter, end: Alignment.bottomLeft));
}


    // 50: Color.fromARGB(255, 65, 60, 88),
    // 100: Color.fromARGB(255, 103, 95, 138),
    // 200: Color.fromARGB(255, 163, 196, 188),
    // 300: Color.fromARGB(255, 169, 199, 191),
    // 400: Color.fromARGB(255, 191, 215, 181),
    // 500: Color.fromARGB(255, 196, 216, 187),
    // 600: Color.fromARGB(255, 231, 239, 197),
    // 700: Color.fromARGB(255, 220, 226, 193),
    // 800: Color.fromARGB(255, 242, 231, 201),
    // 900: Color.fromARGB(255, 242, 233, 208),