import 'package:crickfy_app/screens/scorecard/squad_info_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../utils/text_style.dart';

class SquadInfo extends StatefulWidget {
  final String url;
  const SquadInfo({super.key, required this.url});

  @override
  State<SquadInfo> createState() => _SquadInfoState();
}

class _SquadInfoState extends State<SquadInfo> {
  final List<FirstPlayingXIItem> firstPlayingXIItem = [];
  final List<SecondPlayingXIItem> secondPlayingXIItem = [];
  final List<FirstBenchPlayersItem> firstBenchPlayersItem = [];
  final List<SecondBenchPlayersItem> secondBenchPlayersItem = [];
  final List<FirstSupportStaff> firstSupportStaff = [];
  final List<SecondSupportStaff> secondSupportStaff = [];
  final List<TeamHeaderItem> teamHeaderItem = [];
  final List<SquadorPlaying> squadorPlaying = [];
  final List<BenchPlayers> benchPlayers = [];
  final List<SupportStaffHeading> supportStaffHeading = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    squadInfo();
  }

  Future<void> squadInfo() async {
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

      final teamsHeaderElement =
          document.querySelector('.cb-col.cb-col-100.cb-teams-hdr');
      if (teamsHeaderElement != null) {
        final team1Element = teamsHeaderElement.querySelector('.cb-team1');
        final team1ImageSrc =
            team1Element!.querySelector('img')?.attributes['src'] ?? '';
        final team1Name = team1Element.querySelectorAll('.pad5')[1].text.trim();

        final team2Element = teamsHeaderElement.querySelector('.cb-team2');
        final team2ImageSrc =
            team2Element!.querySelector('img')?.attributes['src'] ?? '';
        final team2Name = team2Element
                .querySelector('.pad5')!
                .nextElementSibling
                ?.text
                .trim() ??
            '';
        print('Team 1 Image Src: $team1ImageSrc');
        print('Team 1 Name: $team1Name');

        print('Team 2 Image Src: $team2ImageSrc');
        print('Team 2 Name: $team2Name');

        teamHeaderItem.add(TeamHeaderItem(
            team1Name: team1Name,
            team1ImageSrc: team1ImageSrc,
            team2ImageSrc: team2ImageSrc,
            team2Name: team2Name));
      }

      ///////////////////////////
      final headingLabel = document
              .querySelector(
                  '.cb-col.cb-col-100.cb-pl11-hdr.text-bold.text-center.cb-font-16')
              ?.text ??
          '';
      print('Heading Label : $headingLabel');
      squadorPlaying.add(SquadorPlaying(squadorPlaying: headingLabel));
      extractPlayingXIItem(document, firstPlayingXIItem, 'lft', 'left');
      extractPlayingXIItem(document, secondPlayingXIItem, 'rt', 'right');

      ////////////////////
      final headingLabel1 = document
          .querySelectorAll(
              '.cb-col.cb-col-100.cb-pl11-hdr.text-bold.text-center.cb-font-16')[1]
          .text;
      print('Heading Label : $headingLabel1');
      benchPlayers.add(BenchPlayers(benchPlayers: headingLabel1));
      extractBenchPlayersItem(
          document, firstBenchPlayersItem, 'lft', 'left', 1);
      extractBenchPlayersItem(
          document, secondBenchPlayersItem, 'rt', 'right', 1);

      /////////////////////////////
      final headingLabel2 = document.querySelectorAll(
          '.cb-col.cb-col-100.cb-pl11-hdr.text-bold.text-center.cb-font-16');
      if (headingLabel2.isNotEmpty && headingLabel2.length > 2) {
        final headingLabel2query = headingLabel2[2].text;
        print('Heading Label : $headingLabel2query');
        supportStaffHeading
            .add(SupportStaffHeading(supportStaff: headingLabel2query));
      }
      extractSupportStaffItem(document, firstSupportStaff, 'lft', 'left', 2);
      extractSupportStaffItem(document, secondSupportStaff, 'rt', 'right', 2);
      //////////////////////////////

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
              : ListView(children: [
                  listbuilderMethod(
                      teamHeaderItem,
                      (item) => Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 20.h,
                                      width: 30.h,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(2.r),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  '${item.team1ImageSrc}'),
                                              fit: BoxFit.fill)),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Text(
                                      item.team1Name,
                                      style: textMethod(Colors.white, 16.sp,
                                          FontWeight.bold, 'Mulish-ExtraBold'),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 20.h,
                                      width: 30.h,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(2.r),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  '${item.team2ImageSrc}'),
                                              fit: BoxFit.fill)),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Text(
                                      item.team2Name,
                                      style: textMethod(Colors.white, 16.sp,
                                          FontWeight.bold, 'Mulish-ExtraBold'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                  Divider(
                    color: Colors.white,
                    thickness: 1,
                  ),
                  listbuilderMethod(
                      squadorPlaying,
                      (item) => Center(
                            child: Text(
                              item.squadorPlaying,
                              style: textMethod(Colors.white, 16.sp,
                                  FontWeight.bold, 'SpaceGrotesk-Regular'),
                            ),
                          )),
                  Divider(
                    color: Colors.white,
                    thickness: 1,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 3,
                          child: listbuilderMethod(
                              firstPlayingXIItem,
                              (item) => ListTile(
                                    visualDensity: VisualDensity.compact,
                                    contentPadding: EdgeInsets.only(left: 4),
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage('${item.imageUrl}'),
                                    ),
                                    title: Text(
                                      item.name,
                                      style: textMethod(
                                          Colors.white,
                                          12.sp,
                                          FontWeight.normal,
                                          'Mulish-ExtraBold'),
                                    ),
                                    subtitle: Text(
                                      item.role,
                                      style: textMethod(
                                          Colors.grey,
                                          12.sp,
                                          FontWeight.normal,
                                          'SpaceGrotesk-Regular'),
                                    ),
                                  ))),
                      Expanded(
                          flex: 1,
                          child: VerticalDivider(
                            color: Colors.amber,
                          )),
                      Expanded(
                          flex: 3,
                          child: listbuilderMethod(
                              secondPlayingXIItem,
                              (item) => ListTile(
                                    contentPadding: EdgeInsets.only(right: 4),
                                    visualDensity: VisualDensity.compact,
                                    trailing: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage('${item.imageUrl}'),
                                    ),
                                    title: Text(
                                      item.name,
                                      style: textMethod(
                                          Colors.white,
                                          12.sp,
                                          FontWeight.normal,
                                          'Mulish-ExtraBold'),
                                    ),
                                    subtitle: Text(
                                      item.role,
                                      style: textMethod(
                                          Colors.grey,
                                          12.sp,
                                          FontWeight.normal,
                                          'SpaceGrotesk-Regular'),
                                    ),
                                  ))),
                    ],
                  ),
                  listbuilderMethod(
                      benchPlayers,
                      (item) => Center(
                            child: Column(
                              children: [
                                Divider(
                                  color: Colors.white,
                                  thickness: 1,
                                ),
                                Text(
                                  item.benchPlayers,
                                  style: textMethod(Colors.white, 16.sp,
                                      FontWeight.bold, 'SpaceGrotesk-Regular'),
                                ),
                                Divider(
                                  color: Colors.white,
                                  thickness: 1,
                                ),
                              ],
                            ),
                          )),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 3,
                          child: listbuilderMethod(
                              firstBenchPlayersItem,
                              (item) => ListTile(
                                    contentPadding: EdgeInsets.only(left: 4),
                                    visualDensity: VisualDensity.compact,
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage('${item.imageUrl}'),
                                    ),
                                    title: Text(
                                      item.name,
                                      style: textMethod(
                                          Colors.white,
                                          12.sp,
                                          FontWeight.normal,
                                          'Mulish-ExtraBold'),
                                    ),
                                    subtitle: Text(
                                      item.role,
                                      style: textMethod(
                                          Colors.grey,
                                          12.sp,
                                          FontWeight.normal,
                                          'SpaceGrotesk-Regular'),
                                    ),
                                  ))),
                      Expanded(
                          flex: 1,
                          child: VerticalDivider(
                            color: Colors.amber,
                          )),
                      Expanded(
                          flex: 3,
                          child: listbuilderMethod(
                              secondBenchPlayersItem,
                              (item) => ListTile(
                                    contentPadding: EdgeInsets.only(right: 4),
                                    visualDensity: VisualDensity.compact,
                                    trailing: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage('${item.imageUrl}'),
                                    ),
                                    title: Text(
                                      item.name,
                                      style: textMethod(
                                          Colors.white,
                                          12.sp,
                                          FontWeight.normal,
                                          'Mulish-ExtraBold'),
                                    ),
                                    subtitle: Text(
                                      item.role,
                                      style: textMethod(
                                          Colors.grey,
                                          12.sp,
                                          FontWeight.normal,
                                          'SpaceGrotesk-Regular'),
                                    ),
                                  ))),
                    ],
                  ),
                  listbuilderMethod(
                      supportStaffHeading,
                      (item) => Center(
                            child: Column(
                              children: [
                                Divider(
                                  color: Colors.white,
                                  thickness: 1,
                                ),
                                Text(
                                  item.supportStaff,
                                  style: textMethod(Colors.white, 16.sp,
                                      FontWeight.bold, 'SpaceGrotesk-Regular'),
                                ),
                                Divider(
                                  color: Colors.white,
                                  thickness: 1,
                                ),
                              ],
                            ),
                          )),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 3,
                          child: listbuilderMethod(
                              firstSupportStaff,
                              (item) => ListTile(
                                    contentPadding: EdgeInsets.only(left: 4),
                                    visualDensity: VisualDensity.compact,
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage('${item.imageUrl}'),
                                    ),
                                    title: Text(
                                      item.name,
                                      style: textMethod(
                                          Colors.white,
                                          12.sp,
                                          FontWeight.normal,
                                          'Mulish-ExtraBold'),
                                    ),
                                    subtitle: Text(
                                      item.role,
                                      style: textMethod(
                                          Colors.grey,
                                          12.sp,
                                          FontWeight.normal,
                                          'SpaceGrotesk-Regular'),
                                    ),
                                  ))),
                      Expanded(
                          flex: 1,
                          child: VerticalDivider(
                            color: Colors.amber,
                          )),
                      Expanded(
                          flex: 3,
                          child: listbuilderMethod(
                              secondSupportStaff,
                              (item) => ListTile(
                                    contentPadding: EdgeInsets.only(right: 4),
                                    visualDensity: VisualDensity.compact,
                                    trailing: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage('${item.imageUrl}'),
                                    ),
                                    title: Text(
                                      item.name,
                                      style: textMethod(
                                          Colors.white,
                                          12.sp,
                                          FontWeight.normal,
                                          'Mulish-ExtraBold'),
                                    ),
                                    subtitle: Text(
                                      item.role,
                                      style: textMethod(
                                          Colors.grey,
                                          12.sp,
                                          FontWeight.normal,
                                          'SpaceGrotesk-Regular'),
                                    ),
                                  ))),
                    ],
                  ),
                ])
        ]));
  }
}
