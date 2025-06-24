import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;

class RoughPointsTable extends StatefulWidget {
  const RoughPointsTable({super.key});

  @override
  State<RoughPointsTable> createState() => _RoughPointsTableState();
}

class _RoughPointsTableState extends State<RoughPointsTable> {
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
        'https://www.cricbuzz.com/cricket-series/7607/indian-premier-league-2024/stats'));

    if (response.statusCode == 200) {
      final document = html.parse(response.body);

      ////////////////////////////////

      // final divElement1 = document.querySelector('.cb-col-20');
      // final aElement1 = divElement1!
      // .querySelectorAll('a')
      // .firstWhere((element) => element.id == '44312');
      // final aElement2 = divElement1
      //     .querySelectorAll('a')
      //     .firstWhere((element) => element.id == '44834');
      //     print(aElement1.text);
      //     print(aElement2.text);

      ///////////////////////////

      // final squadPlayersDiv =
      //     document.querySelectorAll('[ng-click="set_filters(44834,7679)"]');
      // for (var element in squadPlayersDiv) {
      //   print(element.text);
      // }

      /////////////////////////

      // // Get the element with id "squadPlayers"
      // final squadPlayersDiv = document.querySelector('#squadPlayers');

      // // Check if the element exists
      // if (squadPlayersDiv != null) {
      //   // Iterate over all the children of squadPlayersDiv
      //   for (var child in squadPlayersDiv.children) {
      //     // Check if the child is a heading element
      //     if (child.localName == 'h3') {
      //       print('Role: ${child.text}'); // Print the role
      //     } else if (child.localName == 'a') {
      //       // If it's an anchor tag, get the player details
      //       String playerName = child.querySelector('.cb-font-16')?.text ?? '';
      //       String playerRole =
      //           child.querySelector('.cb-text-gray')?.text ?? '';
      //       String playerLink = child.attributes['href'] ?? '';
      //       print('Name: $playerName, Role: $playerRole, Link: $playerLink');
      //     }
      //   }
      // }

      ///////////////////////////
      // for fetchind teams id & names
      //  final anchorElement = document.querySelectorAll('a.cb-stats-lft-ancr');
      // for (var team in anchorElement) {
      //   String id = team.id;
      //   String teamName = team.innerHtml;
      //   print('ID: $id');
      //   print('Team Name: $teamName');
      // }

      ///////////////////////////////
      // var divElement = document.querySelector('.cb-col-20');
      // var teamLinks = document.querySelectorAll('.cb-series-brdr');

      // // Print the text content of the elements
      // print(divElement?.text);
      // for (var teamLink in teamLinks) {
      //   print(teamLink.text);
      // }

      //////////////////////////////////

      // final battingElement = document.querySelector(
      //     '.cb-col.cb-col-100.cb-series-brdr.cb-stats-lft-ancr[href^=""][ng-class*="selectedTab == \'mostRuns\'"]');
      // print(battingElement!.text);

      // final statsTable = document.querySelectorAll('.cb-srs-stats-tr');
      // for (var link in statsTable) {
      //   print(link.text);
      // }

      ////////////////////////////////

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
        title: Text('Rough Points Table'),
      ),
    );
  }
}
