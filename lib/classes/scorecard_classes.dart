class MatchStatus {
  final String matchStatus;

  MatchStatus({
    required this.matchStatus,
  });
}

class MatchItem {
  final String matchLabel;
  final String matchvalue;

  MatchItem({
    required this.matchLabel,
    required this.matchvalue,
  });
}

class SquadItem {
  final String squadLabel;

  SquadItem({
    required this.squadLabel,
  });
}

// abstract classes
abstract class ScoreHeaderItem {
  final String inningsTitle;
  final String inningsInfo;
  final String batterHeader;
  final String runsHeader;
  final String ballsHeader;
  final String foursHeader;
  final String sixesHeader;
  final String strikeRateHeader;

  ScoreHeaderItem({
    required this.inningsTitle,
    required this.inningsInfo,
    required this.batterHeader,
    required this.runsHeader,
    required this.ballsHeader,
    required this.foursHeader,
    required this.sixesHeader,
    required this.strikeRateHeader,
  });
}

class FirstScoreHeaderItem extends ScoreHeaderItem {
  FirstScoreHeaderItem({
    required inningsTitle,
    required inningsInfo,
    required batterHeader,
    required runsHeader,
    required ballsHeader,
    required foursHeader,
    required sixesHeader,
    required strikeRateHeader,
  }) : super(
            inningsTitle: inningsTitle,
            inningsInfo: inningsInfo,
            batterHeader: batterHeader,
            runsHeader: runsHeader,
            ballsHeader: ballsHeader,
            foursHeader: foursHeader,
            sixesHeader: sixesHeader,
            strikeRateHeader: strikeRateHeader);
}

class SecondScoreHeaderItem extends ScoreHeaderItem {
  SecondScoreHeaderItem({
    required inningsTitle,
    required inningsInfo,
    required batterHeader,
    required runsHeader,
    required ballsHeader,
    required foursHeader,
    required sixesHeader,
    required strikeRateHeader,
  }) : super(
            inningsTitle: inningsTitle,
            inningsInfo: inningsInfo,
            batterHeader: batterHeader,
            runsHeader: runsHeader,
            ballsHeader: ballsHeader,
            foursHeader: foursHeader,
            sixesHeader: sixesHeader,
            strikeRateHeader: strikeRateHeader);
}

class ThirdScoreHeaderItem extends ScoreHeaderItem {
  ThirdScoreHeaderItem({
    required inningsTitle,
    required inningsInfo,
    required batterHeader,
    required runsHeader,
    required ballsHeader,
    required foursHeader,
    required sixesHeader,
    required strikeRateHeader,
  }) : super(
            inningsTitle: inningsTitle,
            inningsInfo: inningsInfo,
            batterHeader: batterHeader,
            runsHeader: runsHeader,
            ballsHeader: ballsHeader,
            foursHeader: foursHeader,
            sixesHeader: sixesHeader,
            strikeRateHeader: strikeRateHeader);
}

class FourthScoreHeaderItem extends ScoreHeaderItem {
  FourthScoreHeaderItem({
    required inningsTitle,
    required inningsInfo,
    required batterHeader,
    required runsHeader,
    required ballsHeader,
    required foursHeader,
    required sixesHeader,
    required strikeRateHeader,
  }) : super(
            inningsTitle: inningsTitle,
            inningsInfo: inningsInfo,
            batterHeader: batterHeader,
            runsHeader: runsHeader,
            ballsHeader: ballsHeader,
            foursHeader: foursHeader,
            sixesHeader: sixesHeader,
            strikeRateHeader: strikeRateHeader);
}

