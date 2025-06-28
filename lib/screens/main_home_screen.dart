import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'more options/more_option_screen.dart';
import 'fixtures_screen.dart';
import 'news_screen.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    // Your tab views here
    const NewsScreen(), // News in the second tab
    const TabBarScreen(), // Tabbar for the third tab
    const MoreOptionScreen(), // More Option for the third tab
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color.fromARGB(255, 114, 255, 48),
        currentIndex: _currentIndex,
        unselectedItemColor: Colors.white30,
        backgroundColor: Color.fromARGB(255, 15, 19, 1),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_sharp),
            label: 'Live',
            backgroundColor: Color.fromARGB(255, 15, 19, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_cricket_outlined),
            label: 'Matches',
            backgroundColor: Color.fromARGB(255, 15, 19, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'More',
            backgroundColor: Color.fromARGB(255, 15, 19, 1),
          ),
        ],
      ),
    );
  }
}

// Example of a TabBar in the second tab
class TabBarScreen extends StatelessWidget {
  const TabBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 15, 19, 1),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Image.asset(
                'assets/images/2024_T20_WorldCup.png',
                width: 60.w,
              ),
            ),
          ],
          toolbarHeight: 90.h,
          bottom: TabBar(
            indicatorColor: Color.fromARGB(255, 114, 255, 48),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white12,
            tabs: [
              Tab(
                child: Text(
                  'FIXTURES',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'SpaceGrotesk-Regular',
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'RESULTS',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'SpaceGrotesk-Regular',
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'STANDINGS',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'SpaceGrotesk-Regular',
                  ),
                ),
              ),
            ],
          ), // TabBar
          title: Text(
            'Matches',
            style: TextStyle(
              fontSize: 34.sp,
              fontFamily: 'Mulish-ExtraBold',
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ), // AppBar
        body: Stack(
          children: [
            Image.asset(
              'assets/images/blur backgroung.png',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              scale: 1,
            ),
            TabBarView(
              children: [
                FixtureScreen(
                  url:
                      'https://www.cricbuzz.com/cricket-series/9325/icc-champions-trophy-2025/matches',
                ),
                // Icon(Icons.music_note),
                Icon(Icons.music_video),
                Icon(Icons.camera_alt),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
