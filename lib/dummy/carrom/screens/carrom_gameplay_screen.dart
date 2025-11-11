import 'package:flutter/material.dart';

class SwitchMenuEntry extends PopupMenuEntry<String> {
  final String label;
  final IconData icon;

  const SwitchMenuEntry({super.key, required this.label, required this.icon});

  @override
  double get height => 48.0;

  @override
  bool represents(String? value) => false;

  @override
  SwitchMenuEntryState createState() => SwitchMenuEntryState();
}

class SwitchMenuEntryState extends State<SwitchMenuEntry> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Icon(widget.icon, color: Colors.white),
              SizedBox(width: 10),
              Text(widget.label, style: TextStyle(color: Colors.white)),
              Spacer(),
              SizedBox(
                width: 32,
                height: 10,
                child: Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    inactiveThumbColor: Color(0XFFFFFFFF),
                    inactiveTrackColor: Color(0XFF6041FF),
                    value: _value,
                    onChanged: (val) {
                      setState(() {
                        _value = val;
                      });
                    },
                    activeColor: Colors.white,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(color: Colors.white.withOpacity(0.3), height: 1),
      ],
    );
  }
}

class CarromGameplayScreen extends StatefulWidget {
  const CarromGameplayScreen({super.key});

  @override
  State<CarromGameplayScreen> createState() => _CarromGameplayScreenState();
}

class _CarromGameplayScreenState extends State<CarromGameplayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: double.infinity,
                height: 420,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/carrom_board.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/message.png'),
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {},
              color: Color(0XFF6041FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              itemBuilder: (context) => [
                SwitchMenuEntry(label: 'Sound', icon: Icons.volume_down),
                SwitchMenuEntry(label: 'Vibrate', icon: Icons.vibration),
                SwitchMenuEntry(label: 'Emoji', icon: Icons.emoji_emotions),
                PopupMenuItem(value: 'help', child: Text('Help')),
              ],
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/carrom_settings.png'),
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