void extractScoreHeaderItem(document, List user, String inningsId) {
  final extradivs = document.querySelectorAll('#innings_$inningsId');
  for (var innings2Element in extradivs) {
    final inningsTitle =
        innings2Element.querySelector('.cb-scrd-hdr-rw span')?.text ?? '';
    final inningsInfo = innings2Element
            .querySelector('.cb-scrd-hdr-rw span.pull-right')
            ?.text ??
        '';

    final headerRow =
        document.querySelector('.cb-col.cb-col-100.cb-scrd-sub-hdr.cb-bg-gray');
    final headerColumns = headerRow!.querySelectorAll('.cb-col');
    final batterHeader = headerColumns[0].text;
    final runsHeader = headerColumns[2].text;
    final ballsHeader = headerColumns[3].text;
    final foursHeader = headerColumns[4].text;
    final sixesHeader = headerColumns[5].text;
    final strikeRateHeader = headerColumns[6].text;

    print('Innings Title: $inningsTitle $inningsInfo');
    print(
        'Batter Header: $batterHeader $runsHeader $ballsHeader $foursHeader $sixesHeader $strikeRateHeader');

    if (inningsId == '1') {
      user.add(FirstScoreHeaderItem(
          inningsTitle: inningsTitle,
          inningsInfo: inningsInfo,
          batterHeader: batterHeader,
          runsHeader: runsHeader,
          ballsHeader: ballsHeader,
          foursHeader: foursHeader,
          sixesHeader: sixesHeader,
          strikeRateHeader: strikeRateHeader));
    } else if (inningsId == '2') {
      user.add(SecondScoreHeaderItem(
          inningsTitle: inningsTitle,
          inningsInfo: inningsInfo,
          batterHeader: batterHeader,
          runsHeader: runsHeader,
          ballsHeader: ballsHeader,
          foursHeader: foursHeader,
          sixesHeader: sixesHeader,
          strikeRateHeader: strikeRateHeader));
    } else if (inningsId == '3') {
      user.add(ThirdScoreHeaderItem(
          inningsTitle: inningsTitle,
          inningsInfo: inningsInfo,
          batterHeader: batterHeader,
          runsHeader: runsHeader,
          ballsHeader: ballsHeader,
          foursHeader: foursHeader,
          sixesHeader: sixesHeader,
          strikeRateHeader: strikeRateHeader));
    } else if (inningsId == '4') {
      user.add(FourthScoreHeaderItem(
          inningsTitle: inningsTitle,
          inningsInfo: inningsInfo,
          batterHeader: batterHeader,
          runsHeader: runsHeader,
          ballsHeader: ballsHeader,
          foursHeader: foursHeader,
          sixesHeader: sixesHeader,
          strikeRateHeader: strikeRateHeader));
    }
  }
}

abstract class ScorecardItem {
  final String batterName;
  final String dismissal;
  final String runs;
  final String balls;
  final String fours;
  final String sixes;
  final String strikeRate;
  ScorecardItem({
    required this.batterName,
    required this.dismissal,
    required this.runs,
    required this.balls,
    required this.fours,
    required this.sixes,
    required this.strikeRate,
  });
}

class FirstScorecardItem extends ScorecardItem {
  FirstScorecardItem({
    required batterName,
    required dismissal,
    required runs,
    required balls,
    required fours,
    required sixes,
    required strikeRate,
  }) : super(
          batterName: batterName,
          dismissal: dismissal,
          runs: runs,
          balls: balls,
          fours: fours,
          sixes: sixes,
          strikeRate: strikeRate,
        );
}

class SecondScorecardItem extends ScorecardItem {
  SecondScorecardItem({
    required batterName,
    required dismissal,
    required runs,
    required balls,
    required fours,
    required sixes,
    required strikeRate,
  }) : super(
          batterName: batterName,
          dismissal: dismissal,
          runs: runs,
          balls: balls,
          fours: fours,
          sixes: sixes,
          strikeRate: strikeRate,
        );
}

class ThirdScorecardItem extends ScorecardItem {
  ThirdScorecardItem({
    required batterName,
    required dismissal,
    required runs,
    required balls,
    required fours,
    required sixes,
    required strikeRate,
  }) : super(
          batterName: batterName,
          dismissal: dismissal,
          runs: runs,
          balls: balls,
          fours: fours,
          sixes: sixes,
          strikeRate: strikeRate,
        );
}

class FourthScorecardItem extends ScorecardItem {
  FourthScorecardItem({
    required batterName,
    required dismissal,
    required runs,
    required balls,
    required fours,
    required sixes,
    required strikeRate,
  }) : super(
          batterName: batterName,
          dismissal: dismissal,
          runs: runs,
          balls: balls,
          fours: fours,
          sixes: sixes,
          strikeRate: strikeRate,
        );
}

