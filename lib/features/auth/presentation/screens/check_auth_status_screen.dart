import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class CheckAuthStatusScreen extends StatelessWidget {
  const CheckAuthStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            // LOGO
            const Spacer(),
            Logo(height: 120,),
            const SizedBox(height: 20,),
            CircularProgressIndicator(
              strokeWidth: 3 , 
              color: color.primaryColor,
              backgroundColor: Colors.grey.shade300,
            ),
            const SizedBox(height: 20,),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}