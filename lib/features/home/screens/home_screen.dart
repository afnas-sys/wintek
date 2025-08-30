import 'package:flutter/material.dart';
import 'package:wintek/features/home/widgets/custom_home_appbar.dart';
import 'package:wintek/features/home/widgets/custom_home_carousel.dart';
import 'package:wintek/features/home/widgets/custom_home_grid_view_builder.dart';
import 'package:wintek/utils/app_colors.dart';
import 'package:wintek/utils/app_images.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.homePimaryColor,
          image: DecorationImage(
            image: AssetImage(AppImages.homeBgImage),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  //! AppBar container
                  CustomHomeAppbar(),
                  const SizedBox(height: 16),

                  //!  Carousel Container
                  CustomHomeCarousel(),

                  const SizedBox(height: 16),

                  //! Grid Items
                  CustomHomeGridViewBuilder(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