void extractScorecardItem(document, List user, String inningsId) {
  final extradiv = document.querySelector('#innings_$inningsId');
  if (extradiv != null) {
    final players = extradiv.querySelector('.cb-ltst-wgt-hdr');
    if (players != null) {
      final playersList = players.querySelectorAll('.cb-col.cb-scrd-itms');

      for (var playerElement in playersList) {
        final playerName =
            playerElement.querySelector('a.cb-text-link')?.text.trim() ?? '';

        // Skip players with empty names
        if (playerName.isEmpty) {
          continue;
        }
        final dismissal =
            playerElement.querySelector('.text-gray')?.text.trim() ?? '';
        // Skip players with empty names
        if (dismissal.isEmpty) {
          continue;
        }

        final runsElements = playerElement.querySelectorAll('.text-right');
        final runs = runsElements.isNotEmpty ? runsElements[0].text.trim() : '';

        final ballsElementList = playerElement.querySelectorAll('.text-right');
        final balls =
            ballsElementList.length > 1 ? ballsElementList[1].text.trim() : '';

        final textRightElements = playerElement.querySelectorAll('.text-right');
        final fours = textRightElements.length > 2
            ? textRightElements[2].text.trim()
            : '';

        final cbColElements = playerElement.querySelectorAll('.cb-col');
        final sixes =
            cbColElements.length > 5 ? cbColElements[5].text.trim() : '';

        final strikeRateElements =
            playerElement.querySelectorAll('.text-right');
        final strikeRate = strikeRateElements.length > 3
            ? strikeRateElements[3].text.trim()
            : '';

        print(
            'Player Name: $playerName $dismissal $runs $balls $fours $sixes $strikeRate');
        if (inningsId == '1') {
          user.add(
            FirstScorecardItem(
                batterName: playerName,
                dismissal: dismissal,
                runs: runs,
                balls: balls,
                fours: fours,
                sixes: sixes,
                strikeRate: strikeRate),
          );
        } else if (inningsId == '2') {
          user.add(SecondScorecardItem(
              batterName: playerName,
              dismissal: dismissal,
              runs: runs,
              balls: balls,
              fours: fours,
              sixes: sixes,
              strikeRate: strikeRate));
        } else if (inningsId == '3') {
          user.add(ThirdScorecardItem(
              batterName: playerName,
              dismissal: dismissal,
              runs: runs,
              balls: balls,
              fours: fours,
              sixes: sixes,
              strikeRate: strikeRate));
        } else if (inningsId == '4') {
          user.add(FourthScorecardItem(
              batterName: playerName,
              dismissal: dismissal,
              runs: runs,
              balls: balls,
              fours: fours,
              sixes: sixes,
              strikeRate: strikeRate));
        }
      }
    }
  }
}

abstract class TotalScoreItem {
  final String extrasLabel;
  final String extrasValue;
  final String extrasDetails;
  final String totalLabel;
  final String totalValue;
  final String totalDetails;
  final String yettobatLabel;
  final String yettobatPlayers;
  final String fallofwicketsLabel;
  final String fallofWickets;

  TotalScoreItem({
    required this.extrasLabel,
    required this.extrasValue,
    required this.extrasDetails,
    required this.totalLabel,
    required this.totalValue,
    required this.totalDetails,
    required this.yettobatLabel,
    required this.yettobatPlayers,
    required this.fallofwicketsLabel,
    required this.fallofWickets,
  });
}

class FirstTotalScoreItem extends TotalScoreItem {
  FirstTotalScoreItem({
    required extrasLabel,
    required extrasValue,
    required extrasDetails,
    required totalLabel,
    required totalValue,
    required totalDetails,
    required yettobatLabel,
    required yettobatPlayers,
    required fallofwicketsLabel,
    required fallofWickets,
  }) : super(
          extrasLabel: extrasLabel,
          extrasValue: extrasValue,
          extrasDetails: extrasDetails,
          totalLabel: totalLabel,
          totalValue: totalValue,
          totalDetails: totalDetails,
          yettobatLabel: yettobatLabel,
          yettobatPlayers: yettobatPlayers,
          fallofwicketsLabel: fallofwicketsLabel,
          fallofWickets: fallofWickets,
        );
}

