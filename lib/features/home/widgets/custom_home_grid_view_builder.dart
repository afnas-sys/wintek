import 'package:flutter/material.dart';
import 'package:wintek/utils/constants/app_images.dart';
import 'package:wintek/utils/router/routes_names.dart';

class CustomHomeGridViewBuilder extends StatefulWidget {
  const CustomHomeGridViewBuilder({super.key});

  @override
  State<CustomHomeGridViewBuilder> createState() =>
      _CustomHomeGridViewBuilderState();
}

class _CustomHomeGridViewBuilderState extends State<CustomHomeGridViewBuilder> {
  final List<Map<String, dynamic>> gridItems = [
    {'image': AppImages.homeAviatorImage, 'screen': RoutesNames.aviatorGame},
    {'image': AppImages.homeCrashImage, 'screen': RoutesNames.aviatorGame},
    {'image': AppImages.homeCarromImage, 'screen': RoutesNames.aviatorGame},
    {'image': AppImages.homeSpinToWinImage, 'screen': RoutesNames.aviatorGame},
    {
      'image': AppImages.homecardJackPotImage,
      'screen': RoutesNames.cardJackpot,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: gridItems.length,
      itemBuilder: (context, index) {
        final item = gridItems[index];
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, item['screen']),
          child: Container(
            height: 200,
            width: 186,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(item['image']),
                fit: BoxFit.fill,
              ),
            ),
          ),
        );
      },
    );
  }
}
