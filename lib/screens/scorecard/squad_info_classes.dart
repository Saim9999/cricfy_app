class TeamHeaderItem {
  final String team1Name;
  final String team1ImageSrc;
  final String team2Name;
  final String team2ImageSrc;

  TeamHeaderItem({
    required this.team1Name,
    required this.team1ImageSrc,
    required this.team2Name,
    required this.team2ImageSrc,
  });
}

class SquadorPlaying {
  final String squadorPlaying;

  SquadorPlaying({
    required this.squadorPlaying,
  });
}

class BenchPlayers {
  final String benchPlayers;

  BenchPlayers({
    required this.benchPlayers,
  });
}

class SupportStaffHeading {
  final String supportStaff;

  SupportStaffHeading({
    required this.supportStaff,
  });
}

abstract class PlayingXIItem {
  final String name;
  final String role;
  final String imageUrl;

  PlayingXIItem({
    required this.name,
    required this.role,
    required this.imageUrl,
  });
}

class FirstPlayingXIItem extends PlayingXIItem {
  FirstPlayingXIItem({
    required name,
    required role,
    required imageUrl,
  }) : super(
          name: name,
          role: role,
          imageUrl: imageUrl,
        );
}

class SecondPlayingXIItem extends PlayingXIItem {
  SecondPlayingXIItem({
    required name,
    required role,
    required imageUrl,
  }) : super(
          name: name,
          role: role,
          imageUrl: imageUrl,
        );
}

void extractPlayingXIItem(document, List user, String sideId1, String sideId2) {
  final playingXI =
      document.querySelector('.cb-col.cb-col-50.cb-play11-$sideId1-col');
  final playerCards = playingXI!.querySelectorAll('.cb-player-card-$sideId2');
  for (var card in playerCards) {
    final nameElement = card.querySelector('.cb-player-name-$sideId2');
    final roleElement = card.querySelector('.cb-font-12');
    final imageElement = card.querySelector('.cb-plyr-img-$sideId2');

    if (nameElement == null || roleElement == null || imageElement == null) {
      continue;
    }

    final name = nameElement.text
        .trim()
        .replaceAll(' Batter', '')
        .replaceAll(' Bowler', '')
        .replaceAll(' WK-Batter', '')
        .replaceAll(' Bowling Allrounder', '')
        .replaceAll(' Batting Allrounder', '');

    final role = roleElement.text.trim();
    final image = imageElement.attributes['src'] ?? '';

    if (name.isEmpty || role.isEmpty || image.isEmpty) {
      continue;
    }

    print('Name: $name');
    print('Role: $role');
    print('Image URL: $image');

    if (sideId1 == 'lft' && sideId2 == 'left') {
      user.add(FirstPlayingXIItem(name: name, role: role, imageUrl: image));
    } else if (sideId1 == 'rt' && sideId2 == 'right') {
      user.add(SecondPlayingXIItem(name: name, role: role, imageUrl: image));
    }
  }
}

abstract class BenchPlayersItem {
  final String name;
  final String role;
  final String imageUrl;

  BenchPlayersItem({
    required this.name,
    required this.role,
    required this.imageUrl,
  });
}

class FirstBenchPlayersItem extends BenchPlayersItem {
  FirstBenchPlayersItem({
    required name,
    required role,
    required imageUrl,
  }) : super(
          name: name,
          role: role,
          imageUrl: imageUrl,
        );
}

class SecondBenchPlayersItem extends BenchPlayersItem {
  SecondBenchPlayersItem({
    required name,
    required role,
    required imageUrl,
  }) : super(
          name: name,
          role: role,
          imageUrl: imageUrl,
        );
}