class SecondTotalScoreItem extends TotalScoreItem {
  SecondTotalScoreItem({
    required extrasLabel,
    required extrasValue,
    required extrasDetails,
    required totalLabel,
    required totalValue,
    required totalDetails,
    required yettobatLabel,
    required yettobatPlayers,
    required fallofwicketsLabel,
    required fallofWickets,
  }) : super(
          extrasLabel: extrasLabel,
          extrasValue: extrasValue,
          extrasDetails: extrasDetails,
          totalLabel: totalLabel,
          totalValue: totalValue,
          totalDetails: totalDetails,
          yettobatLabel: yettobatLabel,
          yettobatPlayers: yettobatPlayers,
          fallofwicketsLabel: fallofwicketsLabel,
          fallofWickets: fallofWickets,
        );
}

class ThirdTotalScoreItem extends TotalScoreItem {
  ThirdTotalScoreItem({
    required extrasLabel,
    required extrasValue,
    required extrasDetails,
    required totalLabel,
    required totalValue,
    required totalDetails,
    required yettobatLabel,
    required yettobatPlayers,
    required fallofwicketsLabel,
    required fallofWickets,
  }) : super(
          extrasLabel: extrasLabel,
          extrasValue: extrasValue,
          extrasDetails: extrasDetails,
          totalLabel: totalLabel,
          totalValue: totalValue,
          totalDetails: totalDetails,
          yettobatLabel: yettobatLabel,
          yettobatPlayers: yettobatPlayers,
          fallofwicketsLabel: fallofwicketsLabel,
          fallofWickets: fallofWickets,
        );
}

class FourthTotalScoreItem extends TotalScoreItem {
  FourthTotalScoreItem({
    required extrasLabel,
    required extrasValue,
    required extrasDetails,
    required totalLabel,
    required totalValue,
    required totalDetails,
    required yettobatLabel,
    required yettobatPlayers,
    required fallofwicketsLabel,
    required fallofWickets,
  }) : super(
          extrasLabel: extrasLabel,
          extrasValue: extrasValue,
          extrasDetails: extrasDetails,
          totalLabel: totalLabel,
          totalValue: totalValue,
          totalDetails: totalDetails,
          yettobatLabel: yettobatLabel,
          yettobatPlayers: yettobatPlayers,
          fallofwicketsLabel: fallofwicketsLabel,
          fallofWickets: fallofWickets,
        );
}

