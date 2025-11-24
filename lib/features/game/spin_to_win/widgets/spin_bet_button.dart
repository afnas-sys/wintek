import 'package:flutter/material.dart';

class SpinBetButton extends StatelessWidget {
  const SpinBetButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: 216,
      width: double.infinity,
      decoration: BoxDecoration(
        // color: Colors.blue,
        image: DecorationImage(
          image: AssetImage('assets/images/spintowinbetbg.png'),
          fit: BoxFit.contain,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bet Amount',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(16),
              filled: true,
              fillColor: Color(0Xff001732),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(56),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  SizedBox(width: 16),
                  Text('₹', style: TextStyle(color: Colors.white)),
                  SizedBox(width: 8),
                  Text('|', style: TextStyle(color: Colors.white)),
                  SizedBox(width: 8),
                ],
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  SizedBox(width: 16),
                  Text('₹', style: TextStyle(color: Colors.white)),
                  SizedBox(width: 8),
                  Text('|', style: TextStyle(color: Colors.white)),
                  SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
