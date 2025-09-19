import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:wintek/core/constants/app_colors.dart';

class CustomHomeCarousel extends StatefulWidget {
  const CustomHomeCarousel({super.key});

  @override
  State<CustomHomeCarousel> createState() => _CustomHomeCarouselState();
}

class _CustomHomeCarouselState extends State<CustomHomeCarousel> {
  int _currentIndex = 0;

  final CarouselSliderController _carouselController =
      CarouselSliderController();

  final List<String> _images = [
    'assets/images/aviatrix.png',
    'assets/images/aviator.png',
    'assets/images/aviatrix.png',
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CarouselSlider.builder(
              carouselController: _carouselController,
              itemCount: _images.length,
              itemBuilder: (context, index, realIndex) {
                return Image.asset(
                  _images[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              },
              options: CarouselOptions(
                height: 210,
                viewportFraction: 1.0,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 600),
                autoPlayCurve: Curves.easeInOut,
                enlargeCenterPage: false,
                onPageChanged: (index, reason) {
                  setState(() => _currentIndex = index);
                },
              ),
            ),
          ),

          //! Indicator
          Positioned(
            bottom: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_images.length, (index) {
                final isActive = index == _currentIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: isActive ? 20 : 8,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.homeSeventhColor
                        : AppColors.homeEighthColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