void extractTotalScoreItem(document, List user, String inningsId) {
  final extradiv = document.querySelector('#innings_$inningsId');
  if (extradiv != null) {
    final extrasLabel =
        extradiv.querySelector('.cb-col.cb-col-60')?.text.trim() ?? '';
    final extrasValue = extradiv
            .querySelector('.text-bold.cb-text-black.text-right')
            ?.text
            .trim() ??
        '';
    final extrasDetails =
        extradiv.querySelector('.cb-col-32.cb-col')?.text.trim() ?? '';
    print('Extras Data: $extrasLabel $extrasValue $extrasDetails');

    // Select the Total div
    final totalDiv = extradiv;
    // Extract Total data
    final totalLabel = 'Total';
    final totalValue = extradiv
            .querySelector('.text-bold.text-black.text-right')
            ?.text
            .trim() ??
        '';
    final totalDetails =
        extradiv.querySelectorAll('.cb-col-32.cb-col')[1].text.trim();
    print('Total Data: $totalLabel $totalValue $totalDetails');

    // Extract data for the "Yet to Bat" section
    final yetToBatDiv =
        extradiv.querySelector('.cb-col-100.cb-scrd-itms:last-child');
    final yetToBatLabel =
        yetToBatDiv!.querySelector('.cb-col.cb-col-27')?.text.trim() ?? '';
    final yetToBatPlayers = yetToBatDiv
            .querySelector('.cb-col-73.cb-col')
            ?.text
            .trim()
            .replaceAll(' , ', '\n') ??
        '';

    if (yetToBatLabel.isNotEmpty && yetToBatPlayers.isNotEmpty) {
      print('Yet to Bat: \n$yetToBatLabel \n$yetToBatPlayers');
    }

    // Extract data for the "Fall of Wickets" section
    final fallOfwicketsLabel = extradiv
            .querySelector('.cb-scrd-sub-hdr.cb-bg-gray.text-bold')
            ?.text
            .trim() ??
        '';
    final fallOfWickets = extradiv
            .querySelector('.cb-col.cb-col-100.cb-col-rt.cb-font-13')
            ?.text
            .trim()
            .replaceAll('), ', ')\n') ??
        '';

    print('\n$fallOfwicketsLabel \n$fallOfWickets');

    if (inningsId == '1') {
      user.add(FirstTotalScoreItem(
          extrasLabel: extrasLabel,
          extrasValue: extrasValue,
          extrasDetails: extrasDetails,
          totalLabel: totalLabel,
          totalValue: totalValue,
          totalDetails: totalDetails,
          yettobatLabel: yetToBatLabel,
          yettobatPlayers: yetToBatPlayers,
          fallofwicketsLabel: fallOfwicketsLabel,
          fallofWickets: fallOfWickets));
    } else if (inningsId == '2') {
      user.add(SecondTotalScoreItem(
          extrasLabel: extrasLabel,
          extrasValue: extrasValue,
          extrasDetails: extrasDetails,
          totalLabel: totalLabel,
          totalValue: totalValue,
          totalDetails: totalDetails,
          yettobatLabel: yetToBatLabel,
          yettobatPlayers: yetToBatPlayers,
          fallofwicketsLabel: fallOfwicketsLabel,
          fallofWickets: fallOfWickets));
    } else if (inningsId == '3') {
      user.add(ThirdTotalScoreItem(
          extrasLabel: extrasLabel,
          extrasValue: extrasValue,
          extrasDetails: extrasDetails,
          totalLabel: totalLabel,
          totalValue: totalValue,
          totalDetails: totalDetails,
          yettobatLabel: yetToBatLabel,
          yettobatPlayers: yetToBatPlayers,
          fallofwicketsLabel: fallOfwicketsLabel,
          fallofWickets: fallOfWickets));
    } else if (inningsId == '4') {
      user.add(FourthTotalScoreItem(
          extrasLabel: extrasLabel,
          extrasValue: extrasValue,
          extrasDetails: extrasDetails,
          totalLabel: totalLabel,
          totalValue: totalValue,
          totalDetails: totalDetails,
          yettobatLabel: yetToBatLabel,
          yettobatPlayers: yetToBatPlayers,
          fallofwicketsLabel: fallOfwicketsLabel,
          fallofWickets: fallOfWickets));
    }
  }
}

abstract class BowlerHeaderItem {
  final String bowlerHeader;
  // final String oversHeader;
  // final String maidensHeader;
  // final String runsHeader;
  // final String wicketsHeader;
  // final String noballsHeader;
  // final String widesHeader;
  // final String economyHeader;

  BowlerHeaderItem({
    required this.bowlerHeader,
    // required this.oversHeader,
    // required this.maidensHeader,
    // required this.runsHeader,
    // required this.wicketsHeader,
    // required this.noballsHeader,
    // required this.widesHeader,
    // required this.economyHeader
  });
}

class FirstBowlerHeaderItem extends BowlerHeaderItem {
  FirstBowlerHeaderItem({
    required bowlerHeader,
    // required oversHeader,
    // required maidensHeader,
    // required runsHeader,
    // required wicketsHeader,
    // required noballsHeader,
    // required widesHeader,
    // required economyHeader
  }) : super(
          bowlerHeader: bowlerHeader,
          // oversHeader: oversHeader,
          // maidensHeader: maidensHeader,
          // runsHeader: runsHeader,
          // wicketsHeader: wicketsHeader,
          // noballsHeader: noballsHeader,
          // widesHeader: widesHeader,
          // economyHeader: economyHeader
        );
}

class SecondBowlerHeaderItem extends BowlerHeaderItem {
  SecondBowlerHeaderItem({
    required bowlerHeader,
    // required oversHeader,
    // required maidensHeader,
    // required runsHeader,
    // required wicketsHeader,
    // required noballsHeader,
    // required widesHeader,
    // required economyHeader
  }) : super(
          bowlerHeader: bowlerHeader,
          // oversHeader: oversHeader,
          // maidensHeader: maidensHeader,
          // runsHeader: runsHeader,
          // wicketsHeader: wicketsHeader,
          // noballsHeader: noballsHeader,
          // widesHeader: widesHeader,
          // economyHeader: economyHeader
        );
}

