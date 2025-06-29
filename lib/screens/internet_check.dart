import 'dart:io';

import 'package:crickfy_app/screens/main_home_screen.dart';
import 'package:crickfy_app/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder:
          (context, child) => Scaffold(
            backgroundColor: Color.fromARGB(255, 15, 19, 1),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_off_rounded,
                    size: 40.sp,
                    color: Color.fromARGB(255, 114, 255, 48),
                  ),
                  SizedBox(height: 25.h),
                  Text(
                    'You\'re offline',
                    style: textMethod(
                      Colors.white,
                      16.sp,
                      FontWeight.bold,
                      'Mulish-ExtraBold',
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    '🚫 Please connect to the internet and try again.',
                    style: textMethod(
                      Colors.grey,
                      14.sp,
                      FontWeight.normal,
                      'Mulish-ExtraBold',
                    ),
                  ),
                  SizedBox(height: 15.h),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final result = await InternetAddress.lookup(
                          'example.com',
                        );
                        if (result.isNotEmpty &&
                            result[0].rawAddress.isNotEmpty) {
                          Get.offAll(
                            () => MainHomeScreen(),
                          ); // ✅ Navigate only if online
                        } else {
                          Get.snackbar(
                            'No Internet',
                            'Please check your connection and try again.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      } catch (_) {
                        Get.snackbar(
                          'No Internet',
                          'Still no internet connection.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.restart_alt_outlined, color: Colors.white),
                        SizedBox(width: 5), // spacing
                        Text(
                          'Retry',
                          style: textMethod(
                            Colors.white,
                            14.sp,
                            FontWeight.normal,
                            'Mulish-ExtraBold',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
