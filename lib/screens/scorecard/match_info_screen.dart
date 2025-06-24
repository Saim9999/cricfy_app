import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../classes/scorecard_classes.dart';

class MatchInfo extends StatefulWidget {
  final String url;
  const MatchInfo({super.key, required this.url});

  @override
  State<MatchInfo> createState() => _MatchInfoState();
}

class _MatchInfoState extends State<MatchInfo> {
  final List<MatchItem> matchItems = [];
  bool isLoading = true;

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
    setState(() {
      isLoading = true;
    });
    final response = await http.get(
      Uri.parse(widget.url),
    );
    if (response.statusCode == 200) {
      final document = html.parse(response.body);
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
        isLoading = false; // Set isLoading to false in case of failure
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
            : ListView(
                children: [
                  ListView.builder(
                    padding: EdgeInsets.all(8),
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
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Mulish-ExtraBold'),
                              ),
                              Expanded(
                                  child: Text(
                                matchItem.matchvalue,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'SpaceGrotesk-Regular'),
                              )),
                            ],
                          ),
                        ],
                      );
                    },
                  )
                ],
              )
      ]),
    );
  }
}
