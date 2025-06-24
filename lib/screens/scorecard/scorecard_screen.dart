import 'package:crickfy_app/classes/scorecard_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../utils/text_style.dart';

class ScoreCardScreen extends StatefulWidget {
  final String url;
  const ScoreCardScreen({super.key, required this.url});

  @override
  State<ScoreCardScreen> createState() => _ScoreCardScreenState();
}

class _ScoreCardScreenState extends State<ScoreCardScreen> {
  final List<FirstScoreHeaderItem> firstscoreHeaderItems = [];
  final List<FirstScorecardItem> firstscorecardItems = [];
  final List<FirstTotalScoreItem> firsttotalscoreItems = [];
  final List<FirstBowlerDataItem> firstbowlerDataItems = [];
  final List<FirstPowerPlayDataItem> firstpowerplayDataItems = [];

  final List<SecondScoreHeaderItem> secondscoreHeaderItems = [];
  final List<SecondScorecardItem> secondscorecardItems = [];
  final List<SecondTotalScoreItem> secondtotalscoreItems = [];
  final List<SecondBowlerDataItem> secondbowlerDataItems = [];
  final List<SecondPowerPlayDataItem> secondpowerplayDataItems = [];

  final List<ThirdScoreHeaderItem> thirdscoreHeaderItems = [];
  final List<ThirdScorecardItem> thirdscorecardItems = [];
  final List<ThirdTotalScoreItem> thirdtotalscoreItems = [];
  final List<ThirdBowlerDataItem> thirdbowlerDataItems = [];
  final List thirdpowerplayDataItems = [];

