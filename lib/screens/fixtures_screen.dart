import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;

class WorldCupData {
  final String matchDate;
  final String matchTime;
  // final String matchTitle;
  final String stadiumName;
  final String matchStatus;
  final String gmtTime;
  final String localTime;
  final String teamOne;
  final String teamSecond;
  final String matchNo;
  final String matchGroup;

  WorldCupData({
    required this.matchDate,
    required this.matchTime,
    // required this.matchTitle,
    required this.stadiumName,
    required this.matchStatus,
    required this.gmtTime,
    required this.localTime,
    required this.teamOne,
    required this.teamSecond,
    required this.matchNo,
    required this.matchGroup,
  });
}

class FixtureScreen extends StatefulWidget {
  final String url;
  const FixtureScreen({super.key, required this.url});

  @override
  State<FixtureScreen> createState() => _FixtureScreenState();
}

class _FixtureScreenState extends State<FixtureScreen> {
  late Timer timer;
  final DateTime targetDateTime = DateTime(2024, 06, 01, 05, 30, 00);
  Duration _calculateRemainingTime() {
    final now = DateTime.now();
    final remainingTime = targetDateTime.difference(now);
    return remainingTime.isNegative ? Duration.zero : remainingTime;
  }

  bool isLoading = true;
  final List<WorldCupData> worldcupData = [];

