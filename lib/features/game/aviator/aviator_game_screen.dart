import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:winket/features/game/aviator/widget/aviator_buttons.dart';
import 'package:winket/features/game/aviator/widget/balance_container.dart';
import 'package:winket/features/game/aviator/widget/graph_container.dart';
import 'package:winket/utils/theme.dart';

class AviatorGameScreen extends StatefulWidget {
  const AviatorGameScreen({super.key});

  @override
  State<AviatorGameScreen> createState() => _AviatorGameScreenState();
}

class _AviatorGameScreenState extends State<AviatorGameScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                BalanceContainer(),
                SizedBox(height: 16),
                AviatorButtons(),
                SizedBox(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text('Round ID: 436963', style: Theme.of(context).textTheme.bodySmallPrimary,),
                  Text('Round ID: 436963', style: Theme.of(context).textTheme.bodySmallPrimary,),
                ],),
                SizedBox(height: 1),
                GraphContainer()



              ],
            ),
          ),
        ),
      ),
    );
  }
}
