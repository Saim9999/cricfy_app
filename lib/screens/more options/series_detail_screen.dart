import 'package:crickfy_app/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SeriesName {
  final String seriesTitle;
  final String seriesDetail;

  SeriesName({required this.seriesTitle, required this.seriesDetail});
}

class ScheduleData {
  final String matchDate;
  final String matchTime;
  final String matchTitle;
  final String stadiumName;
  final String matchStatus;
  final String gmtTime;
  final String localTime;

  ScheduleData({
    required this.matchDate,
    required this.matchTime,
    required this.matchTitle,
    required this.stadiumName,
    required this.matchStatus,
    required this.gmtTime,
    required this.localTime,
  });
}

class SeriesDetail extends StatefulWidget {
  final String seriesurl;

  const SeriesDetail({super.key, required this.seriesurl});

  @override
  State<SeriesDetail> createState() => _SeriesDetailState();
}

class _SeriesDetailState extends State<SeriesDetail> {
  final List<SeriesName> seriesName = [];
  final List<ScheduleData> scheduleData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    seriesDetail();
  }

  Future<void> seriesDetail() async {
    if (!mounted) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    final response = await http.get(
      Uri.parse(widget.seriesurl),
    );
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

        print('Series Title : $title');
        print('Series Detail : $detail');
        seriesName.add(SeriesName(seriesTitle: title, seriesDetail: detail));
      }

      final elements = document.querySelectorAll('.cb-series-matches');
      for (var element in elements) {
        final timestamp = element
            .querySelector('.cb-col-40.cb-col.cb-srs-mtchs-tm .schedule-date')
            ?.attributes['timestamp'];
        final scheduleDate = timestamp != null ? int.tryParse(timestamp) : null;
        if (scheduleDate != null) {
          final date = DateTime.fromMillisecondsSinceEpoch(scheduleDate);
          final realdate = DateFormat('EEEE, MMMM dd, yyyy').format(date);
          final realtime = DateFormat('h:mm a').format(date);

          final matchTitle =
              element.querySelector('.cb-srs-mtchs-tm span')?.text ?? '';
          final stadiumDetails = element.querySelectorAll('.text-gray');
          final stadiumName = stadiumDetails[0].text;
          final matchResult =
              element.querySelector('.cb-text-complete')?.text ??
                  'Match starts at $realdate';
          final timeElements =
              element.querySelectorAll('div.cb-font-12.text-gray > span');
          final gmtTime = timeElements[0].text;
          final localTime = timeElements[1].text.trim().replaceAll('  ', '');
          final matchLink =
              element.querySelector('a')!.attributes['href'] ?? '';

          // final response =
          //     await http.get(Uri.parse('https://cricbuzz.com$matchLink'));
          // if (response.statusCode == 200) {
          //   final document = html.parse(response.body);
          //   final elements = document.querySelectorAll('.cb-min-comp');
          //   for (var element in elements) {
          //     final teamScore1 = ?
          //         element.querySelector('.cb-scrs-wrp .cb-min-tm')?.text? '';
          //     final teamScore2 = element
          //             .querySelector('.cb-scrs-wrp .cb-min-tm')!
          //             .nextElementSibling
          //             ?.text ??
          //         '';
          //     print('Team Score 1 : $teamScore1');
          //     print('Team Score 2 : $teamScore2');
          //   }
          // }

          print('Formatted Date: $realdate');
          print('Formated Time: $realtime');
          print('Match Title: $matchTitle');
          print('Stadium Name: $stadiumName');
          print('Match Status: $matchResult');
          print('GMT Time: $gmtTime');
          print('Local Time: $localTime');
          print('Match Link: $matchLink');

          scheduleData.add(ScheduleData(
              matchDate: realdate,
              matchTime: realtime,
              matchTitle: matchTitle,
              stadiumName: stadiumName,
              matchStatus: matchResult,
              gmtTime: gmtTime,
              localTime: localTime));
        }
      }

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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: scheduleData.length,
                      itemBuilder: (context, index) {
                        final item = scheduleData[index];
                        return Container(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                                height: 20.h,
                                width: double.infinity,
                                color: Colors.black.withOpacity(0.5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(item.matchDate,
                                        style: textMethod(
                                            Colors.white,
                                            14.sp,
                                            FontWeight.normal,
                                            'Mulish-ExtraBold')),
                                    Text(item.matchTime,
                                        style: textMethod(
                                            Colors.white,
                                            14.sp,
                                            FontWeight.normal,
                                            'Mulish-ExtraBold')),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(item.matchTitle,
                                    style: textMethod(
                                        Colors.white,
                                        15.sp,
                                        FontWeight.bold,
                                        'SpaceGrotesk-Regular')),
                              ),
                              SizedBox(
                                height: 3.h,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(item.stadiumName,
                                    style: textMethod(
                                        Colors.grey,
                                        14.sp,
                                        FontWeight.bold,
                                        'SpaceGrotesk-Regular')),
                              ),
                              SizedBox(
                                height: 3.h,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(item.matchStatus,
                                    style: textMethod(
                                        Colors.blue,
                                        14.sp,
                                        FontWeight.bold,
                                        'SpaceGrotesk-Regular')),
                              ),
                              SizedBox(
                                height: 3.h,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                    '${item.gmtTime} GMT / ${item.localTime} LOCAL',
                                    style: textMethod(
                                        Colors.white,
                                        13.sp,
                                        FontWeight.bold,
                                        'SpaceGrotesk-Regular')),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
        ));
  }
}
