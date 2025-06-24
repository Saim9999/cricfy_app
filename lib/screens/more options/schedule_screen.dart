import 'package:crickfy_app/screens/more%20options/series_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../utils/text_style.dart';

class SeriesMatch {
  final String name;
  final String url;
  final String date;

  SeriesMatch({required this.name, required this.url, required this.date});
}

class ScheduleScreen extends StatefulWidget {
  final String type;
  const ScheduleScreen({super.key, required this.type});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  Map<String, List<SeriesMatch>> groupedMatches = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAndGroupSeries();
  }

  Future<void> fetchAndGroupSeries() async {
    if (!mounted) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse('https://www.cricbuzz.com/cricket-schedule/series/${widget.type}'),
    );

    if (response.statusCode == 200) {
      final document = html.parse(response.body);
      final matchSections = document.querySelectorAll(
        '.cb-col-100.cb-col',
      ); // Each month block

      for (var section in matchSections) {
        final monthHeader =
            section.querySelector('.cb-mnth')?.text.trim() ?? '';

        if (monthHeader.isEmpty) continue;

        final seriesItems = section.querySelectorAll('.cb-sch-lst-itm');
        final matches = <SeriesMatch>[];

        for (var item in seriesItems) {
          final name = item.querySelector('span.text-black')?.text.trim() ?? '';
          final url = item.querySelector('a')?.attributes['href'] ?? '';
          final date =
              item.querySelector('.text-gray.cb-font-12')?.text.trim() ?? '';

          if (name.isNotEmpty) {
            matches.add(SeriesMatch(name: name, url: url, date: date));
          }
        }
        if (matches.isNotEmpty) {
          groupedMatches[monthHeader] = matches;
        }
      }

      if (!mounted) {
        return;
      }
      setState(() {
        isLoading = false;
      });
    } else {
      print('Failed to load schedule: ${response.statusCode}');
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
    final months = groupedMatches.keys.toList();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 15, 19, 1),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Rectangle 6370.png'),
            fit: BoxFit.cover,
          ),
        ),
        child:
            isLoading
                ? Center(
                  child: LoadingAnimationWidget.horizontalRotatingDots(
                    size: 50,
                    color: Color.fromARGB(255, 114, 255, 48),
                  ),
                )
                : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                          ),
                          Text(
                            'Cricket Schedule',
                            style: textMethod(
                              Colors.white,
                              20.sp,
                              FontWeight.bold,
                              'Mulish-ExtraBold',
                            ),
                          ),
                        ],
                      ),
                      ListView.builder(
                        itemCount: months.length,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemBuilder: (context, index) {
                          final month = months[index];
                          final matches = groupedMatches[month]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 🟡 Month Header
                              Container(
                                width: double.infinity,
                                color: Colors.grey[300],
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 16,
                                ),
                                child: Text(
                                  month,
                                  style: textMethod(
                                    Colors.black,
                                    18.sp,
                                    FontWeight.normal,
                                    'Mulish-ExtraBold',
                                  ),
                                ),
                              ),

                              // 🟢 Series List for that Month
                              ...matches.map(
                                (match) => ListTile(
                                  title: Text(
                                    match.name,
                                    style: textMethod(
                                      Colors.white,
                                      16.sp,
                                      FontWeight.normal,
                                      'Mulish-ExtraBold',
                                    ),
                                  ),
                                  subtitle: Text(
                                    match.date,
                                    style: textMethod(
                                      Colors.grey.shade400,
                                      14.sp,
                                      FontWeight.normal,
                                      'SpaceGrotesk-Regular',
                                    ),
                                  ),
                                  onTap: () async {
                                    // TODO: Navigate to detail page using match.url
                                    Get.to(
                                      SeriesDetail(
                                        seriesurl:
                                            'https://www.cricbuzz.com/${match.url}',
                                      ),
                                    );
                                    print("Tapped: ${match.url}");
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
