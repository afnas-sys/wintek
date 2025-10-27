import 'package:flutter/material.dart';

class CarromGameplayScreen extends StatefulWidget {
  const CarromGameplayScreen({super.key});

  @override
  State<CarromGameplayScreen> createState() => _CarromGameplayScreenState();
}

class _CarromGameplayScreenState extends State<CarromGameplayScreen> {
  bool _showSettings = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrom Game'),
        backgroundColor: const Color(0xFFFFFFFF),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              setState(() {
                _showSettings = !_showSettings;
              });
            },
          ),
        ],
      ),
    );
  }
}
