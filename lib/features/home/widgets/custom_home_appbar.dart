import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dio/dio.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/core/router/routes_names.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/features/game/aviator/providers/user_provider.dart';

class CustomHomeAppbar extends ConsumerStatefulWidget {
  const CustomHomeAppbar({super.key});

  @override
  ConsumerState<CustomHomeAppbar> createState() => _CustomHomeAppbarState();
}

class _CustomHomeAppbarState extends ConsumerState<CustomHomeAppbar> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProvider.notifier).fetchUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);
    return Container(
      height: 56,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.homeSecondaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            child: SvgPicture.asset(
              AppImages.homeAppIconImage,
              height: 24,
              width: 92,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    height: 36,
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 4,
                      top: 4,
                      bottom: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.homeThirdColor,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: AppColors.homeFourththColor,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: userAsync.when(
                            loading: () => const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            error: (error, stackTrace) {
                              if (error is DioException &&
                                  (error.type ==
                                          DioExceptionType.connectionTimeout ||
                                      error.type ==
                                          DioExceptionType.receiveTimeout ||
                                      error.type ==
                                          DioExceptionType.sendTimeout ||
                                      error.type ==
                                          DioExceptionType.connectionError ||
                                      error.type == DioExceptionType.unknown)) {
                                return const Text(
                                  'Check Connectivity',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                );
                              }
                              return const Text(
                                'Session expired',
                                overflow: TextOverflow.ellipsis,
                              );
                            },
                            data: (userModel) {
                              if (userModel == null) {
                                return const Text(
                                  'Please login',
                                  overflow: TextOverflow.ellipsis,
                                );
                              }
                              final user = userModel.data;
                              return Text(
                                '₹ ${user.wallet.toStringAsFixed(2)}',
                                style: Theme.of(
                                  context,
                                ).textTheme.homeSmallPrimaryBold,
                                maxLines: 1,
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, RoutesNames.deposit),
                          child: Container(
                            height: 28,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.homeFivethColor,
                                  AppColors.homeSxithColor,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                'Deposit',
                                style: Theme.of(
                                  context,
                                ).textTheme.homeSmallPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: AppColors.homeSecondaryColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  alignment: Alignment.center,
                  child: Image.asset(AppImages.homeAppbarImage),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
