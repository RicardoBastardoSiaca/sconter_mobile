import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuListTile extends StatelessWidget {
  final Widget? leading; // Optional leading widget
  // final Text? title; // Required title text
  final String title; // Required title text
  final Text? subTitle; // Optional subtitle text
  final Function? onTap; // Optional tap event handler
  final Function? onLongPress; // Optional long press event handler
  final Function? onDoubleTap; // Optional double tap event handler
  final Widget? trailing; // Optional trailing widget
  final Color? tileColor; // Optional tile background color
  final double? height; // Required height for the custom list tile

  // Constructor for the custom list tile
  const MenuListTile({
    super.key,
    this.leading,
    required this.title,
    this.subTitle,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.trailing,
    this.tileColor = Colors.transparent,
    this.height = 50, // Make height required for clarity
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      visualDensity: VisualDensity(vertical: -3),
      leading: leading,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontFamily: GoogleFonts.openSans(
            fontWeight: FontWeight.w500,
          ).fontFamily,
        ),
      ),
      subtitle: subTitle,
      onTap: () => onTap!(),
      onLongPress: () => onLongPress!(),
      // onDoubleTap: () => onDoubleTap!(),
      trailing: trailing,
      tileColor: tileColor,
      minLeadingWidth: 0,
    );
  }
}
