import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';
import '../theme/widget_themes/appbar_theme.dart';
import '../theme/widget_themes/bottom_sheet_theme.dart';
import '../theme/widget_themes/checkbox_theme.dart';
import '../theme/widget_themes/chip_theme.dart';
import '../theme/widget_themes/elevated_button_theme.dart';
import '../theme/widget_themes/outlined_button_theme.dart';
import '../theme/widget_themes/text_field_theme.dart';
import '../theme/widget_themes/text_theme.dart';

const colorSeed = Color.fromRGBO(0, 166, 91, 1);
// #00a65b

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.openSans().fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: colorSeed,
      primary: colorSeed,
      // surface: TColors.primaryBackground,

      // surface: AppColors.backgroundLight,
    ),
    disabledColor: TColors.grey,
    // brightness: Brightness.light,
    primaryColor: TColors.primary,
    textTheme: TTextTheme.lightTextTheme,
    chipTheme: TChipTheme.lightChipTheme,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
    scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.openSans().fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: colorSeed,
      primary: colorSeed,
      // surface: AppColors.backgroundLight,
    ),
    disabledColor: TColors.grey,
    // brightness: Brightness.dark,
    primaryColor: TColors.primary,
    textTheme: TTextTheme.darkTextTheme,
    chipTheme: TChipTheme.darkChipTheme,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    checkboxTheme: TCheckboxTheme.darkCheckboxTheme,
    scaffoldBackgroundColor: TColors.primary.withOpacity(0.1),
    bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
  );

  // Custom text themes
  // title page

  // Complete Color Scheme
  final colorScheme = ColorScheme.fromSeed(seedColor: colorSeed);
}










// import 'package:flutter/material.dart';



// class AppTheme {
  
//   static ligthTheme() => ThemeData(
//     useMaterial3: true,
//     fontFamily: 'Poppins',
//     brightness: Brightness.light,
//     primaryColor: Colors.blue,
//     scaffoldBackgroundColor: Colors.white,
//     appBarTheme: const AppBarTheme(
//       centerTitle: true,
//       color: Colors.white,
//       elevation: 0
//     ),
//     floatingActionButtonTheme: const FloatingActionButtonThemeData(
//       backgroundColor: Colors.blue,
//       elevation: 0
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.blue,
//         shape: const StadiumBorder(),
//         elevation: 0
//       )
//     ),
    

//   );
//   static darkTheme() => ThemeData.dark();

  


// }


























// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:turnaround_mobile/config/constants/color_constant.dart';
// import 'text_theme.dart';

// const colorSeed = Color.fromARGB(255, 0, 166, 91);
// const scaffoldBackgroundColor = Color(0xFFF8F7F7);

// class AppTheme {

  

//   ThemeData getTheme(bool isDarkMode) => ThemeData(
//     ///* General
//     useMaterial3: true,
//     // colorSchemeSeed: colorSeed,
//     colorScheme: isDarkMode
//         ? ColorScheme.fromSeed(
//       seedColor: colorSeed,
//       primary: colorSeed,
//       surface: AppColors.backgroundDark,
//       onSurface: AppColors.textLight,
//       // secondary: const Color.fromARGB(255, 0, 166, 91),
//       // tertiary: Colors.white,

//       // ···
//       brightness: Brightness.dark,
//     )
//         : ColorScheme.fromSeed(
//       seedColor: colorSeed,
//       primary: colorSeed,
//       surface: AppColors.backgroundLight,
//       onSurface: AppColors.textDark,
//       // secondary: const Color.fromARGB(255, 0, 166, 91),
//       // tertiary: Colors.white,

//       // ···
//       brightness: Brightness.light,    
//     ),



    
//     ///* Texttheme from text_theme file, match
//     // textTheme: TextTheme(
//     //   titleLarge: AppTextTheme.titleLarge,
//     //   titleMedium: AppTextTheme.titleMedium,
//     //   titleSmall: AppTextTheme.titleSmall,
//     //   bodyLarge: AppTextTheme.bodyLarge,
//     //   bodyMedium: AppTextTheme.bodyMedium,
//     //   bodySmall: AppTextTheme.bodySmall,
//     //   subtitle: AppTextTheme.subtitle,
//     //   extraSmall: AppTextTheme.extraSmall,
//     //   small: AppTextTheme.small,
//     //   medium: AppTextTheme.medium,
//     // )



//     textTheme: TextTheme(
//       titleLarge: GoogleFonts.openSans().copyWith(
//         fontSize: 40,
//         fontWeight: FontWeight.bold,
//       ),
//       titleMedium: GoogleFonts.openSans().copyWith(
//         fontSize: 30,
//         fontWeight: FontWeight.bold,
//       ),
//       titleSmall: GoogleFonts.openSans().copyWith(fontSize: 20),
//       bodyLarge: GoogleFonts.openSans().copyWith(fontSize: 16),
//       bodyMedium: GoogleFonts.openSans().copyWith(fontSize: 14),
//       bodySmall: GoogleFonts.openSans().copyWith(fontSize: 12),
//     ),

//     ///* Scaffold Background Color
//     scaffoldBackgroundColor: scaffoldBackgroundColor,

//     ///* Buttons
//     filledButtonTheme: FilledButtonThemeData(
//       style: ButtonStyle(
//         textStyle: WidgetStatePropertyAll(
//           GoogleFonts.openSans().copyWith(fontWeight: FontWeight.w700),
//         ),
//       ),
//     ),

//     ///* AppBar
//     appBarTheme: AppBarTheme(
//       color: scaffoldBackgroundColor,
//       titleTextStyle: GoogleFonts.openSans().copyWith(
//         fontSize: 25,
//         fontWeight: FontWeight.bold,
//         color: Colors.black,
//       ),
//     ),
//   );




  
// }


