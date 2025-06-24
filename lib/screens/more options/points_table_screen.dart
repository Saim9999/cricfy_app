import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../utils/text_style.dart';

class PointsTableItems {
  final String teamname;
  final String teamImage;
  final String matchplayed;
  final String matchwon;
  final String matchlost;
  final String matchdraw;
  final String matchtied;
  final String matchnoresult;
  final String matchpoints;
  final String matchrunrate;
  bool isContainerVisible;
  final int matchid;

  PointsTableItems({
    required this.teamname,
    required this.teamImage,
    required this.matchplayed,
    required this.matchwon,
    required this.matchlost,
    required this.matchdraw,
    required this.matchtied,
    required this.matchnoresult,
    required this.matchpoints,
    required this.matchrunrate,
    required this.isContainerVisible,
    required this.matchid,
  });
}

class OpponentsData {
  final String opponent;
  final String description;
  final String date;
  final String result;
  final int opponentMaitchId;

  OpponentsData({
    required this.opponent,
    required this.description,
    required this.date,
    required this.result,
    required this.opponentMaitchId,
  });
}

class PointsTableHeaders {
  final String teamname;
  final String matchplayed;
  final String matchwon;
  final String matchlost;
  final String matchdraw;
  final String matchtied;
  final String matchnoresult;
  final String matchpoints;
  final String matchrunrate;

  PointsTableHeaders({
    required this.teamname,
    required this.matchplayed,
    required this.matchwon,
    required this.matchlost,
    required this.matchdraw,
    required this.matchtied,
    required this.matchnoresult,
    required this.matchpoints,
    required this.matchrunrate,
  });
}

class SeriesName {
  final String seriesTitle;
  final String seriesDetail;

  SeriesName({required this.seriesTitle, required this.seriesDetail});
}

class PointsTableScreen extends StatefulWidget {
  final String seriesurl;
  const PointsTableScreen({super.key, required this.seriesurl});

  @override
  State<PointsTableScreen> createState() => _PointsTableScreenState();
}

class _PointsTableScreenState extends State<PointsTableScreen> {
  final List<PointsTableItems> pointstableItems = [];
  final List<OpponentsData> opponentData = [];
  final List<PointsTableHeaders> pointstableHeaders = [];
  final List<SeriesName> seriesName = [];
  bool isLoading = true;
  int? directionValue;
  bool isContainerVisible = true;

  @override
  void initState() {
    super.initState();
    fetchPointsTable();
  }

  Future<void> fetchPointsTable() async {
    if (!mounted) {
      // Check if the widget is still mounted before proceeding
      return;
    }
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse(widget.seriesurl));

