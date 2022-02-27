import 'package:wassapviews/libraries.dart';

ThemeData appTheme = ThemeData(
  cardColor: AppColors.white,
  primaryColor: AppColors.grey1,
  textSelectionTheme: TextSelectionThemeData(
    selectionColor: AppColors.lightModeTransparentGreen,
    cursorColor: AppColors.lightModeGreen,
  ),
  primaryColorDark: AppColors.grey2,
  primaryColorLight: AppColors.grey2,
  shadowColor: AppColors.grey5,
  cursorColor: AppColors.lightModeGreen,
  buttonColor: AppColors.black,
  backgroundColor: AppColors.white,
  accentColor: AppColors.lightModeGreen,
  appBarTheme: const AppBarTheme(
    foregroundColor: AppColors.black,
    color: AppColors.white,
  ),
  colorScheme: const ColorScheme.light(),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: AppColors.lightModeGreen),
    ),
  ),
);

ThemeData appThemeDark = ThemeData(
  cardColor: AppColors.grey6,
  primaryColor: AppColors.grey5,
  primaryColorDark: AppColors.grey6,
  primaryColorLight: AppColors.grey3,
  textSelectionTheme: TextSelectionThemeData(
    selectionColor: AppColors.darkModeTransparentGreen,
    cursorColor: AppColors.darkModeGreen,
  ),
  shadowColor: AppColors.grey3,
  cursorColor: AppColors.darkModeGreen,
  buttonColor: AppColors.white,
  backgroundColor: AppColors.lightBlack,
  accentColor: AppColors.darkModeGreen,
  appBarTheme: const AppBarTheme(
    foregroundColor: AppColors.white,
    color: AppColors.lightBlack,
  ),
  colorScheme: const ColorScheme.dark(),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: AppColors.darkModeGreen),
    ),
  ),
);
