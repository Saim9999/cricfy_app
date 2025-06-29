import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crickfy_app/screens/main_home_screen.dart';
import 'package:crickfy_app/screens/internet_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // ✅ Check actual internet connectivity by trying to access Google
  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true; // Internet is available
      }
    } catch (_) {
      // No Internet
    }
    return false;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return FutureBuilder<bool>(
          future: hasNetwork(),
          builder: (context, snapshot) {
            // While checking, optionally skip splash
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  backgroundColor: Color.fromARGB(255, 15, 19, 1),
                  body: SizedBox.shrink(), // 👈 no loader, clean transition
                ),
              );
            }
            final isConnected = snapshot.data ?? false;
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Cricfy',
              theme: ThemeData(primarySwatch: Colors.blue),
              home: isConnected ? MainHomeScreen() : NoInternetScreen(),
            );
          },
        );
      },
    );
  }
}