  @override
  void initState() {
    super.initState();
    fetchWorldCupData();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> fetchWorldCupData() async {
    if (!mounted) {
      // Check if the widget is still mounted before proceeding
      return;
    }
    setState(() {
      isLoading = true;
    });
    final response = await http.get(
      Uri.parse(
        'https://www.cricbuzz.com/cricket-series/9325/icc-champions-trophy-2025/matches',
      ),
    );

    if (response.statusCode == 200) {
      final document = html.parse(response.body);

      final elements = document.querySelectorAll('.cb-series-matches');
      for (var element in elements) {
        final timestamp =
            element
                .querySelector(
                  '.cb-col-40.cb-col.cb-srs-mtchs-tm .schedule-date',
                )
                ?.attributes['timestamp'];
        final scheduleDate = timestamp != null ? int.tryParse(timestamp) : null;
        if (scheduleDate != null) {
          final date = DateTime.fromMillisecondsSinceEpoch(scheduleDate);
          final realdate = DateFormat('EEEE, MMMM dd, yyyy').format(date);
          final realtime = DateFormat('h:mm a').format(date);

          final matchTitle =
              element.querySelector('.cb-srs-mtchs-tm span')?.text ?? '';

          List<String> parts = matchTitle.split('vs');
          String team1 = parts[0].trim();
          List<String> parts1 = matchTitle.split('vs ');
          String team2 = parts1[1].split(',')[0];
          List<String> parts2 = matchTitle.split(',');
          String matchno = parts2[1].trim();
          List<String> parts3 = matchTitle.split(',');
          // String group = parts3[2].trim();
          String group = parts3.length > 2 ? parts3[2].trim() : '';
          try {
            final stadiumDetails = element.querySelectorAll('.text-gray');
            final stadiumName = stadiumDetails[0].text;
            final matchResult =
                element.querySelector('.cb-text-complete')?.text ??
                'Match starts at $realdate';
            final timeElements = element.querySelectorAll(
              'div.cb-font-12.text-gray > span',
            );
            final gmtTime = timeElements[0].text;
            final localTime = timeElements[1].text.trim().replaceAll('  ', '');
            final matchLink =
                element.querySelector('a')!.attributes['href'] ?? '';

            print('Formatted Date: $realdate');
            print('Formated Time: $realtime');
            print('Team 1: $team1');
            print('Team 2: $team2');
            print('Match No. : $matchno');
            if (group.isNotEmpty) {
              print('Group : $group');
            }
            // print('Match Title: $matchTitle');
            print('Stadium Name: $stadiumName');
            print('Match Status: $matchResult');
            print('GMT Time: $gmtTime');
            print('Local Time: $localTime');
            print('Match Link: $matchLink');

            worldcupData.add(
              WorldCupData(
                matchDate: realdate,
                matchTime: realtime,
                teamOne: team1,
                teamSecond: team2,
                matchNo: matchno,
                matchGroup: group,
                // matchTitle: matchTitle,
                stadiumName: stadiumName,
                matchStatus: matchResult,
                gmtTime: gmtTime,
                localTime: localTime,
              ),
            );
          } catch (e) {
            print('An error occurred: $e');
          }
        }
      }

      if (!mounted) {
        // Check if the widget is still mounted before calling setState
        return;
      }

      setState(() {
        // No need to set state for allPlayerNames as we separated them into different lists
        isLoading = false;
      });
    } else {
      print('Failed to fetch news: ${response.statusCode}');
      if (!mounted) {
        // Check if the widget is still mounted before calling setState
        return;
      }
      setState(() {
        isLoading = false; // Set isLoading to false in case of failure
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final remainingTime = _calculateRemainingTime();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 15, 19, 1),
      body:
          isLoading
              ? Center(
                child: LoadingAnimationWidget.horizontalRotatingDots(
                  size: 50,
                  color: Color.fromARGB(255, 114, 255, 48),
                ),
              )
              : Stack(
                children: [
                  Image.asset(
                    'assets/images/blur backgroung.png',
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    scale: 1,
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: ListView(
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.red,
                          highlightColor: Colors.amber,
                          period: Duration(seconds: 3),
                          child: Text(
                            'ICC Champions Trophy Feb 19 - Mar 09',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'Mulish-ExtraBold',
                            ),
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          'ICC CT Starts in..',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'SpaceGrotesk-Regular',
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClockItem(
                              label: 'Months',
                              value: '${remainingTime.inDays ~/ 30}',
                            ),
                            SizedBox(width: 5.w),
                            ClockItem(
                              label: 'Days',
                              value: '${remainingTime.inDays % 30}',
                            ),
                            SizedBox(width: 5.w),
                            ClockItem(
                              label: 'Hrs',
                              value: '${remainingTime.inHours % 24}',
                            ),
                            SizedBox(width: 5.w),
                            ClockItem(
                              label: 'Mins',
                              value: '${remainingTime.inMinutes % 60}',
                            ),
                            SizedBox(width: 5.w),
                            ClockItem(
                              label: 'Secs',
                              value: '${remainingTime.inSeconds % 60}',
                            ),
                            SizedBox(width: 5.w),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        Divider(thickness: 2, color: Colors.white),
                        SizedBox(height: 16.h),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: worldcupData.length,
                          itemBuilder: (context, index) {
                            final item = worldcupData[index];
                            return ListView(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              children: [
                                Text(
                                  item.matchDate,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    color: Colors.white,
                                    fontFamily: 'SpaceGrotesk-Regular',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  height: 160.h,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        'assets/images/Decorated container.png',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            item.matchNo,
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              color: Colors.white,
                                              fontFamily:
                                                  'SpaceGrotesk-Regular',
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          Text(
                                            item.matchTime,
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              color: Color.fromARGB(
                                                255,
                                                114,
                                                255,
                                                48,
                                              ),
                                              fontFamily:
                                                  'SpaceGrotesk-Regular',
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                item.stadiumName,
                                                style: TextStyle(
                                                  fontSize: 10.sp,
                                                  color: Colors.white,
                                                  fontFamily:
                                                      'SpaceGrotesk-Regular',
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 20.w),
                                          Text(
                                            item.matchGroup,
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Colors.white,
                                              fontFamily:
                                                  'SpaceGrotesk-Regular',
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(color: Colors.white),
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 18.h,
                                            width: 32.w,
                                            child: _getImageForTeam(
                                              item.teamOne,
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                item.teamOne,
                                                style: TextStyle(
                                                  fontSize: 22.sp,
                                                  color: Colors.white,
                                                  fontFamily:
                                                      'SpaceGrotesk-Regular',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 18.h,
                                            width: 32.w,
                                            child: _getImageForTeam(
                                              item.teamSecond,
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                item.teamSecond,
                                                style: TextStyle(
                                                  fontSize: 22.sp,
                                                  color: Colors.white,
                                                  fontFamily:
                                                      'SpaceGrotesk-Regular',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10.h),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          item.matchStatus,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: Colors.lightBlue,
                                            fontFamily: 'SpaceGrotesk-Regular',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }

  Image _getImageForTeam(String format) {
    switch (format) {
      case 'SRI LANKA':
        return Image.asset('assets/images/sri_lanka.png');
      case 'SOUTH AFRICA':
        return Image.asset('assets/images/south_africa.png');
      case 'AFGHANISTAN':
        return Image.asset('assets/images/afghanistan.png');
      case 'ENGLAND':
        return Image.asset('assets/images/england.png');
      case 'NETHERLANDS':
        return Image.asset('assets/images/netherlands.png');
      case 'INDIA':
        return Image.asset('assets/images/india.png');
      case 'AUSTRALIA':
        return Image.asset('assets/images/australia.png');
      case 'PAKISTAN':
        return Image.asset('assets/images/pakistan.png');
      case 'BANGLADESH':
        return Image.asset('assets/images/bangladesh.png');
      case 'NEW ZEALAND':
        return Image.asset('assets/images/new-zealand.png');
      case 'IRELAND':
        return Image.asset('assets/images/ireland.png');
      case 'CANADA':
        return Image.asset('assets/images/canada.png');
      case 'UNITED STATES OF AMERICA':
        return Image.asset('assets/images/united_states.png');
      case 'NAMIBIA':
        return Image.asset('assets/images/namibia.png');
      case 'SCOTLAND':
        return Image.asset('assets/images/scotland.png');
      case 'OMAN':
        return Image.asset('assets/images/oman.png');
      case 'WEST INDIES':
        return Image.asset('assets/images/west_indies.png');
      case 'UGANDA':
        return Image.asset('assets/images/uganda.png');
      case 'PAPUA NEW GUINEA':
        return Image.asset('assets/images/papua.png');
      case 'NEPAL':
        return Image.asset('assets/images/napal.png');
      case 'TBC':
        return Image.asset('assets/images/shield 1.png');
      default:
        return Image.asset('assets/images/earth_flag.png');
    }
  }
}

class ClockItem extends StatefulWidget {
  final String label;
  final String value;

  const ClockItem({super.key, required this.label, required this.value});

  @override
  State<ClockItem> createState() => _ClockItemState();
}

class _ClockItemState extends State<ClockItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              widget.value.toString().padLeft(2, '0'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'SpaceGrotesk-Regular',
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontFamily: 'SpaceGrotesk-Regular',
          ),
        ),
      ],
    );
  }
}
