import 'package:crickfy_app/rough_screens/points_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'news_rough_screen.dart';

class BackButtonScreen extends StatelessWidget {
  const BackButtonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Back Button'),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
                onPressed: () {
                  Get.to(NewsRoughScreen());
                },
                child: Text('Points Table')),
          ),
          Center(
            child: ElevatedButton(
                onPressed: () {
                  Get.to(RoughPointsTable());
                },
                child: Text('Stats')),
          )
        ],
      ),
    );
  }
}