class ThirdBowlerHeaderItem extends BowlerHeaderItem {
  ThirdBowlerHeaderItem({
    required bowlerHeader,
    // required oversHeader,
    // required maidensHeader,
    // required runsHeader,
    // required wicketsHeader,
    // required noballsHeader,
    // required widesHeader,
    // required economyHeader
  }) : super(
          bowlerHeader: bowlerHeader,
          // oversHeader: oversHeader,
          // maidensHeader: maidensHeader,
          // runsHeader: runsHeader,
          // wicketsHeader: wicketsHeader,
          // noballsHeader: noballsHeader,
          // widesHeader: widesHeader,
          // economyHeader: economyHeader
        );
}

class FourthBowlerHeaderItem extends BowlerHeaderItem {
  FourthBowlerHeaderItem({
    required bowlerHeader,
    // required oversHeader,
    // required maidensHeader,
    // required runsHeader,
    // required wicketsHeader,
    // required noballsHeader,
    // required widesHeader,
    // required economyHeader
  }) : super(
          bowlerHeader: bowlerHeader,
          // oversHeader: oversHeader,
          // maidensHeader: maidensHeader,
          // runsHeader: runsHeader,
          // wicketsHeader: wicketsHeader,
          // noballsHeader: noballsHeader,
          // widesHeader: widesHeader,
          // economyHeader: economyHeader
        );
}

void extractBowlerHeaderItem(document, List user, String inningsId) {
  final extradiv = document.querySelector('#innings_$inningsId');
  if (extradiv != null) {
    final bowlerheaderDivs =
        document.querySelectorAll('.cb-scrd-sub-hdr.cb-bg-gray')[2];
    final bowlerheaderColumns = bowlerheaderDivs.querySelectorAll('.cb-col');
    final bowlerHeader = bowlerheaderColumns[0].text;
    // final overs = bowlerheaderColumns[1].text;
    // final maidens = bowlerheaderColumns[2].text;
    // final runs = bowlerheaderColumns[3].text;
    // final wickets = bowlerheaderColumns[4].text;
    // final noBalls = bowlerheaderColumns[5].text;
    // final wides = bowlerheaderColumns[6].text;
    // final economy = bowlerheaderColumns[7].text;

    print('Bowler Header: $bowlerHeader');

    if (inningsId == '1') {
      user.add(FirstBowlerHeaderItem(
        bowlerHeader: bowlerHeader,
        // oversHeader: overs,
        // maidensHeader: maidens,
        // runsHeader: runs,
        // wicketsHeader: wickets,
        // noballsHeader: noBalls,
        // widesHeader: wides,
        // economyHeader: economy
      ));
    } else if (inningsId == '2') {
      user.add(
        SecondBowlerHeaderItem(
          bowlerHeader: bowlerHeader,
          // oversHeader: overs,
          // maidensHeader: maidens,
          // runsHeader: runs,
          // wicketsHeader: wickets,
          // noballsHeader: noBalls,
          // widesHeader: wides,
          // economyHeader: economy
        ),
      );
    } else if (inningsId == '3') {
      user.add(
        ThirdBowlerHeaderItem(
          bowlerHeader: bowlerHeader,
          // oversHeader: overs,
          // maidensHeader: maidens,
          // runsHeader: runs,
          // wicketsHeader: wickets,
          // noballsHeader: noBalls,
          // widesHeader: wides,
          // economyHeader: economy
        ),
      );
    } else if (inningsId == '4') {
      user.add(
        FourthBowlerHeaderItem(
          bowlerHeader: bowlerHeader,
          // oversHeader: overs,
          // maidensHeader: maidens,
          // runsHeader: runs,
          // wicketsHeader: wickets,
          // noballsHeader: noBalls,
          // widesHeader: wides,
          // economyHeader: economy
        ),
      );
    }
  }
}

abstract class BowlerDataItem {
  final String bowlerName;
  final String overs;
  final String maidens;
  final String runs;
  final String wickets;
  final String noballs;
  final String wides;
  final String economy;

  BowlerDataItem({
    required this.bowlerName,
    required this.overs,
    required this.maidens,
    required this.runs,
    required this.wickets,
    required this.noballs,
    required this.wides,
    required this.economy,
  });
}

class FirstBowlerDataItem extends BowlerDataItem {
  FirstBowlerDataItem({
    required bowlerName,
    required overs,
    required maidens,
    required runs,
    required wickets,
    required noballs,
    required wides,
    required economy,
  }) : super(
            bowlerName: bowlerName,
            overs: overs,
            maidens: maidens,
            runs: runs,
            wickets: wickets,
            noballs: noballs,
            wides: wides,
            economy: economy);
}

