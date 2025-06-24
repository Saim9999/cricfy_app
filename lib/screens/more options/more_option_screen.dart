// ignore_for_file: prefer_const_constructors

import 'package:crickfy_app/screens/more%20options/player_ranking.dart'
    show PlayerRanking;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'schedule_screen.dart';
import 'team_ranking.dart';

class MoreOptionScreen extends StatefulWidget {
  const MoreOptionScreen({super.key});

  @override
  State<MoreOptionScreen> createState() => _MoreOptionScreenState();
}

class _MoreOptionScreenState extends State<MoreOptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 15, 19, 1),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Rectangle 6370.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Text(
                'ICC Cricket Rankings',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'SpaceGrotesk-Regular',
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 10.h),
              InkWell(
                onTap: () {
                  Get.to(TeamRanking());
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            'Team Rankings',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontFamily: 'Mulish-ExtraBold',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: Icon(
                            Icons.navigate_next_rounded,
                            color: Color.fromARGB(255, 114, 255, 48),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: ExpansionTile(
                  title: Text(
                    'Player Rankings',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Mulish-ExtraBold',
                    ),
                  ),
                  textColor: Colors.white,
                  backgroundColor: Colors.black54,
                  iconColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.r)),
                  ),
                  collapsedBackgroundColor: Colors.black54,
                  collapsedTextColor: Colors.white,
                  collapsedIconColor: Color.fromARGB(255, 114, 255, 48),
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  childrenPadding: EdgeInsets.only(left: 20),
                  children: [
                    ListTile(
                      title: Text(
                        'Batter',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Mulish-ExtraBold',
                        ),
                      ),
                      trailing: Icon(
                        Icons.navigate_next,
                        color: Color.fromARGB(255, 114, 255, 48),
                      ),
                      onTap: () {
                        Get.to(
                          PlayerRanking(
                            url1:
                                'https://www.cricbuzz.com/cricket-stats/icc-rankings/men/batting',
                            url2: 'batsmen',
                          ),
                        );
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Bowler',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Mulish-ExtraBold',
                        ),
                      ),
                      trailing: Icon(
                        Icons.navigate_next,
                        color: Color.fromARGB(255, 114, 255, 48),
                      ),
                      onTap: () {
                        Get.to(
                          PlayerRanking(
                            url1:
                                'https://www.cricbuzz.com/cricket-stats/icc-rankings/men/bowling',
                            url2: 'bowlers',
                          ),
                        );
                      },
                    ),
                    ListTile(
                      title: Text(
                        'All-Rounder',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Mulish-ExtraBold',
                        ),
                      ),
                      trailing: Icon(
                        Icons.navigate_next,
                        color: Color.fromARGB(255, 114, 255, 48),
                      ),
                      onTap: () {
                        Get.to(
                          PlayerRanking(
                            url1:
                                'https://www.cricbuzz.com/cricket-stats/icc-rankings/men/all-rounder',
                            url2: 'allrounders',
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: ExpansionTile(
                  title: Text(
                    'Schedule',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Mulish-ExtraBold',
                    ),
                  ),
                  textColor: Colors.white,
                  backgroundColor: Colors.black54,
                  iconColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.r)),
                  ),
                  collapsedBackgroundColor: Colors.black54,
                  collapsedTextColor: Colors.white,
                  collapsedIconColor: Color.fromARGB(255, 114, 255, 48),
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  childrenPadding: EdgeInsets.only(left: 20),
                  children: [
                    ListTile(
                      title: Text(
                        'International',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Mulish-ExtraBold',
                        ),
                      ),
                      trailing: Icon(
                        Icons.navigate_next,
                        color: Color.fromARGB(255, 114, 255, 48),
                      ),
                      onTap: () {
                        Get.to(ScheduleScreen(type: 'international'));
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Domestic & Others',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Mulish-ExtraBold',
                        ),
                      ),
                      trailing: Icon(
                        Icons.navigate_next,
                        color: Color.fromARGB(255, 114, 255, 48),
                      ),
                      onTap: () {
                        Get.to(ScheduleScreen(type: 'domestic'));
                      },
                    ),
                    ListTile(
                      title: Text(
                        'T20 Leagues',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Mulish-ExtraBold',
                        ),
                      ),
                      trailing: Icon(
                        Icons.navigate_next,
                        color: Color.fromARGB(255, 114, 255, 48),
                      ),
                      onTap: () {
                        Get.to(ScheduleScreen(type: 't20-leagues'));
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Women',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Mulish-ExtraBold',
                        ),
                      ),
                      trailing: Icon(
                        Icons.navigate_next,
                        color: Color.fromARGB(255, 114, 255, 48),
                      ),
                      onTap: () {
                        Get.to(ScheduleScreen(type: 'women'));
                      },
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
