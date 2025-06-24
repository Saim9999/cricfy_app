import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;

import '../classes/commentary classes.dart';

class PlayerInfo {
  final String playerurl;
  final String playername;

  PlayerInfo({
    required this.playerurl,
    required this.playername,
  });
}

class CommentaryRough extends StatefulWidget {
  // final String url;
  const CommentaryRough({
    super.key,
    // required this.url
  });

  @override
  State<CommentaryRough> createState() => _CommentaryRoughState();
}

class _CommentaryRoughState extends State<CommentaryRough> {
  final List<BatterHeaderItem> batterheaderItem = [];
  final List<PlayerData> playerdata = [];
  final List<BowlerHeader> bowlerheader = [];
  final List<BowlerData> bowlerdata = [];
  final List<TimelineData> timelinedata = [];
  final List<KeyStatsData> keystatsdata = [];

  @override
  void initState() {
    super.initState();
    commentaryMatches();
  }

  Future<void> commentaryMatches() async {
    final response = await http.get(
      Uri.parse(
          'https://www.cricbuzz.com/live-cricket-scores/75493/ban-vs-ind-17th-match-icc-cricket-world-cup-2023'),
    );
    if (response.statusCode == 200) {
      final document = html.parse(response.body);

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

      final crrText =
          document.querySelector('.cb-min-bat-rw .cb-font-12.cb-text-gray');
      if (crrText != null) {
        final crrTextquery = crrText.text;
        print('crr: $crrTextquery');
      } else {
        print("No current runrate found.");
      }

      final reqText =
          document.querySelectorAll('.cb-min-bat-rw .cb-font-12.cb-text-gray');
      if (reqText.isNotEmpty && reqText.length > 1) {
        final reqTextquery = reqText[1].text;
        print('req: $reqTextquery');
      } else {
        print("No required runrate found.");
      }

      // for match start message
      final matchMessage = document.querySelector('.cb-min-stts')?.text ?? '';
      if (matchMessage.isNotEmpty) {
        print(matchMessage);
      }
      // for match start second message
      final matchMessage2nd =
          document.querySelector('.cb-toss-sts')?.text ?? '';
      if (matchMessage2nd.isNotEmpty) {
        print(matchMessage2nd);
      }

      // for player motm and mots message
      final playerMotm = document.querySelector('.cb-mom-itm');
      if (playerMotm != null) {
        final playerMotmLabel = playerMotm.querySelector('span')?.text ?? '';
        final playerMotmValue =
            playerMotm.querySelector('.cb-link-undrln')?.text ?? '';

        print(playerMotmLabel);
        print(playerMotmValue);
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
      } else {
        print("No playerMots found or not enough elements in the list.");
      }

      // for batter header
      final headerRow =
          document.querySelector('.cb-col.cb-col-100.cb-min-hdr-rw.cb-bg-gray');
      if (headerRow != null) {
        final headerColumns = headerRow.querySelectorAll('.cb-col');
        final batterHeader = headerColumns[0].text;
        final runsHeader = headerColumns[1].text;
        final ballsHeader = headerColumns[2].text;
        final foursHeader = headerColumns[3].text;
        final sixesHeader = headerColumns[4].text;
        final strikeRateHeader = headerColumns[5].text;

        print(
            'Batter Header: $batterHeader $runsHeader $ballsHeader $foursHeader $sixesHeader $strikeRateHeader');

        batterheaderItem.add(BatterHeaderItem(
          batterHeader: batterHeader,
          // runsHeader: runsHeader,
          // ballsHeader: ballsHeader,
          // foursHeader: foursHeader,
          // sixesHeader: sixesHeader,
          // strikeRateHeader: strikeRateHeader
        ));
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

          final ballsElementList =
              playerElement.querySelectorAll('.ab.text-right');
          final balls = ballsElementList.length > 1
              ? ballsElementList[1].text.trim()
              : '';

          final textRightElements =
              playerElement.querySelectorAll('.ab.text-right');
          final fours = textRightElements.length > 2
              ? textRightElements[2].text.trim()
              : '';

          final cbColElements =
              playerElement.querySelectorAll('.ab.text-right');
          final sixes =
              cbColElements.length > 3 ? cbColElements[3].text.trim() : '';

          final strikeRateElements =
              playerElement.querySelectorAll('.ab.text-right');
          final strikeRate = strikeRateElements.length > 4
              ? strikeRateElements[4].text.trim()
              : '';

          final playerUrl =
              playerElement.querySelector('a.cb-text-link')!.attributes['href'];
          print('Player Url: ${playerUrl.toString()}');

          final response =
              await http.get(Uri.parse('https://cricbuzz.com$playerUrl'));

          if (response.statusCode == 200) {
            final document = html.parse(response.body);
            final playerName =
                document.querySelector('h1[itemprop="name"]')?.text ?? '';
            final playerCountry =
                document.querySelector('h3.cb-font-18.text-gray')?.text ?? '';
            final profileImage = document
                    .querySelector('img[title="profile image"]')
                    ?.attributes['src'] ??
                '';

            print('Player Name: $playerName');
            print('Player Country: $playerCountry');
            print('Profile Image URL: $profileImage');

            playerdata.add(PlayerData(
              playername: playerName,
              playerimage: profileImage,
              playercountry: playerCountry,
              playerprofileurl: playerUrl!,
              runs: runs,
              ballsfaced: balls,
              fours: fours,
              sixes: sixes,
              strikerate: strikeRate,
            ));
          } else {
            print('Failed to fetch matches: ${response.statusCode}');
          }
          print(
              'Player Name: $playerName $runs $balls $fours $sixes $strikeRate');
        }
      }

      // for bowler header
      final bowlerheaderRows = document
          .querySelectorAll('.cb-col.cb-col-100.cb-min-hdr-rw.cb-bg-gray');

      if (bowlerheaderRows.isNotEmpty) {
        final bowlerheaderRow = bowlerheaderRows[1];
        final bowlerheaderColumns = bowlerheaderRow.querySelectorAll('.cb-col');

        if (bowlerheaderColumns.length >= 6) {
          final bowlerHeader = bowlerheaderColumns[0].text;
          final oversHeader = bowlerheaderColumns[1].text;
          final maidensHeader = bowlerheaderColumns[2].text;
          final runsHeader = bowlerheaderColumns[3].text;
          final wicketsHeader = bowlerheaderColumns[4].text;
          final economyHeader = bowlerheaderColumns[5].text;

          print(
              'Bowler Header: $bowlerHeader $oversHeader $maidensHeader $runsHeader $wicketsHeader $economyHeader');

          bowlerheader.add(BowlerHeader(
            bowlerHeader: bowlerHeader,
            // oversHeader: oversHeader,
            // maidensHeader: maidensHeader,
            // runsHeader: runsHeader,
            // wicketsHeader: wicketsHeader,
            // economyHeader: economyHeader
          ));
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

          final response =
              await http.get(Uri.parse('https://cricbuzz.com$playerUrl'));

          if (response.statusCode == 200) {
            final document = html.parse(response.body);
            final playerName =
                document.querySelector('h1[itemprop="name"]')?.text ?? '';
            final playerCountry =
                document.querySelector('h3.cb-font-18.text-gray')?.text ?? '';
            final profileImage = document
                    .querySelector('img[title="profile image"]')
                    ?.attributes['src'] ??
                '';

            print('Player Name: $playerName');
            print('Player Country: $playerCountry');
            print('Profile Image URL: $profileImage');

            bowlerdata.add(BowlerData(
                bowlername: bowlerName,
                bowlercountry: playerCountry,
                bnowlerimage: profileImage,
                bowlerprofileurl: playerUrl!,
                overs: overs,
                maidens: maidens,
                runs: runsGiven,
                wickets: wickets,
                economy: economy));
          }

          print(
              'Bowler Data: $bowlerName $overs $maidens $runsGiven $wickets $economy');
        }
      }

      // for key stats
      final keystatsElement =
          document.querySelector('.cb-col.cb-col-33.cb-key-st-lst');

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

      // for recent timeline
      final recentTimeline = document.querySelector('.cb-min-rcnt');
      if (recentTimeline != null) {
        final recentTimelineElement =
            recentTimeline.querySelector('span.text-bold');
        final recentTimelineText = recentTimelineElement?.text ?? '';
        final recentTimelineValue =
            recentTimelineElement!.nextElementSibling?.text ?? '';
        print(recentTimelineText);
        print(recentTimelineValue);

        timelinedata.add(TimelineData(
            recentTimelineText: recentTimelineText,
            recentTimelineValue: recentTimelineValue));
      }
      setState(() {});
    } else {
      print('Failed to fetch matches: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Commentary Card'),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 10.h,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: batterheaderItem.length,
            itemBuilder: (context, index) {
              final item = batterheaderItem[index];
              return Row(
                children: [
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(item.batterHeader),
                  SizedBox(
                    width: 10.w,
                  ),
                  // Text(item.runsHeader),
                  SizedBox(
                    width: 10.w,
                  ),
                  // Text(item.ballsHeader),
                  SizedBox(
                    width: 10.w,
                  ),
                  // Text(item.foursHeader),
                  // SizedBox(
                  //   width: 10.w,
                  // ),
                  // Text(item.sixesHeader),
                  // SizedBox(
                  //   width: 10.w,
                  // ),
                  // Text(item.strikeRateHeader),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: playerdata.length,
            itemBuilder: (context, index) {
              final item = playerdata[index];
              return Container(
                width: double.infinity,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://www.cricbuzz.com/${item.playerimage}'),
                  ),
                  // leading: Image.network(
                  //   'https://www.cricbuzz.com/${item.playerimage}',
                  //   errorBuilder: (context, error, stackTrace) {
                  //     return Image.asset(
                  //       'assets/images/news_logo.jpg', // Replace with your fallback image
                  //     );
                  //   },
                  // ),
                  title: Text(item.playername),
                  subtitle: Text(item.playercountry),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(item.runs),
                      SizedBox(width: 10.w),
                      Text(item.ballsfaced),
                      SizedBox(width: 10.w),
                      Text(item.fours),
                      SizedBox(width: 10.w),
                      Text(item.sixes),
                      SizedBox(width: 10.w),
                      Text(item.strikerate),
                    ],
                  ),
                ),
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: bowlerheader.length,
            itemBuilder: (context, index) {
              final item = bowlerheader[index];
              return Row(
                children: [
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(item.bowlerHeader),
                  SizedBox(
                    width: 10.w,
                  ),
                  // Text(item.oversHeader),
                  // SizedBox(
                  //   width: 10.w,
                  // ),
                  // Text(item.maidensHeader),
                  // SizedBox(
                  //   width: 10.w,
                  // ),
                  // Text(item.runsHeader),
                  // SizedBox(
                  //   width: 10.w,
                  // ),
                  // Text(item.wicketsHeader),
                  // SizedBox(
                  //   width: 10.w,
                  // ),
                  // Text(item.economyHeader),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: bowlerdata.length,
            itemBuilder: (context, index) {
              final item = bowlerdata[index];
              return Container(
                width: double.infinity,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://www.cricbuzz.com/${item.bnowlerimage}'),
                  ),
                  title: Text(item.bowlername),
                  subtitle: Text(item.bowlercountry),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(item.overs),
                      SizedBox(width: 10.w),
                      Text(item.maidens),
                      SizedBox(width: 10.w),
                      Text(item.runs),
                      SizedBox(width: 10.w),
                      Text(item.wickets),
                      SizedBox(width: 10.w),
                      Text(item.economy),
                    ],
                  ),
                ),
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: timelinedata.length,
            itemBuilder: (context, index) {
              final item = timelinedata[index];
              return ListTile(
                title: Text(item.recentTimelineText),
                subtitle: Text(item.recentTimelineValue),
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: keystatsdata.length,
            itemBuilder: (context, index) {
              final item = keystatsdata[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.keystatsLabel),
                  // Text('${item.partnershipLable} ${item.partnershipValue}'),
                  // Text('${item.lastwicketpLable} ${item.lastwicketValue}'),
                  // Text('${item.last5oversLable}: ${item.last5overValue}'),
                  // Text('${item.tossLable} ${item.tossValue}'),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