class SecondBowlerDataItem extends BowlerDataItem {
  SecondBowlerDataItem({
    required bowlerName,
    required overs,
    required maidens,
    required runs,
    required wickets,
    required noballs,
    required wides,
    required economy,
  }) : super(
            bowlerName: bowlerName,
            overs: overs,
            maidens: maidens,
            runs: runs,
            wickets: wickets,
            noballs: noballs,
            wides: wides,
            economy: economy);
}

class ThirdBowlerDataItem extends BowlerDataItem {
  ThirdBowlerDataItem({
    required bowlerName,
    required overs,
    required maidens,
    required runs,
    required wickets,
    required noballs,
    required wides,
    required economy,
  }) : super(
            bowlerName: bowlerName,
            overs: overs,
            maidens: maidens,
            runs: runs,
            wickets: wickets,
            noballs: noballs,
            wides: wides,
            economy: economy);
}

class FourthBowlerDataItem extends BowlerDataItem {
  FourthBowlerDataItem({
    required bowlerName,
    required overs,
    required maidens,
    required runs,
    required wickets,
    required noballs,
    required wides,
    required economy,
  }) : super(
            bowlerName: bowlerName,
            overs: overs,
            maidens: maidens,
            runs: runs,
            wickets: wickets,
            noballs: noballs,
            wides: wides,
            economy: economy);
}

void extractBowlerDataItem(document, List user, String inningsId) {
  final extradiv = document.querySelector('#innings_$inningsId');
  if (extradiv != null) {
    final bowlerDataElements = extradiv.querySelectorAll('.cb-ltst-wgt-hdr')[1];
    final bowlerDivs =
        bowlerDataElements.querySelectorAll('.cb-col.cb-col-100.cb-scrd-itms');
    for (var bowlerDiv in bowlerDivs) {
      final bowlerName =
          bowlerDiv.querySelector('a.cb-text-link')?.text.trim() ?? '';
      final overs =
          bowlerDiv.querySelector('.cb-col.cb-col-8.text-right')?.text.trim() ??
              '';
      final maidens = bowlerDiv
          .querySelectorAll('.cb-col.cb-col-8.text-right')[1]
          .text
          .trim();
      final runs = bowlerDiv
              .querySelector('.cb-col.cb-col-10.text-right')
              ?.text
              .trim() ??
          '';
      final wickets = bowlerDiv
              .querySelector('.cb-col.cb-col-8.text-bold.text-right')
              ?.text
              .trim() ??
          '';
      final noBalls = bowlerDiv
          .querySelectorAll('.cb-col.cb-col-8.text-right')[3]
          .text
          .trim();
      final wides = bowlerDiv
          .querySelectorAll('.cb-col.cb-col-8.text-right')[4]
          .text
          .trim();

      final textRightElements =
          bowlerDiv.querySelectorAll('.cb-col.cb-col-10.text-right');
      final economy =
          textRightElements.length > 1 ? textRightElements[1].text.trim() : '';

      print(
          'Bowler Data: $bowlerName $overs $maidens $runs $wickets $noBalls $wides $economy');

      if (inningsId == '1') {
        user.add(FirstBowlerDataItem(
            bowlerName: bowlerName,
            overs: overs,
            maidens: maidens,
            runs: runs,
            wickets: wickets,
            noballs: noBalls,
            wides: wides,
            economy: economy));
      } else if (inningsId == '2') {
        user.add(SecondBowlerDataItem(
            bowlerName: bowlerName,
            overs: overs,
            maidens: maidens,
            runs: runs,
            wickets: wickets,
            noballs: noBalls,
            wides: wides,
            economy: economy));
      } else if (inningsId == '3') {
        user.add(ThirdBowlerDataItem(
            bowlerName: bowlerName,
            overs: overs,
            maidens: maidens,
            runs: runs,
            wickets: wickets,
            noballs: noBalls,
            wides: wides,
            economy: economy));
      } else if (inningsId == '4') {
        user.add(FourthBowlerDataItem(
            bowlerName: bowlerName,
            overs: overs,
            maidens: maidens,
            runs: runs,
            wickets: wickets,
            noballs: noBalls,
            wides: wides,
            economy: economy));
      }
    }
  }
}

