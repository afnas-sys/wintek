import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wintek/features/home/screens/home_screen.dart';
import 'package:wintek/features/offers/view/offers_screen.dart';
import 'package:wintek/features/profile/view/profile_screen.dart';
import 'package:wintek/features/wallet/view/wallet_screen.dart';
import 'package:wintek/core/constants/app_colors.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({super.key});

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  int _currentIndex = 0;
  List<Widget> bodys = [
    HomeScreen(),
    WalletScreen(),
    OffersScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodys[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: AppColors.bottomTransparent,
          highlightColor: AppColors.bottomTransparent,
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppColors.bottomBarBgColor,
              elevation: 0,
              selectedItemColor: AppColors.bottomBarSelectedColor,
              unselectedItemColor: AppColors.bottomBarUnselectedColor,
              iconSize: 24,
              mouseCursor: MaterialStateMouseCursor.clickable,
              currentIndex: _currentIndex,
              selectedLabelStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),

              onTap: (i) => setState(() => _currentIndex = i),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.house),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.wallet),
                  label: 'Wallet',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.percent),
                  label: 'Offers',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.idBadge),
                  label: 'Profile',
                ),
              ],
            ),

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.bottomGradientSecondaryColor,
                        AppColors.bottomGradientPrimaryColor,
                        AppColors.bottomGradientSecondaryColor,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
