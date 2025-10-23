import 'package:flutter/material.dart';

class AutoPlayWidget extends StatelessWidget {
  const AutoPlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 400,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Text('Auto Play'),
      ),
    );
  }
}
