import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // Image(image: AssetImage("assets/icons/logo-trc.svg")),
          SizedBox(height: 50,),
          SvgPicture.asset("assets/icons/logo-trc-tagline-2.svg", height: 140,),
          SizedBox(height: 20,),
          // Text('TRC', style: TextStyle(fontSize: 20),)
      ]),
    );
  }
}