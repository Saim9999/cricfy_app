import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:intl/intl.dart';

class NewsRoughScreen extends StatefulWidget {
  const NewsRoughScreen({super.key});

  @override
  State<NewsRoughScreen> createState() => News_RoughStateScreen();
}

class News_RoughStateScreen extends State<NewsRoughScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    if (!mounted) {
      // Check if the widget is still mounted before proceeding
      return;
    }
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse(
        'https://www.cricbuzz.com/cricket-series/7476/icc-mens-t20-world-cup-2024/matches'));

    if (response.statusCode == 200) {
      final document = html.parse(response.body);

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

          List<String> parts = matchTitle.split('vs');
          String team1 = parts[0].trim();
          List<String> parts1 = matchTitle.split('vs ');
          String team2 = parts1[1].split(',')[0];
          List<String> parts2 = matchTitle.split(',');
          String matchno = parts2[1].trim();
          List<String> parts3 = matchTitle.split(',');
          // String group = parts3[2].trim();
          String group = parts3.length > 2 ? parts3[2].trim() : '';

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

          print('Formatted Date: $realdate');
          print('Formated Time: $realtime');
          print('Team 1: $team1');
          print('Team 2: $team2');
          print('Match No. : $matchno');
          if (group.isNotEmpty) {
            print('Group : $group');
          }
          // print('Extract Title: $extractTitle');
          // print('Extract Title 1: $extractTitle1');
          print('Match Title: $matchTitle');
          print('Stadium Name: $stadiumName');
          print('Match Status: $matchResult');
          print('GMT Time: $gmtTime');
          print('Local Time: $localTime');
          print('Match Link: $matchLink');
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
      appBar: AppBar(
        title: Text('Rough Screen'),
      ),
    );
  }
}
