import 'package:flutter/material.dart';

class BackgroundStack extends StatelessWidget {
  const BackgroundStack({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Expanded(child: Container(color: Colors.white))],
    );
  }
}
