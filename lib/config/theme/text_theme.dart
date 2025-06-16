// import 'package:flutter/material.dart';
// import 'package:turnaround_mobile/config/constants/color_constant.dart';
// import 'package:turnaround_mobile/config/constants/size_constants.dart';
// import 'package:turnaround_mobile/config/helpers/responsive_helper.dart';

// /// Defines text themes for the appclass AppTextTheme {
// double _getResponsiveFontSize(BuildContext context, double baseSize) {
//   double screenWidth = ResponsiveUtil.width(context, 1);

//   // Define breakpoints and corresponding font sizes
//   if (screenWidth >= 600) {
//     // Large screens
//     return baseSize * 1.5;
//   } else if (screenWidth >= 400) {
//     // Medium-sized screens
//     return baseSize * 1.2;
//   } else {
//     // Small screens (e.g., mobile phones)
//     return baseSize;
//   }
// }

// TextStyle titleLarge(BuildContext context, {Color? color}) {
//   return TextStyle(
//     fontSize: _getResponsiveFontSize(context, 24.0.fSize(context)),
//     fontWeight: FontWeight.w700,
//     color: color ?? AppColors.textDark,
//   );
// }

// TextStyle title(BuildContext context, {Color? color}) {
//   return TextStyle(
//     fontSize: _getResponsiveFontSize(context, 20.0.fSize(context)),
//     fontWeight: FontWeight.w600,
//     color: color ?? AppColors.textDark,
//   );
// }

// TextStyle subtitle(BuildContext context, {Color? color}) {
//   return TextStyle(
//     fontSize: _getResponsiveFontSize(context, 18.0.fSize(context)),
//     fontWeight: FontWeight.w500,
//     color: color ?? AppColors.textDark,
//   );
// }

// TextStyle medium(BuildContext context, {Color? color}) {
//   return TextStyle(
//     fontSize: _getResponsiveFontSize(context, 16.0.fSize(context)),
//     fontWeight: FontWeight.w400,
//     color: color ?? AppColors.textDark,
//   );
// }

// TextStyle body(BuildContext context, {Color? color}) {
//   return TextStyle(
//     fontSize: _getResponsiveFontSize(context, 14.0.fSize(context)),
//     fontWeight: FontWeight.w400,
//     color: color ?? AppColors.textDark,
//   );
// }

// TextStyle bodySecondary(BuildContext context, {Color? color}) {
//   return TextStyle(
//     fontSize: _getResponsiveFontSize(context, 14.0.adaptSize(context)),
//     fontWeight: FontWeight.w400,
//     color: color ?? AppColors.textGrey,
//   );
// }

// TextStyle button(BuildContext context, {Color? color}) {
//   return TextStyle(
//     fontSize: _getResponsiveFontSize(context, 14.0.fSize(context)),
//     fontWeight: FontWeight.w500,
//     color: color ?? Colors.white,
//   );
// }

// TextStyle small(BuildContext context, {Color? color}) {
//   return TextStyle(
//     fontSize: _getResponsiveFontSize(context, 12.0.fSize(context)),
//     fontWeight: FontWeight.w400,
//     color: color ?? AppColors.textDark,
//   );
// }

// TextStyle extraSmall(BuildContext context, {Color? color}) {
//   return TextStyle(
//     fontSize: _getResponsiveFontSize(context, 10.fSize(context)),
//     fontWeight: FontWeight.w400,
//     color: color ?? AppColors.textDark,
//   );
// }

// TextStyle genericTextStyle(
//   BuildContext context, {
//   Color? color,
//   FontWeight? fontWeight,
//   double? fontSize,
// }) {
//   return TextStyle(
//     fontSize: _getResponsiveFontSize(context, fontSize ?? 12.0.fSize(context)),
//     fontWeight: fontWeight ?? FontWeight.w400,
//     color: color ?? AppColors.textDark,
//   );
// }
