import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Logo extends StatelessWidget {
  final double? height;
  const Logo({super.key, this.height = 120});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // Image(image: AssetImage("assets/icons/logo-trc.svg")),
          SizedBox(height: 50,),
          SvgPicture.asset("assets/icons/logo-trc-tagline.svg", height: height,),
          SizedBox(height: 20,),
          // Text('TRC', style: TextStyle(fontSize: 20),)
      ]),
    );
  }
}