void extractBenchPlayersItem(
    document, List user, String sideId1, String sideId2, int num) {
  final benchPlayers = document
      .querySelectorAll('.cb-col.cb-col-50.cb-play11-$sideId1-col')[num];
  final playerCards1 =
      benchPlayers.querySelectorAll('.cb-player-card-$sideId2');
  for (var card in playerCards1) {
    final nameElement = card.querySelector('.cb-player-name-$sideId2');
    final roleElement = card.querySelector('.cb-font-12');
    final imageElement = card.querySelector('.cb-plyr-img-$sideId2');

    if (nameElement == null || roleElement == null || imageElement == null) {
      continue;
    }

    final name = nameElement.text
        .trim()
        .replaceAll(' Batter', '')
        .replaceAll(' Bowler', '')
        .replaceAll(' WK-', '')
        .replaceAll(' Bowling Allrounder', '')
        .replaceAll(' Batting Allrounder', '');

    final role = roleElement.text.trim();
    final image = imageElement.attributes['src'] ?? '';

    if (name.isEmpty || role.isEmpty || image.isEmpty) {
      continue;
    }

    print('Name: $name');
    print('Role: $role');
    print('Image URL: $image');

    if (sideId1 == 'lft' && sideId2 == 'left') {
      user.add(FirstBenchPlayersItem(name: name, role: role, imageUrl: image));
    } else if (sideId1 == 'rt' && sideId2 == 'right') {
      user.add(SecondBenchPlayersItem(name: name, role: role, imageUrl: image));
    }
  }
}

abstract class SupportStaff {
  final String name;
  final String role;
  final String imageUrl;

  SupportStaff({
    required this.name,
    required this.role,
    required this.imageUrl,
  });
}

class FirstSupportStaff extends SupportStaff {
  FirstSupportStaff({
    required name,
    required role,
    required imageUrl,
  }) : super(
          name: name,
          role: role,
          imageUrl: imageUrl,
        );
}

class SecondSupportStaff extends SupportStaff {
  SecondSupportStaff({
    required name,
    required role,
    required imageUrl,
  }) : super(
          name: name,
          role: role,
          imageUrl: imageUrl,
        );
}

void extractSupportStaffItem(
    document, List user, String sideId1, String sideId2, int num) {
  final headingLabel2 = document.querySelectorAll(
      '.cb-col.cb-col-100.cb-pl11-hdr.text-bold.text-center.cb-font-16');
  if (headingLabel2.isNotEmpty && headingLabel2.length > 2) {
    final headingLabel2query = headingLabel2[2].text;
    print('Heading Label : $headingLabel2query');

    final supportStaff = document
        .querySelectorAll('.cb-col.cb-col-50.cb-play11-$sideId1-col')[num];
    final playerCards2 =
        supportStaff.querySelectorAll('.cb-player-card-$sideId2');
    for (var card in playerCards2) {
      final nameElement = card.querySelector('.cb-player-name-$sideId2');
      final roleElement = card.querySelector('.cb-font-12');
      final imageElement = card.querySelector('.cb-plyr-img-$sideId2');

      if (nameElement == null || roleElement == null || imageElement == null) {
        continue;
      }

      final name = nameElement.text
          .trim()
          .replaceAll(' Batter', '')
          .replaceAll(' Bowler', '')
          .replaceAll(' WK-', '')
          .replaceAll(' Bowling Allrounder', '')
          .replaceAll(' Batting Allrounder', '')
          .replaceAll(' Head Coach', '')
          .replaceAll(' Batting Coach', '')
          .replaceAll(' Bowling Coach', '')
          .replaceAll(' Fielding Coach', '')
          .replaceAll(' Assistant Coach', '')
          .replaceAll(' Spin Bowling Coach', '')
          .replaceAll(' Fast Bowling Coach', '')
          .replaceAll(' Consultant Coach', '');
      final role = roleElement.text.trim();
      final image = imageElement.attributes['src'] ?? '';

      if (name.isEmpty || role.isEmpty || image.isEmpty) {
        continue;
      }

      print('Name: $name');
      print('Role: $role');
      print('Image URL: $image');

      if (sideId1 == 'lft' && sideId2 == 'left') {
        user.add(FirstSupportStaff(name: name, role: role, imageUrl: image));
      } else if (sideId1 == 'rt' && sideId2 == 'right') {
        user.add(SecondSupportStaff(name: name, role: role, imageUrl: image));
      }
    }
  } else {
    print("No Heading Label found.");
  }
}
