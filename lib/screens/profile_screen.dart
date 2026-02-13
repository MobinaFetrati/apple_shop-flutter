import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_project/constants/custom_colors.dart';
import 'package:flutter_ecommerce_project/screens/login_screen.dart';
import 'package:flutter_ecommerce_project/util/auth_manager.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgrounScreenColor,
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              height: 45,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Row(
                children: [
                  const SizedBox(width: 15),
                  Image.asset('assets/images/icon_apple_blue.png'),
                  const Expanded(
                    child: Text(
                      'حساب کاربری',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'SB',
                        fontSize: 15,
                        color: CustomColors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            'مبینا فطرتی',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'SB',
              fontSize: 15,
            ),
          ),
          Text(
            '09123548891',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'SM',
              fontSize: 10,
            ),
          ),
          SizedBox(height: 150),
          ElevatedButton(
              onPressed: () {
                AuthManager.logOut();

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
              child: Text('خروج از حساب کاربری')),
          Spacer(),
          Text(
            'اپل شاپ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'SM',
              fontSize: 10,
              color: CustomColors.gray,
            ),
          ),
          Text(
            'virsion 2.5+1',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'SM',
              fontSize: 10,
              color: CustomColors.gray,
            ),
          ),
          Text(
            'instagram.com/flutter_dev ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'SM',
              fontSize: 10,
              color: CustomColors.gray,
            ),
          ),
        ],
      )),
    );
  }
}
