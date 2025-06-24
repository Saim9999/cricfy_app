import 'dart:async';

import 'package:crickfy_app/screens/main_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () => Get.to(MainHomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder:
          (context, child) => Scaffold(
            backgroundColor: Color.fromARGB(255, 15, 19, 1),
            body: Center(
              child: Container(
                height: 250.h,
                width: 250.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/crickfy_logotext.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
    );
  }
}
