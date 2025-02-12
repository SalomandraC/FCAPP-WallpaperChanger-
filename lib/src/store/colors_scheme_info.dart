import 'package:fcap/main.dart';
import 'package:flutter/material.dart';

final Map<AppTheme, ThemeData> appThemes = {
  AppTheme.red: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.red,
      brightness: Brightness.light,
    ),
    extensions: <ThemeExtension<dynamic>>[
      CustomThemeExtension(
        myCustomColor: const Color.fromARGB(204, 76, 135, 5),
      ),
    ],
  ),
  AppTheme.green: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.lightGreenAccent,
      brightness: Brightness.light,
    ),
    extensions: <ThemeExtension<dynamic>>[
      CustomThemeExtension(
        myCustomColor: const Color(0xFF4CAF50),
      ),
    ],
  ),
  AppTheme.blue: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
    extensions: <ThemeExtension<dynamic>>[
      CustomThemeExtension(
        myCustomColor: const Color.fromARGB(255, 90, 55, 218),
      ),
    ],
  ),
};

class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  final Color myCustomColor;

  CustomThemeExtension({required this.myCustomColor});

  @override
  ThemeExtension<CustomThemeExtension> copyWith({Color? myCustomColor}) {
    return CustomThemeExtension(
      myCustomColor: myCustomColor ?? this.myCustomColor,
    );
  }

  @override
  ThemeExtension<CustomThemeExtension> lerp(
      ThemeExtension<CustomThemeExtension>? other, double t) {
    if (other is! CustomThemeExtension) {
      return this;
    }
    return CustomThemeExtension(
      myCustomColor: Color.lerp(myCustomColor, other.myCustomColor, t)!,
    );
  }
}