abstract class PowerPlayItem {
  final String powerplaysLabel;
  final String oversLabel;
  final String runsLabel;

  PowerPlayItem({
    required this.powerplaysLabel,
    required this.oversLabel,
    required this.runsLabel,
  });
}

class FirstPowerPlayItem extends PowerPlayItem {
  FirstPowerPlayItem({
    required powerplaysLabel,
    required oversLabel,
    required runsLabel,
  }) : super(
            powerplaysLabel: powerplaysLabel,
            oversLabel: oversLabel,
            runsLabel: runsLabel);
}

class SecondPowerPlayItem extends PowerPlayItem {
  SecondPowerPlayItem({
    required powerplaysLabel,
    required oversLabel,
    required runsLabel,
  }) : super(
            powerplaysLabel: powerplaysLabel,
            oversLabel: oversLabel,
            runsLabel: runsLabel);
}

void extractPowerPlayItems(document, List user, String inningsId) {
  final extradiv = document.querySelector('#innings_$inningsId');

  if (extradiv != null) {
    final powerplayLabels =
        extradiv.querySelectorAll('.cb-scrd-sub-hdr.cb-bg-gray.text-bold');
    if (powerplayLabels.length > 1) {
      final powerplayLabel = powerplayLabels[1];
      final mandatoryValue =
          powerplayLabel.querySelector('.cb-col-33')?.text ?? '';
      final oversValue =
          powerplayLabel.querySelector('.cb-col-33.text-center')?.text ?? '';
      final runsValue =
          powerplayLabel.querySelector('.cb-col-33.text-right')?.text ?? '';

      print('Powerplay: $mandatoryValue $oversValue $runsValue');

      if (inningsId == '1') {
        user.add(FirstPowerPlayItem(
            powerplaysLabel: mandatoryValue,
            oversLabel: oversValue,
            runsLabel: runsValue));
      } else if (inningsId == '2') {
        user.add(SecondPowerPlayItem(
            powerplaysLabel: mandatoryValue,
            oversLabel: oversValue,
            runsLabel: runsValue));
      }
    }
  }
}

abstract class PowerPlayDataItem {
  final String powerplaysValue;
  final String oversValue;
  final String runsValue;

  PowerPlayDataItem({
    required this.powerplaysValue,
    required this.oversValue,
    required this.runsValue,
  });
}

class FirstPowerPlayDataItem extends PowerPlayDataItem {
  FirstPowerPlayDataItem({
    required powerplaysValue,
    required oversValue,
    required runsValue,
  }) : super(
          powerplaysValue: powerplaysValue,
          oversValue: oversValue,
          runsValue: runsValue,
        );
}

class SecondPowerPlayDataItem extends PowerPlayDataItem {
  SecondPowerPlayDataItem({
    required powerplaysValue,
    required oversValue,
    required runsValue,
  }) : super(
          powerplaysValue: powerplaysValue,
          oversValue: oversValue,
          runsValue: runsValue,
        );
}

void extractPowerPlayData(document, List user, String inningsId) {
  final extradiv = document.querySelector('#innings_$inningsId');

  if (extradiv != null) {
    final powerplayLabels = extradiv.querySelectorAll('.cb-col-rt.cb-font-13');
    if (powerplayLabels.length > 1) {
      final powerplayLabel = powerplayLabels[1];
      final mandatoryValue =
          powerplayLabel.querySelector('.cb-col-33')?.text ?? '';
      final oversValue =
          powerplayLabel.querySelector('.cb-col-33.text-center')?.text ?? '';
      final runsValue =
          powerplayLabel.querySelector('.cb-col-33.text-right')?.text ?? '';

      print('Powerplay: $mandatoryValue $oversValue $runsValue');

      if (inningsId == '1') {
        user.add(
          FirstPowerPlayDataItem(
            powerplaysValue: mandatoryValue,
            oversValue: oversValue,
            runsValue: runsValue,
          ),
        );
      } else if (inningsId == '2') {
        user.add(
          SecondPowerPlayDataItem(
            powerplaysValue: mandatoryValue,
            oversValue: oversValue,
            runsValue: runsValue,
          ),
        );
      }
    }
  }
}