    if (response.statusCode == 200) {
      final document = html.parse(response.body);

      final mainelements = document.querySelectorAll('.cb-col.cb-nav-main');
      for (var element in mainelements) {
        final title = element.querySelector('.cb-nav-hdr')?.text ?? '';
        final detail = element
            .querySelector('.text-gray')!
            .text
            .trim()
            .replaceAll('  ', ' ');
        seriesName.add(SeriesName(seriesTitle: title, seriesDetail: detail));
        print('Series Title : $title');
        print('Series Detail : $detail');
      }

      //////////////////////////////////
      // for Points Table Headers
      final teamsTableHeaders =
          document.querySelector('.cb-col-67.cb-col.cb-left.cb-hm-rght');
      final teamRowsHeaders =
          teamsTableHeaders!.querySelectorAll('.table.cb-srs-pnts');
      for (var row in teamRowsHeaders) {
        final teamNameHeader = row.querySelector('.cb-srs-pnts-th')?.text;
        final matchesPlayedHeader =
            row.querySelector('.cb-srs-pnts-th:nth-child(1)')?.text;
        final matchesWonHeader =
            row.querySelector('.cb-srs-pnts-th:nth-child(2)')?.text;
        final matchesLostHeader =
            row.querySelector('.cb-srs-pnts-th:nth-child(3)')?.text;
        var matchesDrawHeader =
            row.querySelector('.cb-srs-pnts-th:nth-child(4)')?.text;
        matchesDrawHeader ??=
            row.querySelector('.cb-srs-pnts-th:nth-child(3)')?.text;
        var matchesTiedHeader =
            row.querySelector('.cb-srs-pnts-th:nth-child(5)')?.text;
        matchesTiedHeader ??=
            row.querySelector('.cb-srs-pnts-th:nth-child(4)')?.text;
        var matchesNoResultHeader =
            row.querySelector('.cb-srs-pnts-th:nth-child(6)')?.text;
        matchesNoResultHeader ??=
            row.querySelector('.cb-srs-pnts-th:nth-child(5)')?.text;
        var matchPointsHeader =
            row.querySelector('.cb-srs-pnts-th:nth-child(7)')?.text;
        matchPointsHeader ??=
            row.querySelector('.cb-srs-pnts-th:nth-child(6)')?.text;
        var netRunRateHeader =
            row.querySelector('.cb-srs-pnts-th:nth-child(8)')?.text;
        netRunRateHeader ??= '';

        if (teamNameHeader != null &&
            matchesPlayedHeader != null &&
            matchesWonHeader != null &&
            matchesLostHeader != null &&
            matchesDrawHeader != null &&
            matchesTiedHeader != null &&
            matchesNoResultHeader != null &&
            matchPointsHeader != null) {
          pointstableHeaders.add(PointsTableHeaders(
            teamname: teamNameHeader,
            matchplayed: matchesPlayedHeader,
            matchwon: matchesWonHeader,
            matchlost: matchesLostHeader,
            matchdraw: matchesDrawHeader,
            matchtied: matchesTiedHeader,
            matchnoresult: matchesNoResultHeader,
            matchpoints: matchPointsHeader,
            matchrunrate: netRunRateHeader,
          ));
          print(teamNameHeader);
          print(matchesPlayedHeader);
          print(matchesWonHeader);
          print(matchesLostHeader);
          print(matchesDrawHeader);
          print(matchesTiedHeader);
          print(matchesNoResultHeader);
          print(matchPointsHeader);
          print(netRunRateHeader);
        }
      }

      /////////////////////////
      final teamsTable =
          document.querySelector('.cb-col-67.cb-col.cb-left.cb-hm-rght');
      final teamRows =
          teamsTable!.querySelectorAll('.table.cb-srs-pnts tbody tr');

      for (var row in teamRows) {
        final teamName = row.querySelector('.cb-srs-pnts-name')?.text;
        final imgElement = row.querySelector('.cb-col-16 img');
        final imageUrl = imgElement?.attributes['src'];

        final matchesPlayed =
            row.querySelector('.cb-srs-pnts-td:nth-child(1)')?.text;
        final matchesWon =
            row.querySelector('.cb-srs-pnts-td:nth-child(2)')?.text;
        final matchesLost =
            row.querySelector('.cb-srs-pnts-td:nth-child(3)')?.text;
        var matchesDraw =
            row.querySelector('.cb-srs-pnts-td:nth-child(4)')?.text;
        matchesDraw ??= row.querySelector('.cb-srs-pnts-td:nth-child(3)')?.text;
        var matchesTied =
            row.querySelector('.cb-srs-pnts-td:nth-child(5)')?.text;
        matchesTied ??= row.querySelector('.cb-srs-pnts-td:nth-child(4)')?.text;
        var matchesNoResult =
            row.querySelector('.cb-srs-pnts-td:nth-child(6)')?.text;
        matchesNoResult ??=
            row.querySelector('.cb-srs-pnts-td:nth-child(5)')?.text;
        var matchPoints =
            row.querySelector('.cb-srs-pnts-td:nth-child(7)')?.text;
        matchPoints ??= row.querySelector('.cb-srs-pnts-td:nth-child(6)')?.text;
        var netRunRate =
            row.querySelector('.cb-srs-pnts-td:nth-child(8)')?.text;
        netRunRate ??= '';

        var directionElement = row.querySelector('[ng-init^="direction"]');
        var directionTeams = directionElement?.attributes['ng-init'];
        var regex = RegExp(r'_(\d+)_');
        var match = regex.firstMatch(directionTeams ?? '');
        if (match != null) {
          directionValue = int.tryParse(match.group(1) ?? '');
          print('Direction Value: $directionValue');
        }

        final downTable = row.querySelector(
            'div[id="team_$directionValue"] .table.cb-srs-pnts-dwn-tbl td');
        if (downTable != null) {
          final opponent = row.querySelector('.text-left')?.text;
          if (opponent != 'Opponent') {
            final description =
                row.querySelector('.text-left:nth-child(1)')?.text;
            final date = row.querySelector('.text-left:nth-child(2)')?.text;
            final result = row.querySelector('.text-left:nth-child(3)')?.text;
            print('$opponent');
            print('$description');
            print('$date');
            print('$result');

            opponentData.add(OpponentsData(
              opponent: opponent!,
              description: description!,
              date: date!,
              result: result!,
              opponentMaitchId: directionValue!,
            ));
          }
        }

        if (teamName != null &&
            imageUrl != null &&
            matchesPlayed != null &&
            matchesWon != null &&
            matchesLost != null &&
            matchesDraw != null &&
            matchesTied != null &&
            matchesNoResult != null &&
            matchPoints != null) {
          pointstableItems.add(PointsTableItems(
            teamname: teamName,
            teamImage: imageUrl,
            matchplayed: matchesPlayed,
            matchwon: matchesWon,
            matchlost: matchesLost,
            matchdraw: matchesDraw,
            matchtied: matchesTied,
            matchnoresult: matchesNoResult,
            matchpoints: matchPoints,
            matchrunrate: netRunRate,
            isContainerVisible: false,
            matchid: directionValue!,
          ));
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 19, 1),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/Rectangle 6370.png'),
                fit: BoxFit.cover)),
        child: isLoading
            ? Center(
                child: LoadingAnimationWidget.horizontalRotatingDots(
                  size: 50,
                  color: Color.fromARGB(255, 114, 255, 48),
                ),
              )
            : ListView(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: seriesName.length,
                    itemBuilder: (context, index) {
                      final item = seriesName[index];
                      return Container(
                        width: double.infinity,
                        color: Colors.amber,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(0),
                          leading: IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              )),
                          title: Text(item.seriesTitle,
                              style: textMethod(Colors.black, 16.sp,
                                  FontWeight.bold, 'Mulish-ExtraBold')),
                          subtitle: Text(item.seriesDetail,
                              style: textMethod(Colors.grey.shade600, 14.sp,
                                  FontWeight.bold, 'SpaceGrotesk-Regular')),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Text('Teams',
                              style: textMethod(
                                  Color.fromARGB(255, 241, 130, 3),
                                  14.sp,
                                  FontWeight.normal,
                                  'Mulish-ExtraBold')),
                        ],
                      ),
                      Row(
                        children: [
                          Text('M',
                              style: textMethod(
                                  Color.fromARGB(255, 241, 130, 3),
                                  14.sp,
                                  FontWeight.normal,
                                  'Mulish-ExtraBold')),
                          SizedBox(
                            width: 8.w,
                          ),
                          Text('W',
                              style: textMethod(
                                  Color.fromARGB(255, 241, 130, 3),
                                  14.sp,
                                  FontWeight.normal,
                                  'Mulish-ExtraBold')),
                          SizedBox(
                            width: 8.w,
                          ),
                          Text("Nr",
                              style: textMethod(
                                  Color.fromARGB(255, 241, 130, 3),
                                  14.sp,
                                  FontWeight.normal,
                                  'Mulish-ExtraBold')),
                          SizedBox(
                            width: 8.w,
                          ),
                          Text('Pts',
                              style: textMethod(
                                  Color.fromARGB(255, 241, 130, 3),
                                  14.sp,
                                  FontWeight.normal,
                                  'Mulish-ExtraBold')),
                          SizedBox(
                            width: 12.w,
                          ),
                          Text('Nrr',
                              style: textMethod(
                                  Color.fromARGB(255, 241, 130, 3),
                                  14.sp,
                                  FontWeight.normal,
                                  'Mulish-ExtraBold')),
                        ],
                      ),
                    ],
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: pointstableItems.length,
                      itemBuilder: (context, index) {
                        final item = pointstableItems[index];
                        return Column(
                          children: [
                            SizedBox(
                              height: 5.h,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: 30.h,
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Image.network(
                                        item.teamImage,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          print(
                                              'News Image Url ${item.teamImage}');
                                          return Image.asset(
                                            'assets/images/default-image.png', // Replace with your fallback image
                                          );
                                        },
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Expanded(
                                        child: Text(item.teamname,
                                            style: textMethod(
                                                Colors.white,
                                                14.sp,
                                                FontWeight.normal,
                                                'SpaceGrotesk-Regular')),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(item.matchplayed,
                                          style: textMethod(
                                              Colors.white,
                                              14.sp,
                                              FontWeight.normal,
                                              'SpaceGrotesk-Regular')),
                                      SizedBox(
                                        width: 3.w,
                                      ),
                                      Text(item.matchwon,
                                          style: textMethod(
                                              Colors.white,
                                              14.sp,
                                              FontWeight.normal,
                                              'SpaceGrotesk-Regular')),
                                      SizedBox(
                                        width: 3.w,
                                      ),
                                      Text(item.matchlost,
                                          style: textMethod(
                                              Colors.white,
                                              14.sp,
                                              FontWeight.normal,
                                              'SpaceGrotesk-Regular')),
                                      SizedBox(
                                        width: 3.w,
                                      ),
                                      Text(item.matchnoresult,
                                          style: textMethod(
                                              Colors.white,
                                              14.sp,
                                              FontWeight.normal,
                                              'SpaceGrotesk-Regular')),
                                      SizedBox(
                                        width: 3.w,
                                      ),
                                      Text(item.matchpoints,
                                          style: textMethod(
                                              Colors.white,
                                              14.sp,
                                              FontWeight.normal,
                                              'SpaceGrotesk-Regular')),
                                      SizedBox(
                                        width: 3.w,
                                      ),
                                      Text(item.matchrunrate,
                                          style: textMethod(
                                              Colors.white,
                                              14.sp,
                                              FontWeight.normal,
                                              'SpaceGrotesk-Regular')),
                                      // Text('${item.matchid}'),
                                    ],
                                  ),
                                ),

                                // Add your condition here
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      // Toggle visibility based on the index or any condition
                                      item.isContainerVisible =
                                          !item.isContainerVisible;
                                      directionValue = item.matchid;
                                      print('Check Value: $directionValue');
                                    });
                                  },
                                  child: pointstableItems[index]
                                          .isContainerVisible
                                      ? Icon(Icons.keyboard_arrow_up_outlined)
                                      : Icon(
                                          Icons.keyboard_arrow_down_outlined),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: item.isContainerVisible,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: opponentData.length,
                                itemBuilder: (context, index) {
                                  final item = opponentData[index];
                                  if (item.opponentMaitchId == directionValue) {
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Expanded(
                                          child: Text(item.opponent,
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                        Expanded(
                                          child: Text(item.date,
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                        Expanded(
                                          child: Text(item.result,
                                              style: TextStyle(
                                                  color: Colors.white54)),
                                        ),
                                        // Text('${item.opponentMaitchId}'),
                                      ],
                                    );
                                  } else {
                                    return SizedBox
                                        .shrink(); // If directionValue doesn't match, return an empty widget
                                  }
                                },
                              ),
                            ),
                          ],
                        );
                      }),
                ],
              ),
      ),
    );
  }
}
