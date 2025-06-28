import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../classes/commentary classes.dart';

class TeamRanking extends StatefulWidget {
  const TeamRanking({super.key});

  @override
  State<TeamRanking> createState() => _TeamRankingState();
}

class _TeamRankingState extends State<TeamRanking> {
  final List<TestTeamRankingInfo> testteamrankingInfo = [];
  final List<ODITeamRankingInfo> oditeamrankingInfo = [];
  final List<T20TeamRankingInfo> t20teamrankingInfo = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCricketRankings();
  }

  Future<void> fetchCricketRankings() async {
    if (!mounted) {
      // Check if the widget is still mounted before proceeding
      return;
    }
    // Set isLoading to true before fetching data
    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse(
        'https://www.cricbuzz.com/cricket-stats/icc-rankings/men/teams',
      ),
    );

    if (response.statusCode == 200) {
      final document = html.parse(response.body);

      final teamsTestsDiv = document.querySelector(
        '.cb-col.cb-col-100.cb-padding-left0[ng-show="\'teams-tests\' == act_rank_format"]',
      );
      final teamsODIsDiv = document.querySelector(
        '.cb-col.cb-col-100.cb-padding-left0[ng-show="\'teams-odis\' == act_rank_format"]',
      );
      final teamsT20sDiv = document.querySelector(
        '.cb-col.cb-col-100.cb-padding-left0[ng-show="\'teams-t20s\' == act_rank_format"]',
      );

      if (teamsTestsDiv != null) {
        final teamRankTests = teamsTestsDiv.querySelectorAll(
          '.cb-col.cb-col-20.cb-lst-itm-sm',
        );
        final teamNameTests = teamsTestsDiv.querySelectorAll(
          '.cb-col.cb-col-50.cb-lst-itm-sm.text-left',
        );
        final teamRatingTests = teamsTestsDiv.querySelectorAll(
          '.cb-col.cb-col-14.cb-lst-itm-sm',
        );
        final teamPointsTests = teamsTestsDiv.querySelectorAll(
          '.cb-col.cb-col-14.cb-lst-itm-sm:last-child',
        );

        final List<String> allTeamRanks =
            teamRankTests.map((element) => element.text).toList();
        final List<String> allTeamNames =
            teamNameTests.map((element) => element.text).toList();
        final List<String> allTeamRating =
            teamRatingTests.map((element) => element.text).toList();
        final List<String> allTeamPoints =
            teamPointsTests.map((element) => element.text).toList();

        final List<String> selectedTeamRating = [];
        for (var entry in allTeamRating.asMap().entries) {
          if (entry.key.isEven) {
            selectedTeamRating.add(entry.value);
          }
        }

        for (var i = 0; i < allTeamNames.length; i++) {
          if (i < 10) {
            testteamrankingInfo.add(
              TestTeamRankingInfo(
                teamRank: allTeamRanks[i],
                teamName: allTeamNames[i],
                teamRating: selectedTeamRating[i],
                teamPoints: allTeamPoints[i],
              ),
            );
          }
        }
      }

      if (teamsODIsDiv != null) {
        final teamRankOdi = teamsODIsDiv.querySelectorAll(
          '.cb-col.cb-col-20.cb-lst-itm-sm',
        );
        final teamNameOdi = teamsODIsDiv.querySelectorAll(
          '.cb-col.cb-col-50.cb-lst-itm-sm.text-left',
        );
        final teamRatingOdi = teamsODIsDiv.querySelectorAll(
          '.cb-col.cb-col-14.cb-lst-itm-sm',
        );
        final teamPointsOdi = teamsODIsDiv.querySelectorAll(
          '.cb-col.cb-col-14.cb-lst-itm-sm:last-child',
        );

        final List<String> allTeamRanks =
            teamRankOdi.map((element) => element.text).toList();
        final List<String> allTeamNames =
            teamNameOdi.map((element) => element.text).toList();
        final List<String> allTeamRating =
            teamRatingOdi.map((element) => element.text).toList();
        final List<String> allTeamPoints =
            teamPointsOdi.map((element) => element.text).toList();

        final List<String> selectedTeamRating = [];
        for (var entry in allTeamRating.asMap().entries) {
          if (entry.key.isEven) {
            selectedTeamRating.add(entry.value);
          }
        }

        for (var i = 0; i < allTeamNames.length; i++) {
          if (i < 10) {
            oditeamrankingInfo.add(
              ODITeamRankingInfo(
                teamRank: allTeamRanks[i],
                teamName: allTeamNames[i],
                teamRating: selectedTeamRating[i],
                teamPoints: allTeamPoints[i],
              ),
            );
          }
        }
      }

      if (teamsT20sDiv != null) {
        final teamRankT20 = teamsT20sDiv.querySelectorAll(
          '.cb-col.cb-col-20.cb-lst-itm-sm',
        );
        final teamNameT20 = teamsT20sDiv.querySelectorAll(
          '.cb-col.cb-col-50.cb-lst-itm-sm.text-left',
        );
        final teamRatingT20 = teamsT20sDiv.querySelectorAll(
          '.cb-col.cb-col-14.cb-lst-itm-sm',
        );
        final teamPointsT20 = teamsT20sDiv.querySelectorAll(
          '.cb-col.cb-col-14.cb-lst-itm-sm:last-child',
        );

        final List<String> allTeamRanks =
            teamRankT20.map((element) => element.text).toList();
        final List<String> allTeamNames =
            teamNameT20.map((element) => element.text).toList();
        final List<String> allTeamRating =
            teamRatingT20.map((element) => element.text).toList();
        final List<String> allTeamPoints =
            teamPointsT20.map((element) => element.text).toList();

        final List<String> selectedTeamRating = [];
        for (var entry in allTeamRating.asMap().entries) {
          if (entry.key.isEven) {
            selectedTeamRating.add(entry.value);
          }
        }

        for (var i = 0; i < allTeamNames.length; i++) {
          if (i < 10) {
            t20teamrankingInfo.add(
              T20TeamRankingInfo(
                teamRank: allTeamRanks[i],
                teamName: allTeamNames[i],
                teamRating: selectedTeamRating[i],
                teamPoints: allTeamPoints[i],
              ),
            );
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
      print('Failed to fetch data: ${response.statusCode}');
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 15, 19, 1),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          toolbarHeight: 90.h,
          bottom: TabBar(
            indicatorColor: Color.fromARGB(255, 114, 255, 48),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white12,
            tabs: [
              Tab(
                child: Text(
                  'TEST',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'SpaceGrotesk-Regular',
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'ODI',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'SpaceGrotesk-Regular',
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'T20I',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'SpaceGrotesk-Regular',
                  ),
                ),
              ),
            ],
          ), // TabBar
          title: Text(
            'Team Rankings',
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.white,
              fontFamily: 'Mulish-ExtraBold',
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ), // AppBar
        body: Stack(
          children: [
            Image.asset(
              'assets/images/blur backgroung.png',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              scale: 1,
            ),
            TabBarView(
              children: [
                isLoading
                    ? Center(
                      child: LoadingAnimationWidget.horizontalRotatingDots(
                        size: 50,
                        color: Color.fromARGB(255, 114, 255, 48),
                      ),
                    )
                    : ListView(
                      children: [
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Ratings',
                              style: TextStyle(
                                color: Color.fromARGB(255, 114, 255, 48),
                                fontSize: 14.sp,
                                fontFamily: 'SpaceGrotesk-Regular',
                              ),
                            ),
                            SizedBox(width: 20.w),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Text(
                                'Points',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 114, 255, 48),
                                  fontSize: 14.sp,
                                  fontFamily: 'SpaceGrotesk-Regular',
                                ),
                              ),
                            ),
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: testteamrankingInfo.length,
                          itemBuilder: (context, index) {
                            final item = testteamrankingInfo[index];
                            return ListTile(
                              horizontalTitleGap: 4,
                              leading: Text(
                                item.teamRank,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontFamily: 'SpaceGrotesk-Regular',
                                ),
                              ),
                              title: Text(
                                item.teamName,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: 'Mulish-ExtraBold',
                                  color: Colors.white,
                                ),
                              ),
                              trailing: Container(
                                width: 110.w,
                                child: Row(
                                  children: [
                                    Text(
                                      item.teamRating,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontFamily: 'SpaceGrotesk-Regular',
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 45.w),
                                    Expanded(
                                      child: Text(
                                        item.teamPoints,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontFamily: 'SpaceGrotesk-Regular',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                isLoading
                    ? Center(
                      child: LoadingAnimationWidget.horizontalRotatingDots(
                        size: 50,
                        color: Color.fromARGB(255, 114, 255, 48),
                      ),
                    )
                    : ListView(
                      children: [
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Ratings',
                              style: TextStyle(
                                color: Color.fromARGB(255, 114, 255, 48),
                                fontSize: 14.sp,
                                fontFamily: 'SpaceGrotesk-Regular',
                              ),
                            ),
                            SizedBox(width: 20.w),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Text(
                                'Points',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 114, 255, 48),
                                  fontSize: 14.sp,
                                  fontFamily: 'SpaceGrotesk-Regular',
                                ),
                              ),
                            ),
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: oditeamrankingInfo.length,
                          itemBuilder: (context, index) {
                            final item = oditeamrankingInfo[index];
                            return ListTile(
                              horizontalTitleGap: 4,
                              leading: Text(
                                item.teamRank,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontFamily: 'SpaceGrotesk-Regular',
                                ),
                              ),
                              title: Text(
                                item.teamName,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: 'Mulish-ExtraBold',
                                  color: Colors.white,
                                ),
                              ),
                              trailing: Container(
                                width: 110.w,
                                child: Row(
                                  children: [
                                    Text(
                                      item.teamRating,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontFamily: 'SpaceGrotesk-Regular',
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 45.w),
                                    Text(
                                      item.teamPoints,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontFamily: 'SpaceGrotesk-Regular',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                isLoading
                    ? Center(
                      child: LoadingAnimationWidget.horizontalRotatingDots(
                        size: 50,
                        color: Color.fromARGB(255, 114, 255, 48),
                      ),
                    )
                    : ListView(
                      children: [
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Ratings',
                              style: TextStyle(
                                color: Color.fromARGB(255, 114, 255, 48),
                                fontSize: 14.sp,
                                fontFamily: 'SpaceGrotesk-Regular',
                              ),
                            ),
                            SizedBox(width: 20.w),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Text(
                                'Points',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 114, 255, 48),
                                  fontSize: 14.sp,
                                  fontFamily: 'SpaceGrotesk-Regular',
                                ),
                              ),
                            ),
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: t20teamrankingInfo.length,
                          itemBuilder: (context, index) {
                            final item = t20teamrankingInfo[index];
                            return ListTile(
                              horizontalTitleGap: 4,
                              leading: Text(
                                item.teamRank,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontFamily: 'SpaceGrotesk-Regular',
                                ),
                              ),
                              title: Text(
                                item.teamName,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: 'Mulish-ExtraBold',
                                  color: Colors.white,
                                ),
                              ),
                              trailing: Container(
                                width: 120.w,
                                child: Row(
                                  children: [
                                    Text(
                                      item.teamRating,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontFamily: 'SpaceGrotesk-Regular',
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 45.w),
                                    Text(
                                      item.teamPoints,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontFamily: 'SpaceGrotesk-Regular',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
