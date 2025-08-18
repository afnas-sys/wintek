// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:winket/utils/app_colors.dart';
// import 'package:winket/utils/app_images.dart';

// class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
//   const CustomAppbar({super.key});

//   @override
//   Size get preferredSize => const Size.fromHeight(270); 

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: AppColors.appBarColor,
//       leading: IconButton(
//         icon: const Icon(FontAwesomeIcons.angleLeft),
//         onPressed: () {},
//       ),
//       title: Image.asset(AppImages.appbarImage),
//       centerTitle: true,
//       bottom: PreferredSize(
//         preferredSize: const Size.fromHeight(0),
//         child: Container(
//           // height: double.infinity,
//           // width: double.infinity,
//           decoration: BoxDecoration(
//             color: AppColors.appBarColor,
//             borderRadius: const BorderRadius.only(
//               bottomLeft: Radius.circular(30),
//               bottomRight: Radius.circular(30),
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 //const SizedBox(height: 20),
//                 Text('Log in', style: Theme.of(context).textTheme.bodyLarge),
//                 SizedBox(height: 10),
//                 Text(
//                   'Please log in with your phone number or emial\nIf you forget your password, please contact customer service',
//                   style: Theme.of(context).textTheme.bodySmall,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
