import 'package:crickfy_app/screens/scorecard/scorecard_screen.dart';
import 'package:crickfy_app/screens/scorecard/squad_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../classes/commentary classes.dart';
import '../../classes/scorecard_classes.dart';
import '../../utils/text_style.dart';
import 'match_info_screen.dart';

class CompleteScore extends StatefulWidget {
  final String url1;
  final String url2;
  final String url3;
  const CompleteScore({
    super.key,
    required this.url1,
    required this.url2,
    required this.url3,
  });

  @override
  State<CompleteScore> createState() => _CompleteScoreState();
}

class _CompleteScoreState extends State<CompleteScore> {
  final List<TeamScore> teamScores = [];
  final List<MatchStatus> matchStatus = [];
  final List<CurrentRate> currentRate = [];
  final List<RequiredRate> reqRate = [];
  final List<PlayerOfMatch> playerofMatch = [];
  final List<PlayerOfSeries> playerofSeries = [];
  final List<BatterHeaderItem> batterheaderItem = [];
  final List<PlayerData> playerdata = [];
  final List<BowlerHeader> bowlerheader = [];
  final List<BowlerData> bowlerdata = [];
  final List<TimelineData> timelinedata = [];
  final List<KeyStatsData> keystatsdata = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    scorecardMatches();
  }

  Future<void> scorecardMatches() async {
    if (!mounted) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    final response1 = await http.get(Uri.parse(widget.url1));
    if (response1.statusCode == 200) {
      final document = html.parse(response1.body);

      // for Teams score, current & required runrate and match status
      final scoreText =
          document.querySelector('.cb-text-gray.cb-font-16')?.text ?? '';
      final teamScoreText =
          document.querySelector('.cb-font-20.text-bold')?.text ?? '';

      final inProgressText =
          document.querySelector('.cb-text-inprogress')?.text ?? '';

      print('first team: $scoreText');
      print('second team: $teamScoreText');
      print('match status: $inProgressText');

      teamScores.add(
        TeamScore(teamscorefirst: scoreText, teamscoreSecond: teamScoreText),
      );

      final crrText = document.querySelector(
        '.cb-min-bat-rw .cb-font-12.cb-text-gray',
      );
      if (crrText != null) {
        final crrTextquery = crrText.text.toString();
        print('crr: $crrTextquery');
        currentRate.add(CurrentRate(currRate: crrTextquery));
      } else {
        print("No current runrate found.");
      }

      final reqText = document.querySelectorAll(
        '.cb-min-bat-rw .cb-font-12.cb-text-gray',
      );
      if (reqText.isNotEmpty && reqText.length > 1) {
        final reqTextquery = reqText[1].text;
        print('req: $reqTextquery');
        reqRate.add(RequiredRate(reqRate: reqTextquery));
      } else {
        print("No required runrate found.");
      }

      // for match status
      final matchstatus =
          document.querySelector('.cb-scrcrd-status')?.text ?? '';
      print("Match Status: $matchstatus");
      matchStatus.add(MatchStatus(matchStatus: matchstatus));

      // for player motm and mots message
      final playerMotm = document.querySelector('.cb-mom-itm');
      if (playerMotm != null) {
        final playerMotmLabel = playerMotm.querySelector('span')?.text ?? '';
        final playerMotmValue =
            playerMotm.querySelector('.cb-link-undrln')?.text ?? '';

        print(playerMotmLabel);
        print(playerMotmValue);
        playerofMatch.add(
          PlayerOfMatch(
            playerMotmLabel: playerMotmLabel,
            playerMotmValue: playerMotmValue,
          ),
        );
      }

      final playerMots = document.querySelectorAll('.cb-mom-itm');
      if (playerMots.isNotEmpty && playerMots.length > 1) {
        final playerMotsquery = playerMots[1];
        final playerMotsLabel =
            playerMotsquery.querySelector('span')?.text ?? '';
        final playerMotsValue =
            playerMotsquery.querySelector('.cb-link-undrln')?.text ?? '';

        print(playerMotsLabel);
        print(playerMotsValue);
        playerofSeries.add(
          PlayerOfSeries(
            playerMotsLabel: playerMotsLabel,
            playerMotsValue: playerMotsValue,
          ),
        );
      } else {
        print("No playerMots found or not enough elements in the list.");
      }

      // for batter header
      final headerRow = document.querySelector(
        '.cb-col.cb-col-100.cb-min-hdr-rw.cb-bg-gray',
      );
      if (headerRow != null) {
        final headerColumns = headerRow.querySelectorAll('.cb-col');
        final batterHeader = headerColumns[0].text;
        print('Batter Header: $batterHeader');

        batterheaderItem.add(BatterHeaderItem(batterHeader: batterHeader));
      }

      // for batter data
      final extradiv = document.querySelector('.cb-min-inf');
      if (extradiv != null) {
        final players = extradiv.querySelectorAll('.cb-min-itm-rw');

        for (var playerElement in players) {
          final playerName =
              playerElement.querySelector('a.cb-text-link')?.text.trim() ?? '';

          // Skip players with empty names
          if (playerName.isEmpty) {
            continue;
          }

          final runsElements = playerElement.querySelectorAll('.ab.text-right');
          final runs =
              runsElements.isNotEmpty ? runsElements[0].text.trim() : '';

          final ballsElementList = playerElement.querySelectorAll(
            '.ab.text-right',
          );
          final balls =
              ballsElementList.length > 1
                  ? ballsElementList[1].text.trim()
                  : '';

          final textRightElements = playerElement.querySelectorAll(
            '.ab.text-right',
          );
          final fours =
              textRightElements.length > 2
                  ? textRightElements[2].text.trim()
                  : '';

          final cbColElements = playerElement.querySelectorAll(
            '.ab.text-right',
          );
          final sixes =
              cbColElements.length > 3 ? cbColElements[3].text.trim() : '';

          final strikeRateElements = playerElement.querySelectorAll(
            '.ab.text-right',
          );
          final strikeRate =
              strikeRateElements.length > 4
                  ? strikeRateElements[4].text.trim()
                  : '';

          final playerUrl =
              playerElement.querySelector('a.cb-text-link')!.attributes['href'];
          print('Player Url: ${playerUrl.toString()}');

          final response = await http.get(
            Uri.parse('https://cricbuzz.com$playerUrl'),
          );

          if (response.statusCode == 200) {
            final document = html.parse(response.body);
            final playerName =
                document.querySelector('h1[itemprop="name"]')?.text ?? '';
            final playerCountry =
                document.querySelector('h3.cb-font-18.text-gray')?.text ?? '';
            final profileImage =
                document
                    .querySelector('img[title="profile image"]')
                    ?.attributes['src'] ??
                '';

            print('Player Name: $playerName');
            print('Player Country: $playerCountry');
            print('Profile Image URL: $profileImage');

            playerdata.add(
              PlayerData(
                playername: playerName,
                playerimage: profileImage,
                playercountry: playerCountry,
                playerprofileurl: playerUrl!,
                runs: runs,
                ballsfaced: balls,
                fours: fours,
                sixes: sixes,
                strikerate: strikeRate,
              ),
            );
          } else {
            print('Failed to fetch matches: ${response.statusCode}');
          }
          print(
            'Player Name: $playerName $runs $balls $fours $sixes $strikeRate',
          );
        }
      }
      // for bowler header
      final bowlerheaderRows = document.querySelectorAll(
        '.cb-col.cb-col-100.cb-min-hdr-rw.cb-bg-gray',
      );

      if (bowlerheaderRows.isNotEmpty) {
        final bowlerheaderRow = bowlerheaderRows[1];
        final bowlerheaderColumns = bowlerheaderRow.querySelectorAll('.cb-col');

        if (bowlerheaderColumns.length >= 6) {
          final bowlerHeader = bowlerheaderColumns[0].text;

          print('Bowler Header: $bowlerHeader');

          bowlerheader.add(BowlerHeader(bowlerHeader: bowlerHeader));
        }
      }
      // for bowler data
      final extradiv1s = document.querySelectorAll('.cb-min-inf');
      if (extradiv1s.isNotEmpty) {
        final extradiv1 = extradiv1s[1];
        final players = extradiv1.querySelectorAll('.cb-min-itm-rw');

        for (var playerElement in players) {
          final bowlerName =
              playerElement.querySelector('a.cb-text-link')?.text.trim() ?? '';
          final overs =
              playerElement.querySelectorAll('.text-right')[0].text.trim();
          final maidens =
              playerElement.querySelectorAll('.text-right')[1].text.trim();
          final runsGiven =
              playerElement.querySelectorAll('.text-right')[2].text.trim();
          final wickets =
              playerElement.querySelectorAll('.text-right')[3].text.trim();
          final economy =
              playerElement.querySelectorAll('.text-right')[4].text.trim();

          final playerUrl =
              playerElement.querySelector('a.cb-text-link')!.attributes['href'];
          print('Bowler Player Url: ${playerUrl.toString()}');

          final response = await http.get(
            Uri.parse('https://cricbuzz.com$playerUrl'),
          );

          if (response.statusCode == 200) {
            final document = html.parse(response.body);
            final playerName =
                document.querySelector('h1[itemprop="name"]')?.text ?? '';
            final playerCountry =
                document.querySelector('h3.cb-font-18.text-gray')?.text ?? '';
            final profileImage =
                document
                    .querySelector('img[title="profile image"]')
                    ?.attributes['src'] ??
                '';

            print('Player Name: $playerName');
            print('Player Country: $playerCountry');
            print('Profile Image URL: $profileImage');

            bowlerdata.add(
              BowlerData(
                bowlername: bowlerName,
                bowlercountry: playerCountry,
                bnowlerimage: profileImage,
                bowlerprofileurl: playerUrl!,
                overs: overs,
                maidens: maidens,
                runs: runsGiven,
                wickets: wickets,
                economy: economy,
              ),
            );
          }

          print(
            'Bowler Data: $bowlerName $overs $maidens $runsGiven $wickets $economy',
          );
        }
      }
      // for recent timeline
      final recentTimeline = document.querySelector('.cb-min-rcnt');
      if (recentTimeline != null) {
        final recentTimelineElement = recentTimeline.querySelector(
          'span.text-bold',
        );
        final recentTimelineText = recentTimelineElement?.text ?? '';
        final recentTimelineValue =
            recentTimelineElement!.nextElementSibling?.text ?? '';
        print(recentTimelineText);
        print(recentTimelineValue);

        timelinedata.add(
          TimelineData(
            recentTimelineText: recentTimelineText,
            recentTimelineValue: recentTimelineValue,
          ),
        );
      }
      // for key stats
      final keystatsElement = document.querySelector(
        '.cb-col.cb-col-33.cb-key-st-lst',
      );

      if (keystatsElement != null) {
        final keystats = keystatsElement.text
            .trim()
            .replaceAll('overs ', 'overs: ')
            .replaceAll('  ', '\n');

        print('\n$keystats');
        keystatsdata.add(KeyStatsData(keystatsLabel: keystats));
      } else {
        // Handle the case when the element is not found
        print('Keystats element not found.');
      }

      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });
    } else {
      print('Failed to fetch matches: ${response1.statusCode}');
      if (!mounted) {
        return;
      }
      setState(() {
        isLoading = false; // Set isLoading to false in case of failure
      });
    }
    //////////////////////////////////
    final response2 = await http.get(Uri.parse(widget.url2));
    if (response2.statusCode == 200) {
      final document = html.parse(response2.body);
      final matchstatus =
          document.querySelector('.cb-scrcrd-status')?.text ?? '';
      print("Match Status: $matchstatus");
      matchStatus.add(MatchStatus(matchStatus: matchstatus));

      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });
    } else {
      print('Failed to fetch matches: ${response2.statusCode}');
      if (!mounted) {
        return;
      }
      setState(() {
        isLoading = false; // Set isLoading to false in case of failure
      });
    }
  }

  Future<void> _refreshData() async {
    // For example, you can clear the existing data and fetch new data
    teamScores.clear();
    matchStatus.clear();
    currentRate.clear();
    reqRate.clear();
    playerofMatch.clear();
    playerofSeries.clear();
    batterheaderItem.clear();
    playerdata.clear();
    bowlerheader.clear();
    bowlerdata.clear();
    timelinedata.clear();
    keystatsdata.clear();

    await scorecardMatches();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 15, 19, 1),
        appBar: AppBar(
          toolbarHeight: 200.h,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leadingWidth: double.infinity,
          leading:
              isLoading
                  ? Center(
                    child: LoadingAnimationWidget.horizontalRotatingDots(
                      size: 50,
                      color: Color.fromARGB(255, 114, 255, 48),
                    ),
                  )
                  : RefreshIndicator(
                    onRefresh: _refreshData,
                    backgroundColor: Color.fromARGB(255, 15, 19, 1),
                    color: Color.fromARGB(255, 114, 255, 48),
                    child: ListView(
                      children: [
                        listbuilderMethod(
                          batterheaderItem,
                          (item) => Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              item.batterHeader,
                              style: textMethod(
                                Colors.white,
                                16.sp,
                                FontWeight.bold,
                                'Mulish-ExtraBold',
                              ),
                            ),
                          ),
                        ),
                        listbuilderMethod(
                          playerdata,
                          (item) => Container(
                            width: double.infinity,
                            child: ListTile(
                              visualDensity: VisualDensity.compact,
                              leading: InkWell(
                                onTap: () async {
                                  // Launch the player's profile URL in the web browser
                                  var playerProfileUri = Uri.parse(
                                    'https://www.cricbuzz.com/${item.playerprofileurl}',
                                  );
                                  if (await canLaunchUrl(playerProfileUri)) {
                                    await launchUrl(playerProfileUri);
                                  } else {
                                    print("Could not launch player profile.");
                                  }
                                },
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    '${item.playerimage}',
                                  ),
                                ),
                              ),
                              title: Text(
                                item.playername,
                                style: textMethod(
                                  Colors.white,
                                  12.sp,
                                  FontWeight.bold,
                                  'SpaceGrotesk-Regular',
                                ),
                              ),
                              subtitle: Text(
                                item.playercountry,
                                style: textMethod(
                                  Colors.grey,
                                  12.sp,
                                  FontWeight.bold,
                                  'SpaceGrotesk-Regular',
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    item.runs,
                                    style: textMethod(
                                      Colors.white,
                                      15.sp,
                                      FontWeight.bold,
                                      'SpaceGrotesk-Regular',
                                    ),
                                  ),
                                  SizedBox(width: 5.w),
                                  Text(
                                    '(${item.ballsfaced})',
                                    style: textMethod(
                                      Colors.grey,
                                      14.sp,
                                      FontWeight.normal,
                                      'SpaceGrotesk-Regular',
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'SR : ',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            item.strikerate,
                                            style: textMethod(
                                              Colors.grey,
                                              14.sp,
                                              FontWeight.bold,
                                              'SpaceGrotesk-Regular',
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '4s : ',
                                            style: textMethod(
                                              Colors.white,
                                              14.sp,
                                              FontWeight.normal,
                                              'SpaceGrotesk-Regular',
                                            ),
                                          ),
                                          Text(
                                            item.fours,
                                            style: textMethod(
                                              Color.fromARGB(255, 0, 166, 255),
                                              14.sp,
                                              FontWeight.normal,
                                              'SpaceGrotesk-Regular',
                                            ),
                                          ),
                                          Text(
                                            ' | 6s : ',
                                            style: textMethod(
                                              Colors.white,
                                              14.sp,
                                              FontWeight.normal,
                                              'SpaceGrotesk-Regular',
                                            ),
                                          ),
                                          Text(
                                            item.sixes,
                                            style: textMethod(
                                              Color.fromARGB(255, 255, 217, 0),
                                              14.sp,
                                              FontWeight.bold,
                                              'SpaceGrotesk-Regular',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        listbuilderMethod(
                          bowlerheader,
                          (item) => Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              item.bowlerHeader,
                              style: textMethod(
                                Colors.white,
                                16.sp,
                                FontWeight.bold,
                                'Mulish-ExtraBold',
                              ),
                            ),
                          ),
                        ),
                        listbuilderMethod(
                          bowlerdata,
                          (item) => Container(
                            width: double.infinity,
                            child: ListTile(
                              visualDensity: VisualDensity.compact,
                              leading: InkWell(
                                onTap: () async {
                                  // Launch the player's profile URL in the web browser
                                  var playerProfileUri = Uri.parse(
                                    'https://www.cricbuzz.com/${item.bowlerprofileurl}',
                                  );
                                  if (await canLaunchUrl(playerProfileUri)) {
                                    await launchUrl(playerProfileUri);
                                  } else {
                                    print("Could not launch player profile.");
                                  }
                                  print(
                                    'Bowler Profile Url: ${item.bowlerprofileurl}',
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    '${item.bnowlerimage}',
                                  ),
                                ),
                              ),
                              title: Text(
                                item.bowlername,
                                style: textMethod(
                                  Colors.white,
                                  12.sp,
                                  FontWeight.bold,
                                  'SpaceGrotesk-Regular',
                                ),
                              ),
                              subtitle: Text(
                                item.bowlercountry,
                                style: textMethod(
                                  Colors.grey,
                                  12.sp,
                                  FontWeight.bold,
                                  'SpaceGrotesk-Regular',
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    item.runs,
                                    style: textMethod(
                                      Colors.white,
                                      15.sp,
                                      FontWeight.bold,
                                      'SpaceGrotesk-Regular',
                                    ),
                                  ),
                                  SizedBox(width: 5.w),
                                  Text(
                                    '(${item.overs} Ov.)',
                                    style: textMethod(
                                      Colors.grey,
                                      14.sp,
                                      FontWeight.normal,
                                      'SpaceGrotesk-Regular',
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'ECO : ',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            item.economy,
                                            style: textMethod(
                                              Colors.grey,
                                              14.sp,
                                              FontWeight.bold,
                                              'SpaceGrotesk-Regular',
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'W : ',
                                            style: textMethod(
                                              Colors.white,
                                              14.sp,
                                              FontWeight.normal,
                                              'SpaceGrotesk-Regular',
                                            ),
                                          ),
                                          Text(
                                            item.wickets,
                                            style: textMethod(
                                              Colors.red,
                                              14.sp,
                                              FontWeight.normal,
                                              'SpaceGrotesk-Regular',
                                            ),
                                          ),
                                          Text(
                                            ' | M : ',
                                            style: textMethod(
                                              Colors.white,
                                              14.sp,
                                              FontWeight.normal,
                                              'SpaceGrotesk-Regular',
                                            ),
                                          ),
                                          Text(
                                            item.maidens,
                                            style: textMethod(
                                              Colors.deepPurple,
                                              14.sp,
                                              FontWeight.bold,
                                              'SpaceGrotesk-Regular',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        listbuilderMethod(
                          timelinedata,
                          (item) => Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Column(
                              children: [
                                Text(
                                  item.recentTimelineText,
                                  style: textMethod(
                                    Colors.white,
                                    16.sp,
                                    FontWeight.bold,
                                    'Mulish-ExtraBold',
                                  ),
                                ),
                                Text(
                                  item.recentTimelineValue,
                                  style: textMethod(
                                    Colors.grey,
                                    14.sp,
                                    FontWeight.normal,
                                    'SpaceGrotesk-Regular',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: listbuilderMethod(
                                  teamScores,
                                  (item) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.teamscoreSecond,
                                        style: textMethod(
                                          Colors.white,
                                          14.sp,
                                          FontWeight.bold,
                                          'SpaceGrotesk-Regular',
                                        ),
                                      ),
                                      Text(
                                        item.teamscorefirst,
                                        style: textMethod(
                                          Colors.white,
                                          14.sp,
                                          FontWeight.bold,
                                          'SpaceGrotesk-Regular',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    listbuilderMethod(
                                      currentRate,
                                      (item) => Column(
                                        children: [
                                          Text(
                                            item.currRate,
                                            style: textMethod(
                                              Colors.white,
                                              14.sp,
                                              FontWeight.normal,
                                              'SpaceGrotesk-Regular',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    listbuilderMethod(
                                      reqRate,
                                      (item) => Column(
                                        children: [
                                          Text(
                                            item.reqRate,
                                            style: textMethod(
                                              Colors.white,
                                              14.sp,
                                              FontWeight.normal,
                                              'SpaceGrotesk-Regular',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: listbuilderMethod(
                                  keystatsdata,
                                  (item) => TextButton(
                                    onPressed: () {
                                      Get.defaultDialog(
                                        content: Text(
                                          item.keystatsLabel,
                                          style: textMethod(
                                            Colors.black,
                                            18.sp,
                                            FontWeight.normal,
                                            'Mulish-ExtraBold',
                                          ),
                                        ),
                                        title: '',
                                        titleStyle: TextStyle(fontSize: 1.sp),
                                      );
                                    },
                                    child: Text(
                                      'Key Stats',
                                      style: TextStyle(
                                        color: Color.fromARGB(
                                          255,
                                          114,
                                          255,
                                          48,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        listbuilderMethod(
                          playerofMatch,
                          (item) => Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Text(
                              '${item.playerMotmLabel} : ${item.playerMotmValue}',
                              style: textMethod(
                                Colors.white,
                                14.sp,
                                FontWeight.bold,
                                'SpaceGrotesk-Regular',
                              ),
                            ),
                          ),
                        ),
                        listbuilderMethod(
                          playerofSeries,
                          (item) => Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Text(
                              '${item.playerMotsLabel} : ${item.playerMotsValue}',
                              style: textMethod(
                                Colors.white,
                                14.sp,
                                FontWeight.bold,
                                'SpaceGrotesk-Regular',
                              ),
                            ),
                          ),
                        ),
                        listbuilderMethod(
                          matchStatus,
                          (item) => Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Column(
                              children: [
                                Text(
                                  item.matchStatus,
                                  style: textMethod(
                                    Colors.white,
                                    14.sp,
                                    FontWeight.bold,
                                    'SpaceGrotesk-Regular',
                                  ),
                                ),
                                Divider(color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white10,
            indicatorColor: const Color.fromARGB(255, 114, 255, 48),
            tabs: [
              Tab(
                child: Text(
                  'Scorecard',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'SpaceGrotesk-Regular',
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Squads',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'SpaceGrotesk-Regular',
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Match Info',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'SpaceGrotesk-Regular',
                  ),
                ),
              ),
            ],
          ), // TabBar
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
                ScoreCardScreen(url: widget.url2),
                SquadInfo(url: widget.url3),
                MatchInfo(url: widget.url2),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
