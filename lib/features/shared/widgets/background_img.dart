import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BackgroundImg extends StatelessWidget {
  const BackgroundImg({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 30),
      child: SvgPicture.asset(
        'assets/icons/mapa-mundi-bg.svg',
        alignment: Alignment.bottomCenter,
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
      ),
    );
  }
}
