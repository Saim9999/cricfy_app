import 'package:crickfy_app/classes/scorecard_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:intl/intl.dart';

class ScorecardRough extends StatefulWidget {
  final String url;

  const ScorecardRough({
    super.key,
    required this.url,
  });

  @override
  State<ScorecardRough> createState() => _ScorecardRoughState();
}

class _ScorecardRoughState extends State<ScorecardRough> {
  final List<MatchStatus> matchStatus = [];
  final List<MatchItem> matchItems = [];
  final List<SquadItem> squadItems = [];

  final List<SecondScoreHeaderItem> secondscoreHeaderItems = [];
  final List<SecondScorecardItem> secondscorecardItems = [];
  final List<SecondTotalScoreItem> secondtotalscoreItems = [];
  final List<SecondBowlerHeaderItem> secondbowlerHeaderItems = [];
  final List<SecondBowlerDataItem> secondbowlerDataItems = [];
  final List<SecondPowerPlayItem> secondpowerplayItems = [];
  final List<SecondPowerPlayDataItem> secondpowerplayDataItems = [];

  final List<FirstScoreHeaderItem> firstscoreHeaderItems = [];
  final List<FirstScorecardItem> firstscorecardItems = [];
  final List<FirstTotalScoreItem> firsttotalscoreItems = [];
  final List<FirstBowlerHeaderItem> firstbowlerHeaderItems = [];
  final List<FirstBowlerDataItem> firstbowlerDataItems = [];
  final List<FirstPowerPlayItem> firstpowerplayItems = [];
  final List<FirstPowerPlayDataItem> firstpowerplayDataItems = [];

  final List<ThirdScoreHeaderItem> thirdscoreHeaderItems = [];
  final List<ThirdScorecardItem> thirdscorecardItems = [];
  final List<ThirdTotalScoreItem> thirdtotalscoreItems = [];
  final List<ThirdBowlerHeaderItem> thirdbowlerHeaderItems = [];
  final List<ThirdBowlerDataItem> thirdbowlerDataItems = [];

  final List<FourthScoreHeaderItem> fourthscoreHeaderItems = [];
  final List<FourthScorecardItem> fourthscorecardItems = [];
  final List<FourthTotalScoreItem> fourthtotalscoreItems = [];
  final List<FourthBowlerHeaderItem> fourthbowlerHeaderItems = [];
  final List<FourthBowlerDataItem> fourthbowlerDataItems = [];

  @override
  void initState() {
    super.initState();
    scorecardMatches();
  }

