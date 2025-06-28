// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../classes/commentary classes.dart';

class PlayerRanking extends StatefulWidget {
  final String url1;
  final String url2;
  const PlayerRanking({super.key, required this.url1, required this.url2});

  @override
  State<PlayerRanking> createState() => _PlayerRankingState();
}

class _PlayerRankingState extends State<PlayerRanking> {
  final List<TestRankingInfo> testrankingInfo = [];
  final List<ODIRankingInfo> odirankingInfo = [];
  final List<T20RankingInfo> t20rankingInfo = [];

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

    final response = await http.get(Uri.parse(widget.url1));

    if (response.statusCode == 200) {
      final document = html.parse(response.body);

      final batsmenTestsDiv = document.querySelector(
        '.cb-col.cb-col-100.cb-padding-left0[ng-show="\'${widget.url2}-tests\' == act_rank_format"]',
      );
      final batsmenODIsDiv = document.querySelector(
        '.cb-col.cb-col-100.cb-padding-left0[ng-show="\'${widget.url2}-odis\' == act_rank_format"]',
      );
      final batsmenT20sDiv = document.querySelector(
        '.cb-col.cb-col-100.cb-padding-left0[ng-show="\'${widget.url2}-t20s\' == act_rank_format"]',
      );

      // Check if elements are found before using them
      if (batsmenTestsDiv != null) {
        final playerRankTests = batsmenTestsDiv.querySelectorAll(
          '.cb-col.cb-col-16.cb-rank-tbl.cb-font-16',
        );
        final playerNameTests = batsmenTestsDiv.querySelectorAll(
          '.cb-rank-plyr a',
        );
        final playerCountryTests = batsmenTestsDiv.querySelectorAll(
          '.cb-font-12.text-gray',
        );
        final playerImageTests = batsmenTestsDiv.querySelectorAll(
          '.img-responsive.cb-rank-plyr-img',
        );
        final playerRankValueTests = batsmenTestsDiv.querySelectorAll(
          '.cb-col.cb-col-17.cb-rank-tbl.pull-right',
        );
        final playerUrlTests = batsmenTestsDiv.querySelectorAll(
          '.cb-col.cb-col-67.cb-rank-plyr a',
        );

        final List<String> allPlayerRanks =
            playerRankTests.map((element) => element.text).toList();
        final List<String> allPlayerNames =
            playerNameTests.map((element) => element.text).toList();
        final List<String> allCountryNames =
            playerCountryTests.map((element) => element.text).toList();
        final List<String> allRatings =
            playerRankValueTests.map((element) => element.text).toList();
        final List<String?> allPlayerImages =
            playerImageTests
                .map((element) => element.attributes['src'])
                .toList();
        final List<String?> allPlayerUrls =
            playerUrlTests
                .map((element) => element.attributes['href'])
                .toList();

        for (var i = 0; i < allPlayerNames.length; i++) {
          if (i < 10) {
            testrankingInfo.add(
              TestRankingInfo(
                playerRank: allPlayerRanks[i],
                playerName: allPlayerNames[i],
                countryName: allCountryNames[i],
                playerRating: allRatings[i],
                imageUrl: allPlayerImages[i]!,
                playerUrl: allPlayerUrls[i]!,
              ),
            );

            print('Tests - Player Name: ${allPlayerNames[i]}');
          }
        }
      }

      if (batsmenODIsDiv != null) {
        final playerRankODI = batsmenODIsDiv.querySelectorAll(
          '.cb-col.cb-col-16.cb-rank-tbl.cb-font-16',
        );
        final playerNameODI = batsmenODIsDiv.querySelectorAll(
          '.cb-rank-plyr a',
        );
        final playerCountryODI = batsmenODIsDiv.querySelectorAll(
          '.cb-font-12.text-gray',
        );
        final playerImageODI = batsmenODIsDiv.querySelectorAll(
          '.img-responsive.cb-rank-plyr-img',
        );
        final playerRankValueODI = batsmenODIsDiv.querySelectorAll(
          '.cb-col.cb-col-17.cb-rank-tbl.pull-right',
        );
        final playerUrlODI = batsmenODIsDiv.querySelectorAll(
          '.cb-col.cb-col-67.cb-rank-plyr a',
        );

        final List<String> allPlayerRanks =
            playerRankODI.map((element) => element.text).toList();
        final List<String> allPlayerNames =
            playerNameODI.map((element) => element.text).toList();
        final List<String> allCountryNames =
            playerCountryODI.map((element) => element.text).toList();
        final List<String> allRatings =
            playerRankValueODI.map((element) => element.text).toList();
        final List<String?> allPlayerImages =
            playerImageODI.map((element) => element.attributes['src']).toList();
        final List<String?> allPlayerUrls =
            playerUrlODI.map((element) => element.attributes['href']).toList();

        for (var i = 0; i < allPlayerNames.length; i++) {
          if (i < 10) {
            odirankingInfo.add(
              ODIRankingInfo(
                playerRank: allPlayerRanks[i],
                playerName: allPlayerNames[i],
                countryName: allCountryNames[i],
                playerRating: allRatings[i],
                imageUrl: allPlayerImages[i]!,
                playerUrl: allPlayerUrls[i]!,
              ),
            );
          }
        }
      }

      if (batsmenT20sDiv != null) {
        final playerRankT20 = batsmenT20sDiv.querySelectorAll(
          '.cb-col.cb-col-16.cb-rank-tbl.cb-font-16',
        );
        final playerNameT20 = batsmenT20sDiv.querySelectorAll(
          '.cb-rank-plyr a',
        );
        final playerCountryT20 = batsmenT20sDiv.querySelectorAll(
          '.cb-font-12.text-gray',
        );
        final playerImageT20 = batsmenT20sDiv.querySelectorAll(
          '.img-responsive.cb-rank-plyr-img',
        );
        final playerRankValueT20 = batsmenT20sDiv.querySelectorAll(
          '.cb-col.cb-col-17.cb-rank-tbl.pull-right',
        );
        final playerUrlT20 = batsmenT20sDiv.querySelectorAll(
          '.cb-col.cb-col-67.cb-rank-plyr a',
        );

        final List<String> allPlayerRanks =
            playerRankT20.map((element) => element.text).toList();
        final List<String> allPlayerNames =
            playerNameT20.map((element) => element.text).toList();
        final List<String> allCountryNames =
            playerCountryT20.map((element) => element.text).toList();
        final List<String> allRatings =
            playerRankValueT20.map((element) => element.text).toList();
        final List<String?> allPlayerImages =
            playerImageT20.map((element) => element.attributes['src']).toList();
        final List<String?> allPlayerUrls =
            playerUrlT20.map((element) => element.attributes['href']).toList();

        for (var i = 0; i < allPlayerNames.length; i++) {
          if (i < 10) {
            t20rankingInfo.add(
              T20RankingInfo(
                playerRank: allPlayerRanks[i],
                playerName: allPlayerNames[i],
                countryName: allCountryNames[i],
                playerRating: allRatings[i],
                imageUrl: allPlayerImages[i]!,
                playerUrl: allPlayerUrls[i]!,
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
            'Player Rankings',
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
                    : ListView.builder(
                      itemCount: testrankingInfo.length,
                      itemBuilder: (context, index) {
                        final item = testrankingInfo[index];
                        return ListTile(
                          onTap: () async {
                            // Launch the player's profile URL in the web browser
                            var playerProfileUri = Uri.parse(
                              'https://www.cricbuzz.com/${item.playerUrl}',
                            );
                            if (await canLaunchUrl(playerProfileUri)) {
                              await launchUrl(playerProfileUri);
                            } else {
                              print("Could not launch player profile.");
                            }
                          },
                          leading: Container(
                            width: 70.w,
                            height: 65.h,
                            child: Row(
                              children: [
                                Text(
                                  item.playerRank,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontFamily: 'SpaceGrotesk-Regular',
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                CircleAvatar(
                                  // radius: 20,
                                  backgroundImage: NetworkImage(item.imageUrl),
                                ),
                              ],
                            ),
                          ),
                          title: Text(
                            item.playerName,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: 'Mulish-ExtraBold',
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            item.countryName,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'SpaceGrotesk-Regular',
                              color: Colors.grey,
                            ),
                          ),
                          trailing: Text(
                            item.playerRating,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'SpaceGrotesk-Regular',
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                isLoading
                    ? Center(
                      child: LoadingAnimationWidget.horizontalRotatingDots(
                        size: 50,
                        color: Color.fromARGB(255, 114, 255, 48),
                      ),
                    )
                    : ListView.builder(
                      itemCount: odirankingInfo.length,
                      itemBuilder: (context, index) {
                        final item = odirankingInfo[index];

                        return ListTile(
                          onTap: () async {
                            // Launch the player's profile URL in the web browser
                            var playerProfileUri = Uri.parse(
                              'https://www.cricbuzz.com/${item.playerUrl}',
                            );
                            if (await canLaunchUrl(playerProfileUri)) {
                              await launchUrl(playerProfileUri);
                            } else {
                              print("Could not launch player profile.");
                            }
                          },
                          leading: Container(
                            width: 70.w,
                            height: 65.h,
                            child: Row(
                              children: [
                                Text(
                                  item.playerRank,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontFamily: 'SpaceGrotesk-Regular',
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                CircleAvatar(
                                  // radius: 20,
                                  backgroundImage: NetworkImage(item.imageUrl),
                                ),
                              ],
                            ),
                          ),
                          title: Text(
                            item.playerName,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: 'Mulish-ExtraBold',
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            item.countryName,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'SpaceGrotesk-Regular',
                              color: Colors.grey,
                            ),
                          ),
                          trailing: Text(
                            item.playerRating,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'SpaceGrotesk-Regular',
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                isLoading
                    ? Center(
                      child: LoadingAnimationWidget.horizontalRotatingDots(
                        size: 50,
                        color: Color.fromARGB(255, 114, 255, 48),
                      ),
                    )
                    : ListView.builder(
                      itemCount: t20rankingInfo.length,
                      itemBuilder: (context, index) {
                        final item = t20rankingInfo[index];
                        // Split the player name , country name and rating
                        // List<String> parts =
                        //     t20PlayerNames[index].split(' - Rating: ');
                        // String playerAndCountry = parts[0];
                        // String rating = parts[1];

                        // List<String> playerAndCountryParts =
                        //     playerAndCountry.split(' (');
                        // String playerName = playerAndCountryParts[0];
                        // String countryName = playerAndCountryParts[1]
                        //     .substring(
                        //         0, playerAndCountryParts[1].length - 1);
                        return ListTile(
                          onTap: () async {
                            // Launch the player's profile URL in the web browser
                            var playerProfileUri = Uri.parse(
                              'https://www.cricbuzz.com/${item.playerUrl}',
                            );
                            if (await canLaunchUrl(playerProfileUri)) {
                              await launchUrl(playerProfileUri);
                            } else {
                              print("Could not launch player profile.");
                            }
                          },
                          leading: Container(
                            width: 70.w,
                            height: 65.h,
                            child: Row(
                              children: [
                                Text(
                                  item.playerRank,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontFamily: 'SpaceGrotesk-Regular',
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                CircleAvatar(
                                  backgroundImage: NetworkImage(item.imageUrl),
                                ),
                              ],
                            ),
                          ),
                          title: Text(
                            item.playerName,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: 'Mulish-ExtraBold',
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            item.countryName,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'SpaceGrotesk-Regular',
                              color: Colors.grey,
                            ),
                          ),
                          trailing: Text(
                            item.playerRating,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'SpaceGrotesk-Regular',
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
