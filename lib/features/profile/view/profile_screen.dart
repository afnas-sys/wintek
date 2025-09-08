import 'package:flutter/material.dart';
import 'package:wintek/utils/constants/app_images.dart';
import 'package:wintek/utils/widgets/custom_elevated_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(255, 72, 54, 161),
              ),
              child: Column(
                children: [
                  Transform.translate(
                    offset: const Offset(0, -35),
                    child: Container(
                      padding: const EdgeInsets.all(2), // border thickness
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white, // border color
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          AppImages.homeSpinToWinImage,
                          fit: BoxFit.cover,
                          width: 80,
                          height: 80,
                        ),
                      ),
                    ),
                  ),
                  const Text('Rahul Sharma'),
                  Text(
                    'Rahul Sharma',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Divider(color: Colors.grey),
                  // ✅ Scrollable list of 16 items
                  ListView.builder(
                    itemCount: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return const ListTile(
                        leading: Icon(Icons.person),
                        title: Text('My Account Details'),
                        trailing: Icon(Icons.arrow_forward_ios_rounded),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CustomElevatedButton(
              width: double.infinity,
              textColor: Colors.white,
              borderRadius: 30,
              backgroundColor: const Color(0XFFEB644C),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppImages.logout, height: 24, width: 24),
                  const SizedBox(width: 10),
                  const Text('Logout'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