  Future<void> scorecardMatches() async {
    if (!mounted) {
      // Check if the widget is still mounted before proceeding
      return;
    }
    final response = await http.get(
      Uri.parse(widget.url),
    );
    if (response.statusCode == 200) {
      final document = html.parse(response.body);

      // for match status
      final matchstatus =
          document.querySelector('.cb-scrcrd-status')?.text ?? '';
      print("Match Status: $matchstatus");
      matchStatus.add(MatchStatus(matchStatus: matchstatus));

      final matchCardElements = document
          .querySelectorAll('.cb-col.cb-col-67.cb-scrd-lft-col.html-refresh');

      // for match info
      for (var matchCardElement in matchCardElements) {
        final matchInfoElements =
            matchCardElement.querySelectorAll('.cb-mtch-info-itm');

        String matchLabel = '';
        String matchValue = '';

        for (var matchInfoElement in matchInfoElements) {
          final labelElement = matchInfoElement.querySelector('.cb-col-27');
          final valueElement = matchInfoElement.querySelector('.cb-col-73');

          if (labelElement != null && valueElement != null) {
            matchLabel = labelElement.text;
            matchValue = valueElement.text;

            if (matchLabel == 'Date' || matchLabel == 'Time') {
              final timestamp = valueElement
                  .querySelector('.schedule-date')
                  ?.attributes['timestamp'];
              if (timestamp != null) {
                final dateTime =
                    DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
                matchValue = matchLabel == 'Date'
                    ? DateFormat('EEEE, MMMM dd, yyyy').format(dateTime)
                    : DateFormat.jm().format(dateTime);
              }
            }
            print("$matchLabel: $matchValue");
          }
          matchItems.add(MatchItem(
            matchLabel: matchLabel,
            matchvalue: matchValue,
          ));
        }
      }

      // for squad/playing info
      final squadElements = document.querySelectorAll('.cb-minfo-tm-nm');
      for (var squadElement in squadElements) {
        final squadLabel = squadElement.text;
        print(squadLabel);
        squadItems.add(SquadItem(squadLabel: squadLabel));
      }

      ////////////////////////////
      // for scorecard headers (example: Batter R B 4s 6s SR)
      extractScoreHeaderItem(document, fourthscoreHeaderItems, '4');

      extractScorecardItem(document, fourthscorecardItems, '4');

      extractTotalScoreItem(document, fourthtotalscoreItems, '4');

      extractBowlerHeaderItem(document, fourthbowlerHeaderItems, '4');

      extractBowlerDataItem(document, fourthbowlerDataItems, '4');

      /////////////////////////////

      // for scorecard headers (example: Batter R B 4s 6s SR)
      extractScoreHeaderItem(document, thirdscoreHeaderItems, '3');

      extractScorecardItem(document, thirdscorecardItems, '3');

      extractTotalScoreItem(document, thirdtotalscoreItems, '3');

      extractBowlerHeaderItem(document, thirdbowlerHeaderItems, '3');

      extractBowlerDataItem(document, thirdbowlerDataItems, '3');

      /////////////////////////////

      // for scorecard headers (example: Batter R B 4s 6s SR)
      extractScoreHeaderItem(document, secondscoreHeaderItems, '2');

      // for for first batting scorecard
      extractScorecardItem(document, secondscorecardItems, '2');

      // for Extract Extras data

      extractTotalScoreItem(document, secondtotalscoreItems, '2');

      // Extract data for the bowlers headers
      extractBowlerHeaderItem(document, secondbowlerHeaderItems, '2');

      // Extract data for the bowlers Data
      extractBowlerDataItem(document, secondbowlerDataItems, '2');

      // for extract the Powerplay headers

      extractPowerPlayItems(document, secondpowerplayItems, '2');

      // // for extract the Powerplay Data

      extractPowerPlayData(document, secondpowerplayDataItems, '2');

      //////////////////////////////////////

      // for scorecard headers (example: Batter R B 4s 6s SR)
      extractScoreHeaderItem(document, firstscoreHeaderItems, '1');

      // for for first batting scorecard
      extractScorecardItem(document, firstscorecardItems, '1');

      // for Extract Extras data
      extractTotalScoreItem(document, firsttotalscoreItems, '1');

      // Extract data for the bowlers headers
      extractBowlerHeaderItem(document, firstbowlerHeaderItems, '1');

      // Extract data for the bowlers Data
      extractBowlerDataItem(document, firstbowlerDataItems, '1');

      // for extract the Powerplay headers

      extractPowerPlayItems(document, firstpowerplayItems, '1');

      // for extract the Powerplay Data
      extractPowerPlayData(document, firstpowerplayDataItems, '1');

      //////////////////////////////////////

      if (!mounted) {
        // Check if the widget is still mounted before calling setState
        return;
      }
      //////////////////////////////////////

      setState(() {});
    } else {
      print('Failed to fetch matches: ${response.statusCode}');
      if (!mounted) {
        // Check if the widget is still mounted before calling setState
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ScoreCard'),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 10.h,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: matchStatus.length,
            itemBuilder: (context, index) {
              final item = matchStatus[index];
              return Text('Match Status : ${item.matchStatus}');
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: matchItems.length,
            itemBuilder: (context, index) {
              final matchItem = matchItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      Text(
                        '${matchItem.matchLabel} : ',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Text(matchItem.matchvalue),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: squadItems.length,
            itemBuilder: (context, index) {
              final squadItem = squadItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('${squadItem.squadLabel}'),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: fourthscoreHeaderItems.length,
            itemBuilder: (context, index) {
              final scoreHeaderItem = fourthscoreHeaderItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('Innings Title : ${scoreHeaderItem.inningsTitle}'),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text('Innings Info : ${scoreHeaderItem.inningsInfo}'),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text('Batter Header: ${scoreHeaderItem.batterHeader}'),
                  Text('Runs Header: ${scoreHeaderItem.runsHeader}'),
                  Text('Balls Header: ${scoreHeaderItem.ballsHeader}'),
                  Text('Fours Header: ${scoreHeaderItem.foursHeader}'),
                  Text('Sixes Header: ${scoreHeaderItem.sixesHeader}'),
                  Text(
                      'Strike Rate Header: ${scoreHeaderItem.strikeRateHeader}'),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: fourthscorecardItems.length,
            itemBuilder: (context, index) {
              final scorecardItem = fourthscorecardItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('Batter Name: ${scorecardItem.batterName}'),
                  Text('Dissmisal: ${scorecardItem.dismissal}'),
                  Text('Runs: ${scorecardItem.runs}'),
                  Text('Balls: ${scorecardItem.balls}'),
                  Text('Fours: ${scorecardItem.fours}'),
                  Text('Sixes: ${scorecardItem.sixes}'),
                  Text('Strike Rate: ${scorecardItem.strikeRate}'),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: fourthtotalscoreItems.length,
            itemBuilder: (context, index) {
              final totalscoreItem = fourthtotalscoreItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                      '${totalscoreItem.extrasLabel} : ${totalscoreItem.extrasValue} ${totalscoreItem.extrasDetails}'),
                  Text(
                      '${totalscoreItem.totalLabel} : ${totalscoreItem.totalValue} ${totalscoreItem.totalDetails}'),
                  Text(
                      '${totalscoreItem.yettobatLabel} : ${totalscoreItem.yettobatPlayers}'),
                  Text(
                      '${totalscoreItem.fallofwicketsLabel} : ${totalscoreItem.fallofWickets}'),
                  SizedBox(
                    height: 10.h,
                  )
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: fourthbowlerHeaderItems.length,
            itemBuilder: (context, index) {
              final bowlerHeaderItem = fourthbowlerHeaderItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('Bowler Header: ${bowlerHeaderItem.bowlerHeader}'),
                  // Text('Overs Header: ${bowlerHeaderItem.oversHeader}'),
                  // Text('Maidens Header: ${bowlerHeaderItem.maidensHeader}'),
                  // Text('Runs Header: ${bowlerHeaderItem.runsHeader}'),
                  // Text('Wickets Header: ${bowlerHeaderItem.wicketsHeader}'),
                  // Text('No Ball Header: ${bowlerHeaderItem.noballsHeader}'),
                  // Text('Wides Header: ${bowlerHeaderItem.widesHeader}'),
                  // Text('Economy Header: ${bowlerHeaderItem.economyHeader}'),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: fourthbowlerDataItems.length,
            itemBuilder: (context, index) {
              final bowlerDataItem = fourthbowlerDataItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('Bowler Name: ${bowlerDataItem.bowlerName}'),
                  Text('Overs: ${bowlerDataItem.overs}'),
                  Text('Maidens: ${bowlerDataItem.maidens}'),
                  Text('Runs: ${bowlerDataItem.runs}'),
                  Text('Wickets: ${bowlerDataItem.wickets}'),
                  Text('No Ball: ${bowlerDataItem.noballs}'),
                  Text('Wides: ${bowlerDataItem.wides}'),
                  Text('Economy: ${bowlerDataItem.economy}'),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: thirdscoreHeaderItems.length,
            itemBuilder: (context, index) {
              final scoreHeaderItem = thirdscoreHeaderItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('Innings Title : ${scoreHeaderItem.inningsTitle}'),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text('Innings Info : ${scoreHeaderItem.inningsInfo}'),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text('Batter Header: ${scoreHeaderItem.batterHeader}'),
                  Text('Runs Header: ${scoreHeaderItem.runsHeader}'),
                  Text('Balls Header: ${scoreHeaderItem.ballsHeader}'),
                  Text('Fours Header: ${scoreHeaderItem.foursHeader}'),
                  Text('Sixes Header: ${scoreHeaderItem.sixesHeader}'),
                  Text(
                      'Strike Rate Header: ${scoreHeaderItem.strikeRateHeader}'),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: thirdscorecardItems.length,
            itemBuilder: (context, index) {
              final scorecardItem = thirdscorecardItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('Batter Name: ${scorecardItem.batterName}'),
                  Text('Dissmisal: ${scorecardItem.dismissal}'),
                  Text('Runs: ${scorecardItem.runs}'),
                  Text('Balls: ${scorecardItem.balls}'),
                  Text('Fours: ${scorecardItem.fours}'),
                  Text('Sixes: ${scorecardItem.sixes}'),
                  Text('Strike Rate: ${scorecardItem.strikeRate}'),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: thirdtotalscoreItems.length,
            itemBuilder: (context, index) {
              final totalscoreItem = thirdtotalscoreItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                      '${totalscoreItem.extrasLabel} : ${totalscoreItem.extrasValue} ${totalscoreItem.extrasDetails}'),
                  Text(
                      '${totalscoreItem.totalLabel} : ${totalscoreItem.totalValue} ${totalscoreItem.totalDetails}'),
                  Text(
                      '${totalscoreItem.yettobatLabel} : ${totalscoreItem.yettobatPlayers}'),
                  Text(
                      '${totalscoreItem.fallofwicketsLabel} : ${totalscoreItem.fallofWickets}'),
                  SizedBox(
                    height: 10.h,
                  )
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: thirdbowlerHeaderItems.length,
            itemBuilder: (context, index) {
              final bowlerHeaderItem = thirdbowlerHeaderItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('Bowler Header: ${bowlerHeaderItem.bowlerHeader}'),
                  // Text('Overs Header: ${bowlerHeaderItem.oversHeader}'),
                  // Text('Maidens Header: ${bowlerHeaderItem.maidensHeader}'),
                  // Text('Runs Header: ${bowlerHeaderItem.runsHeader}'),
                  // Text('Wickets Header: ${bowlerHeaderItem.wicketsHeader}'),
                  // Text('No Ball Header: ${bowlerHeaderItem.noballsHeader}'),
                  // Text('Wides Header: ${bowlerHeaderItem.widesHeader}'),
                  // Text('Economy Header: ${bowlerHeaderItem.economyHeader}'),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: thirdbowlerDataItems.length,
            itemBuilder: (context, index) {
              final bowlerDataItem = thirdbowlerDataItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('Bowler Name: ${bowlerDataItem.bowlerName}'),
                  Text('Overs: ${bowlerDataItem.overs}'),
                  Text('Maidens: ${bowlerDataItem.maidens}'),
                  Text('Runs: ${bowlerDataItem.runs}'),
                  Text('Wickets: ${bowlerDataItem.wickets}'),
                  Text('No Ball: ${bowlerDataItem.noballs}'),
                  Text('Wides: ${bowlerDataItem.wides}'),
                  Text('Economy: ${bowlerDataItem.economy}'),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: secondscoreHeaderItems.length,
            itemBuilder: (context, index) {
              final scoreHeaderItem = secondscoreHeaderItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('Innings Title : ${scoreHeaderItem.inningsTitle}'),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text('Innings Info : ${scoreHeaderItem.inningsInfo}'),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text('Batter Header: ${scoreHeaderItem.batterHeader}'),
                  Text('Runs Header: ${scoreHeaderItem.runsHeader}'),
                  Text('Balls Header: ${scoreHeaderItem.ballsHeader}'),
                  Text('Fours Header: ${scoreHeaderItem.foursHeader}'),
                  Text('Sixes Header: ${scoreHeaderItem.sixesHeader}'),
                  Text(
                      'Strike Rate Header: ${scoreHeaderItem.strikeRateHeader}'),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: secondscorecardItems.length,
            itemBuilder: (context, index) {
              final scorecardItem = secondscorecardItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('Batter Name: ${scorecardItem.batterName}'),
                  Text('Dissmisal: ${scorecardItem.dismissal}'),
                  Text('Runs: ${scorecardItem.runs}'),
                  Text('Balls: ${scorecardItem.balls}'),
                  Text('Fours: ${scorecardItem.fours}'),
                  Text('Sixes: ${scorecardItem.sixes}'),
                  Text('Strike Rate: ${scorecardItem.strikeRate}'),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: secondtotalscoreItems.length,
            itemBuilder: (context, index) {
              final totalscoreItem = secondtotalscoreItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                      '${totalscoreItem.extrasLabel} : ${totalscoreItem.extrasValue} ${totalscoreItem.extrasDetails}'),
                  Text(
                      '${totalscoreItem.totalLabel} : ${totalscoreItem.totalValue} ${totalscoreItem.totalDetails}'),
                  Text(
                      '${totalscoreItem.yettobatLabel} : ${totalscoreItem.yettobatPlayers}'),
                  Text(
                      '${totalscoreItem.fallofwicketsLabel} : ${totalscoreItem.fallofWickets}'),
                  SizedBox(
                    height: 10.h,
                  )
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: secondbowlerHeaderItems.length,
            itemBuilder: (context, index) {
              final bowlerHeaderItem = secondbowlerHeaderItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('Bowler Header: ${bowlerHeaderItem.bowlerHeader}'),
                  // Text('Overs Header: ${bowlerHeaderItem.oversHeader}'),
                  // Text('Maidens Header: ${bowlerHeaderItem.maidensHeader}'),
                  // Text('Runs Header: ${bowlerHeaderItem.runsHeader}'),
                  // Text('Wickets Header: ${bowlerHeaderItem.wicketsHeader}'),
                  // Text('No Ball Header: ${bowlerHeaderItem.noballsHeader}'),
                  // Text('Wides Header: ${bowlerHeaderItem.widesHeader}'),
                  // Text('Economy Header: ${bowlerHeaderItem.economyHeader}'),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: secondbowlerDataItems.length,
            itemBuilder: (context, index) {
              final bowlerDataItem = secondbowlerDataItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('Bowler Name: ${bowlerDataItem.bowlerName}'),
                  Text('Overs: ${bowlerDataItem.overs}'),
                  Text('Maidens: ${bowlerDataItem.maidens}'),
                  Text('Runs: ${bowlerDataItem.runs}'),
                  Text('Wickets: ${bowlerDataItem.wickets}'),
                  Text('No Ball: ${bowlerDataItem.noballs}'),
                  Text('Wides: ${bowlerDataItem.wides}'),
                  Text('Economy: ${bowlerDataItem.economy}'),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: secondpowerplayItems.length,
            itemBuilder: (context, index) {
              final powerplayItem = secondpowerplayItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('PowerPlay Label: ${powerplayItem.powerplaysLabel}'),
                  Text('Overs Label: ${powerplayItem.oversLabel}'),
                  Text('Runs Label: ${powerplayItem.runsLabel}'),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: secondpowerplayDataItems.length,
            itemBuilder: (context, index) {
              final powerplayDataItem = secondpowerplayDataItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('PowerPlay Value: ${powerplayDataItem.powerplaysValue}'),
                  Text('Overs Value: ${powerplayDataItem.oversValue}'),
                  Text('Runs Value: ${powerplayDataItem.runsValue}'),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: firstscoreHeaderItems.length,
            itemBuilder: (context, index) {
              final firstscoreHeaderItem = firstscoreHeaderItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('Innings Title : ${firstscoreHeaderItem.inningsTitle}'),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text('Innings Info : ${firstscoreHeaderItem.inningsInfo}'),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text('Batter Header: ${firstscoreHeaderItem.batterHeader}'),
                  Text('Runs Header: ${firstscoreHeaderItem.runsHeader}'),
                  Text('Balls Header: ${firstscoreHeaderItem.ballsHeader}'),
                  Text('Fours Header: ${firstscoreHeaderItem.foursHeader}'),
                  Text('Sixes Header: ${firstscoreHeaderItem.sixesHeader}'),
                  Text(
                      'Strike Rate Header: ${firstscoreHeaderItem.strikeRateHeader}'),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: firstscorecardItems.length,
            itemBuilder: (context, index) {
              final firstscorecardItem = firstscorecardItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('Batter Name: ${firstscorecardItem.batterName}'),
                  Text('Dissmisal: ${firstscorecardItem.dismissal}'),
                  Text('Runs: ${firstscorecardItem.runs}'),
                  Text('Balls: ${firstscorecardItem.balls}'),
                  Text('Fours: ${firstscorecardItem.fours}'),
                  Text('Sixes: ${firstscorecardItem.sixes}'),
                  Text('Strike Rate: ${firstscorecardItem.strikeRate}'),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: firsttotalscoreItems.length,
            itemBuilder: (context, index) {
              final firsttotalscoreItem = firsttotalscoreItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                      '${firsttotalscoreItem.extrasLabel} : ${firsttotalscoreItem.extrasValue} ${firsttotalscoreItem.extrasDetails}'),
                  Text(
                      '${firsttotalscoreItem.totalLabel} : ${firsttotalscoreItem.totalValue} ${firsttotalscoreItem.totalDetails}'),
                  Text(
                      '${firsttotalscoreItem.yettobatLabel} : ${firsttotalscoreItem.yettobatPlayers}'),
                  Text(
                      '${firsttotalscoreItem.fallofwicketsLabel} : ${firsttotalscoreItem.fallofWickets}'),
                  SizedBox(
                    height: 10.h,
                  )
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: firstbowlerHeaderItems.length,
            itemBuilder: (context, index) {
              final firstbowlerHeaderItem = firstbowlerHeaderItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  // Text('Bowler Header: ${firstbowlerHeaderItem.bowlerHeader}'),
                  // Text('Overs Header: ${firstbowlerHeaderItem.oversHeader}'),
                  // Text(
                  //     'Maidens Header: ${firstbowlerHeaderItem.maidensHeader}'),
                  // Text('Runs Header: ${firstbowlerHeaderItem.runsHeader}'),
                  // Text(
                  //     'Wickets Header: ${firstbowlerHeaderItem.wicketsHeader}'),
                  // Text(
                  //     'No Ball Header: ${firstbowlerHeaderItem.noballsHeader}'),
                  // Text('Wides Header: ${firstbowlerHeaderItem.widesHeader}'),
                  // Text(
                  //     'Economy Header: ${firstbowlerHeaderItem.economyHeader}'),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: firstbowlerDataItems.length,
            itemBuilder: (context, index) {
              final firstbowlerDataItem = firstbowlerDataItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('Bowler Name: ${firstbowlerDataItem.bowlerName}'),
                  Text('Overs: ${firstbowlerDataItem.overs}'),
                  Text('Maidens: ${firstbowlerDataItem.maidens}'),
                  Text('Runs: ${firstbowlerDataItem.runs}'),
                  Text('Wickets: ${firstbowlerDataItem.wickets}'),
                  Text('No Ball: ${firstbowlerDataItem.noballs}'),
                  Text('Wides: ${firstbowlerDataItem.wides}'),
                  Text('Economy: ${firstbowlerDataItem.economy}'),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: firstpowerplayItems.length,
            itemBuilder: (context, index) {
              final firstpowerplayItem = firstpowerplayItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                      'PowerPlay Label: ${firstpowerplayItem.powerplaysLabel}'),
                  Text('Overs Label: ${firstpowerplayItem.oversLabel}'),
                  Text('Runs Label: ${firstpowerplayItem.runsLabel}'),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: firstpowerplayDataItems.length,
            itemBuilder: (context, index) {
              final firstpowerplayDataItem = firstpowerplayDataItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                      'PowerPlay Value: ${firstpowerplayDataItem.powerplaysValue}'),
                  Text('Overs Value: ${firstpowerplayDataItem.oversValue}'),
                  Text('Runs Value: ${firstpowerplayDataItem.runsValue}'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
