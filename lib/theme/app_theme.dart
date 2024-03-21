import 'package:flutter/material.dart';
class AppTheme {
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    bottomAppBarTheme: BottomAppBarTheme(color: Color(0xFF0230547)),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return Color(0xFF0230547).withOpacity(0.5);
            }
            return Color(0xFF0230547);
          },
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF0230547),
    ),
    appBarTheme: const AppBarTheme(
      color: Color(0xFF0230547),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    textTheme: const TextTheme(
      bodyText2: TextStyle(
        color: Colors.black54,
      ),
    ),
    cardColor: Color(0xFFF2F2F2), // Cor de fundo do card para o tema claro
  );

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      color: Color(0xFF0230547),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    bottomAppBarTheme: BottomAppBarTheme(color: Color(0xFF0230547)),
    textTheme: const TextTheme(
      bodyText2: TextStyle(
        color: Colors.white,
      ),
    ),
    cardColor: Color.fromARGB(255, 41, 41, 41), // Cor de fundo do card para o tema escuro
  );
}