  final List<FourthScoreHeaderItem> fourthscoreHeaderItems = [];
  final List<FourthScorecardItem> fourthscorecardItems = [];
  final List<FourthTotalScoreItem> fourthtotalscoreItems = [];
  final List<FourthBowlerDataItem> fourthbowlerDataItems = [];
  final List fourthpowerplayDataItems = [];

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
    final response = await http.get(
      Uri.parse(widget.url),
    );
    if (response.statusCode == 200) {
      final document = html.parse(response.body);
      // for scorecard headers (example: Batter R B 4s 6s SR)
      extractScoreHeaderItem(document, firstscoreHeaderItems, '1');
      extractScoreHeaderItem(document, secondscoreHeaderItems, '2');
      extractScoreHeaderItem(document, thirdscoreHeaderItems, '3');
      extractScoreHeaderItem(document, fourthscoreHeaderItems, '4');

      // for for first batting scorecard
      extractScorecardItem(document, firstscorecardItems, '1');
      extractScorecardItem(document, secondscorecardItems, '2');
      extractScorecardItem(document, thirdscorecardItems, '3');
      extractScorecardItem(document, fourthscorecardItems, '4');

      // for Extract Extras data
      extractTotalScoreItem(document, firsttotalscoreItems, '1');
      extractTotalScoreItem(document, secondtotalscoreItems, '2');
      extractTotalScoreItem(document, thirdtotalscoreItems, '3');
      extractTotalScoreItem(document, fourthtotalscoreItems, '4');

      // Extract data for the bowlers Data
      extractBowlerDataItem(document, firstbowlerDataItems, '1');
      extractBowlerDataItem(document, secondbowlerDataItems, '2');
      extractBowlerDataItem(document, thirdbowlerDataItems, '3');
      extractBowlerDataItem(document, fourthbowlerDataItems, '4');

      // for extract the Powerplay Data
      extractPowerPlayData(document, firstpowerplayDataItems, '1');
      extractPowerPlayData(document, secondpowerplayDataItems, '2');
      extractPowerPlayData(document, thirdpowerplayDataItems, '3');
      extractPowerPlayData(document, fourthpowerplayDataItems, '4');

      if (!mounted) {
        return;
      }
      setState(() {
        isLoading = false;
      });
    } else {
      print('Failed to fetch matches: ${response.statusCode}');
      if (!mounted) {
        return;
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    // For example, you can clear the existing data and fetch new data
    firstscoreHeaderItems.clear();
    firstscorecardItems.clear();
    firsttotalscoreItems.clear();
    firstbowlerDataItems.clear();
    firstpowerplayDataItems.clear();
    secondscoreHeaderItems.clear();
    secondscorecardItems.clear();
    secondtotalscoreItems.clear();
    secondbowlerDataItems.clear();
    secondpowerplayDataItems.clear();
    thirdscoreHeaderItems.clear();
    thirdscorecardItems.clear();
    thirdtotalscoreItems.clear();
    thirdbowlerDataItems.clear();
    thirdpowerplayDataItems.clear();
    fourthscoreHeaderItems.clear();
    fourthscorecardItems.clear();
    fourthtotalscoreItems.clear();
    fourthbowlerDataItems.clear();
    fourthpowerplayDataItems.clear();

    await scorecardMatches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 19, 1),
      body: Stack(children: [
        Image.asset(
          'assets/images/blur backgroung.png',
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          scale: 1,
        ),
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
                        fourthscoreHeaderItems,
                        fourthscorecardItems,
                        fourthtotalscoreItems,
                        fourthbowlerDataItems,
                        fourthpowerplayDataItems),
                    listbuilderMethod(
                        thirdscoreHeaderItems,
                        thirdscorecardItems,
                        thirdtotalscoreItems,
                        thirdbowlerDataItems,
                        thirdpowerplayDataItems),
                    listbuilderMethod(
                        secondscoreHeaderItems,
                        secondscorecardItems,
                        secondtotalscoreItems,
                        secondbowlerDataItems,
                        secondpowerplayDataItems),
                    listbuilderMethod(
                        firstscoreHeaderItems,
                        firstscorecardItems,
                        firsttotalscoreItems,
                        firstbowlerDataItems,
                        firstpowerplayDataItems),
                  ],
                ),
              )
      ]),
    );
  }

  ListView listbuilderMethod(
      List item1, List item2, List item3, List item4, List item5) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: item1.length,
      itemBuilder: (context, index) {
        final item = item1[index];
        return ExpansionTile(
          collapsedTextColor: Colors.white,
          collapsedIconColor: Colors.white,
          textColor: Colors.grey,
          iconColor: Colors.grey,
          title: Text('${item.inningsTitle} : ${item.inningsInfo}',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'Mulish-ExtraBold')),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'Batter',
                    style: textMethod(Color.fromARGB(255, 110, 191, 59), 16.sp,
                        FontWeight.bold, 'Mulish-ExtraBold'),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: item2.length,
                  itemBuilder: (context, index) {
                    final item = item2[index];
                    return Container(
                      width: double.infinity,
                      child: ListTile(
                        visualDensity: VisualDensity.compact,
                        title: Text(
                          item.batterName,
                          style: textMethod(Colors.white, 12.sp,
                              FontWeight.bold, 'SpaceGrotesk-Regular'),
                        ),
                        subtitle: Text(
                          item.dismissal,
                          style: textMethod(
                              _getColorForDissmisal(item.dismissal),
                              12.sp,
                              FontWeight.bold,
                              'SpaceGrotesk-Regular'),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              item.runs,
                              style: textMethod(Colors.white, 15.sp,
                                  FontWeight.bold, 'SpaceGrotesk-Regular'),
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              '(${item.balls})',
                              style: textMethod(Colors.grey, 14.sp,
                                  FontWeight.normal, 'SpaceGrotesk-Regular'),
                            ),
                            SizedBox(width: 20.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'SR : ',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      item.strikeRate,
                                      style: textMethod(
                                          Colors.grey,
                                          14.sp,
                                          FontWeight.bold,
                                          'SpaceGrotesk-Regular'),
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
                                          'SpaceGrotesk-Regular'),
                                    ),
                                    Text(
                                      item.fours,
                                      style: textMethod(
                                          Color.fromARGB(255, 0, 166, 255),
                                          14.sp,
                                          FontWeight.normal,
                                          'SpaceGrotesk-Regular'),
                                    ),
                                    Text(
                                      ' | 6s : ',
                                      style: textMethod(
                                          Colors.white,
                                          14.sp,
                                          FontWeight.normal,
                                          'SpaceGrotesk-Regular'),
                                    ),
                                    Text(
                                      item.sixes,
                                      style: textMethod(
                                          Color.fromARGB(255, 255, 217, 0),
                                          14.sp,
                                          FontWeight.bold,
                                          'SpaceGrotesk-Regular'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: item3.length,
                  itemBuilder: (context, index) {
                    final item = item3[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.extrasLabel,
                                style: textMethod(Colors.redAccent, 14.sp,
                                    FontWeight.normal, 'Mulish-ExtraBold'),
                              ),
                              Text('${item.extrasValue} ${item.extrasDetails}',
                                  style: textMethod(
                                      Colors.white,
                                      14.sp,
                                      FontWeight.normal,
                                      'SpaceGrotesk-Regular')),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.totalLabel,
                                style: textMethod(Colors.redAccent, 14.sp,
                                    FontWeight.normal, 'Mulish-ExtraBold'),
                              ),
                              Text('${item.totalValue} ${item.totalDetails}',
                                  style: textMethod(
                                      Colors.white,
                                      14.sp,
                                      FontWeight.normal,
                                      'SpaceGrotesk-Regular')),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.fallofwicketsLabel,
                                        style: textMethod(
                                            Colors.tealAccent,
                                            14.sp,
                                            FontWeight.normal,
                                            'Mulish-ExtraBold')),
                                    Text(item.fallofWickets,
                                        style: textMethod(
                                            Colors.white,
                                            14.sp,
                                            FontWeight.normal,
                                            'SpaceGrotesk-Regular')),
                                  ],
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (item.yettobatLabel.isNotEmpty &&
                                        item.yettobatPlayers.isNotEmpty) ...[
                                      Text(item.yettobatLabel,
                                          style: textMethod(
                                              Colors.tealAccent,
                                              14.sp,
                                              FontWeight.normal,
                                              'Mulish-ExtraBold')),
                                      Text(
                                        item.yettobatPlayers,
                                        style: textMethod(
                                            Colors.white,
                                            14.sp,
                                            FontWeight.normal,
                                            'SpaceGrotesk-Regular'),
                                      ),
                                    ],
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        )
                      ],
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'Bowler',
                    style: textMethod(Color.fromARGB(255, 110, 191, 59), 16.sp,
                        FontWeight.bold, 'Mulish-ExtraBold'),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: item4.length,
                  itemBuilder: (context, index) {
                    final item = item4[index];
                    return Container(
                      width: double.infinity,
                      child: ListTile(
                        visualDensity: VisualDensity.compact,
                        title: Text(
                          item.bowlerName,
                          style: textMethod(Colors.white, 12.sp,
                              FontWeight.bold, 'SpaceGrotesk-Regular'),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      item.runs,
                                      style: textMethod(
                                          Colors.white,
                                          15.sp,
                                          FontWeight.bold,
                                          'SpaceGrotesk-Regular'),
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      '(${item.overs} Ov.)',
                                      style: textMethod(
                                          Colors.grey,
                                          14.sp,
                                          FontWeight.normal,
                                          'SpaceGrotesk-Regular'),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'ECO : ',
                                      style: textMethod(
                                          Colors.white,
                                          12.sp,
                                          FontWeight.bold,
                                          'SpaceGrotesk-Regular'),
                                    ),
                                    Text(
                                      item.economy,
                                      style: textMethod(
                                          Colors.grey,
                                          12.sp,
                                          FontWeight.bold,
                                          'SpaceGrotesk-Regular'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(width: 20.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'WIC : ',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      item.wickets,
                                      style: textMethod(
                                          Colors.red,
                                          14.sp,
                                          FontWeight.bold,
                                          'SpaceGrotesk-Regular'),
                                    ),
                                    Text(
                                      ' | M : ',
                                      style: textMethod(
                                          Colors.white,
                                          14.sp,
                                          FontWeight.normal,
                                          'SpaceGrotesk-Regular'),
                                    ),
                                    Text(
                                      item.maidens,
                                      style: textMethod(
                                          Colors.deepPurple,
                                          14.sp,
                                          FontWeight.bold,
                                          'SpaceGrotesk-Regular'),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'WD : ',
                                      style: textMethod(
                                          Colors.white,
                                          14.sp,
                                          FontWeight.normal,
                                          'SpaceGrotesk-Regular'),
                                    ),
                                    Text(
                                      item.wides,
                                      style: textMethod(
                                          Colors.grey,
                                          14.sp,
                                          FontWeight.normal,
                                          'SpaceGrotesk-Regular'),
                                    ),
                                    Text(
                                      ' | NB : ',
                                      style: textMethod(
                                          Colors.white,
                                          14.sp,
                                          FontWeight.normal,
                                          'SpaceGrotesk-Regular'),
                                    ),
                                    Text(
                                      item.noballs,
                                      style: textMethod(
                                          Colors.grey,
                                          14.sp,
                                          FontWeight.bold,
                                          'SpaceGrotesk-Regular'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: item5.length,
                  itemBuilder: (context, index) {
                    final item = item5[index];
                    return Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('PowerPlays',
                                  style: textMethod(
                                      Color.fromARGB(255, 241, 130, 3),
                                      14.sp,
                                      FontWeight.normal,
                                      'Mulish-ExtraBold')),
                              Text(item.powerplaysValue,
                                  style: textMethod(
                                      Colors.white,
                                      14.sp,
                                      FontWeight.normal,
                                      'SpaceGrotesk-Regular')),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Overs',
                                  style: textMethod(
                                      Color.fromARGB(255, 241, 130, 3),
                                      14.sp,
                                      FontWeight.normal,
                                      'Mulish-ExtraBold')),
                              Text(item.oversValue,
                                  style: textMethod(
                                      Colors.white,
                                      14.sp,
                                      FontWeight.normal,
                                      'SpaceGrotesk-Regular')),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Runs',
                                  style: textMethod(
                                      Color.fromARGB(255, 241, 130, 3),
                                      14.sp,
                                      FontWeight.normal,
                                      'Mulish-ExtraBold')),
                              Text(item.runsValue,
                                  style: textMethod(
                                      Colors.white,
                                      14.sp,
                                      FontWeight.normal,
                                      'SpaceGrotesk-Regular')),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            )
          ],
        );
      },
    );
  }

  Color _getColorForDissmisal(String dismissal) {
    switch (dismissal) {
      case 'not out':
        return Colors.amber;
      case 'batting':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }
}
