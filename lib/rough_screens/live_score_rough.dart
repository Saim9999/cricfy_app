import 'package:crickfy_app/rough_screens/scorecard_rough.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;


class MatchItem {
  final String matchTitle;
  final String matchFormat;
  final String team1Name;
  final String team1Score;
  final String team2Name;
  final String team2Score;
  final String matchResult;
  final String team1Flag;
  final String team2Flag;
  final String linkurl;

  MatchItem({
    required this.matchTitle,
    required this.matchFormat,
    required this.team1Name,
    required this.team1Score,
    required this.team2Name,
    required this.team2Score,
    required this.matchResult,
    required this.team1Flag,
    required this.team2Flag,
    required this.linkurl,
  });
}

class LiveScoreRough extends StatefulWidget {
  const LiveScoreRough({super.key});

  @override
  State<LiveScoreRough> createState() => _LiveScoreRoughState();
}

class _LiveScoreRoughState extends State<LiveScoreRough> {
  final List<MatchItem> matchItems = [];

  @override
  void initState() {
    super.initState();
    fetchMatches();
  }

  Future<void> fetchMatches() async {
    setState(() {
      matchItems.clear();
    });
    final response = await http.get(
      Uri.parse('https://www.cricbuzz.com/'),
    );

    if (response.statusCode == 200) {
      final document = html.parse(response.body);

      final matchCardElements = document
          .querySelectorAll('.cb-view-all-ga.cb-match-card.cb-bg-white');

      for (var matchCardElement in matchCardElements) {
        final matchHeaderElement = matchCardElement.querySelector(
            '.cb-mtch-crd-hdr .cb-col-90.cb-color-light-sec.cb-ovr-flo');
        final matchFormatElement =
            matchCardElement.querySelector('.cb-card-match-format');
        final team1NameElement = matchCardElement
            .querySelector('.cb-hmscg-tm-bat-scr.cb-font-14 span')!
            .attributes['title'];
        final team2NameElement = matchCardElement
            .querySelector('.cb-hmscg-tm-bwl-scr.cb-font-14 span')!
            .attributes['title'];
        final team1ScoreElement = matchCardElement
            .querySelector('.cb-col-50.cb-ovr-flo[style*="width:100%"]');
        final team2ScoreElement = matchCardElement.querySelector(
            '.cb-hmscg-tm-bwl-scr.cb-font-14 .cb-col-50.cb-ovr-flo[style*="width:100%"]');
        final matchResultElement =
            matchCardElement.querySelector('.cb-mtch-crd-state');
        final team1FlagElement =
            matchCardElement.querySelector('.cb-hmscg-tm-nm-img img');
        final team2FlagElement = matchCardElement.querySelector(
            '.cb-hmscg-tm-bwl-scr.cb-font-14 .cb-hmscg-tm-nm-img img');
        final link = matchCardElement.querySelector('a');

        // Extract and print the content
        final matchTitle = matchHeaderElement?.text ?? '';
        final matchFormat = matchFormatElement?.text ?? '';
        final team1Name = team1NameElement;
        final team1Score = team1ScoreElement?.text ?? '';
        final team2Name = team2NameElement;
        final team2Score = team2ScoreElement?.text ?? '';
        final matchResult = matchResultElement?.text ?? '';
        final team1Flag = team1FlagElement?.attributes['src'] ?? '';
        final team2Flag = team2FlagElement?.attributes['src'] ?? '';
        final linkurl = link?.attributes['href'] ?? '';

        print('Match Title: $matchTitle');
        print('Match Format: $matchFormat');
        print('Team 1 Name: $team1Name');
        print('Team 1 Score: $team1Score');
        print('Team 2 Name: $team2Name');
        print('Team 2 Score: $team2Score');
        print('Match Result: $matchResult');
        print('Team 1 Image URL: $team1Flag');
        print('Team 2 Image URL: $team2Flag');
        print('Match Link: $linkurl');
        // print('Time: $date');

        matchItems.add(MatchItem(
          matchTitle: matchTitle,
          matchFormat: matchFormat,
          team1Name: team1Name!,
          team1Score: team1Score,
          team2Name: team2Name!,
          team2Score: team2Score,
          matchResult: matchResult,
          team1Flag: team1Flag,
          team2Flag: team2Flag,
          linkurl: linkurl,
        ));
      }

      setState(() {});
    } else {
      print('Failed to fetch matches: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: matchItems.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: fetchMatches,
              child: ListView.builder(
                itemCount: matchItems.length,
                itemBuilder: (context, index) {
                  final matchItem = matchItems[index];
                  return InkWell(
                    onTap: () async {
                      String originalUrl =
                          "https://www.cricbuzz.com${matchItem.linkurl}";
                      String modifiedUrl = originalUrl.replaceFirst(
                          "/live-cricket-scores/", "/live-cricket-scorecard/");
                      Get.to(ScorecardRough(url: modifiedUrl));
                      print('Lint Url wwhdhwdh: $modifiedUrl');
                      // String originalUrl =
                      //     "https://www.cricbuzz.com${matchItem.linkurl}";
                      // if (await canLaunchUrl(originalUrl)) {
                      //   await launchUrl(originalUrl);
                      // } else {
                      //   print("Could not launch player profile.");
                      // }
                      // Get.to(CommentaryRough(url: originalUrl));
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        Text('Match Title: ${matchItem.matchTitle}'),
                        Text('Match format: ${matchItem.matchFormat}'),
                        Text('Team 1 Name: ${matchItem.team1Name}'),
                        Text('Team 1 Score: ${matchItem.team1Score}'),
                        Text('Team 2 Name: ${matchItem.team2Name}'),
                        Text('Team 2 Score: ${matchItem.team2Score}'),
                        Text('Match Result: ${matchItem.matchResult}'),
                        SizedBox(
                          height: 5.h,
                        ),
                        Image.network(
                            'https://www.cricbuzz.com/${matchItem.team1Flag}'),
                        SizedBox(
                          height: 5.h,
                        ),
                        Image.network(
                            'https://www.cricbuzz.com/${matchItem.team2Flag}'),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
