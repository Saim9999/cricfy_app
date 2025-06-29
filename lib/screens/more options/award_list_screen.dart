import 'package:crickfy_app/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../classes/commentary classes.dart';

class AwardListScreen extends StatefulWidget {
  const AwardListScreen({super.key});

  @override
  State<AwardListScreen> createState() => _AwardListScreenState();
}

class _AwardListScreenState extends State<AwardListScreen> {
  final List<AwardofYearInfo> awardofyearInfo = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAwardWinner();
  }

  Future<void> fetchAwardWinner() async {
    if (!mounted) {
      // Check if the widget is still mounted before proceeding
      return;
    }
    setState(() {
      isLoading = true;
    });

    final url =
        'https://www.icc-cricket.com/awards/icc-awards-of-the-year-2024';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final document = html.parse(response.body);

      // 🔹 Get both award sections and player cards
      final awards = document.querySelectorAll(
        '.flex.flex-col.lg\\:flex-row.items-end.gap-2.w-full.justify-between',
      );
      final cards = document.querySelectorAll(
        '.swiper-slide .bg-black', // Player award card
      );

      // 🔹 Loop through both lists together
      final int total =
          cards.length < awards.length ? cards.length : awards.length;

      for (int i = 0; i < total; i++) {
        final award = awards[i];
        final card = cards[i];

        // 🔸 Award title
        final awardTitle =
            award.querySelector('.w-full.lg\\:w-9\\/12 h2')?.text.trim() ??
            'No Title Found';

        // 🔸 Player name
        final firstName = card.querySelector('p.text-xs')?.text.trim() ?? '';
        final lastName =
            card.querySelector('p.font-h2-upper')?.text.trim() ?? '';

        // 🔸 Image URL
        final img = card.querySelector('img')?.attributes['src'] ?? '';

        // 🔸 Country flag
        final flag =
            card.querySelectorAll('img').length > 1
                ? card.querySelectorAll('img')[1].attributes['src']
                : '';

        // 🔸 Stats
        final stats = card.querySelectorAll('.playerCard__stats p.text-base');
        final runs = stats.isNotEmpty ? stats[0].text.trim() : '';
        final wickets = stats.length > 1 ? stats[1].text.trim() : '';
        final catches = stats.length > 2 ? stats[2].text.trim() : '';

        awardofyearInfo.add(
          AwardofYearInfo(
            awardTitle: awardTitle,
            firstName: firstName,
            lastName: lastName,
            img: img,
            flag: flag!,
            runs: runs,
            wickets: wickets,
            catches: catches,
          ),
        );
      }
      if (!mounted) {
        // Check if the widget is still mounted before calling setState
        return;
      }

      setState(() {
        isLoading = false;
      });
    } else {
      print('Failed to fetch: ${response.statusCode}');
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
                            'ICC Awards 2024',
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
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: awardofyearInfo.length,
                        itemBuilder: (context, index) {
                          final awardItem = awardofyearInfo[index];
                          return Column(
                            children: [
                              Container(
                                width: double.infinity,
                                color: Colors.grey[300],
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 16,
                                ),
                                child: Text(
                                  awardItem.awardTitle,
                                  style: textMethod(
                                    Colors.black,
                                    18.sp,
                                    FontWeight.normal,
                                    'Mulish-ExtraBold',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 400.h,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        color:
                                            (awardItem.img.isEmpty)
                                                ? Colors
                                                    .blue // fallback color
                                                : null,
                                        image:
                                            (awardItem.img.isNotEmpty)
                                                ? DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                    awardItem.img,
                                                  ),
                                                )
                                                : null,
                                        border: Border.all(
                                          color: Color.fromARGB(
                                            255,
                                            191,
                                            155,
                                            48,
                                          ),
                                          width: 4.0,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 400.h,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.center,
                                          colors: [
                                            // ignore: deprecated_member_use
                                            Colors.black.withOpacity(
                                              0.6,
                                            ), // Top fade
                                            Colors.transparent, // Bottom clear
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 400.h,
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(height: 15.h),
                                              RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  text: awardItem.firstName,
                                                  style: textMethod(
                                                    Colors.white,
                                                    14.sp,
                                                    FontWeight.bold,
                                                    'Mulish-ExtraBold',
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '\n${awardItem.lastName}',
                                                      style: textMethod(
                                                        Colors.white,
                                                        24.sp,
                                                        FontWeight.bold,
                                                        'Mulish-ExtraBold',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Image.network(
                                                awardItem.flag,
                                                height: 40.h,
                                                width: 40.w,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                        awardItem.runs,
                                                        style: textMethod(
                                                          Colors.white,
                                                          20.sp,
                                                          FontWeight.bold,
                                                          'Mulish-ExtraBold',
                                                        ),
                                                      ),
                                                      if (awardItem
                                                          .runs
                                                          .isNotEmpty)
                                                        Text(
                                                          'Runs',
                                                          style: textMethod(
                                                            Color.fromARGB(
                                                              255,
                                                              191,
                                                              155,
                                                              48,
                                                            ),
                                                            14.sp,
                                                            FontWeight.bold,
                                                            'Mulish-Regular',
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        awardItem.wickets,
                                                        style: textMethod(
                                                          Colors.white,
                                                          20.sp,
                                                          FontWeight.bold,
                                                          'Mulish-ExtraBold',
                                                        ),
                                                      ),
                                                      if (awardItem
                                                          .wickets
                                                          .isNotEmpty)
                                                        Text(
                                                          'Wickets',
                                                          style: textMethod(
                                                            Color.fromARGB(
                                                              255,
                                                              191,
                                                              155,
                                                              48,
                                                            ),
                                                            14.sp,
                                                            FontWeight.bold,
                                                            'Mulish-Regular',
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        awardItem.catches,
                                                        style: textMethod(
                                                          Colors.white,
                                                          20.sp,
                                                          FontWeight.bold,
                                                          'Mulish-ExtraBold',
                                                        ),
                                                      ),
                                                      if (awardItem
                                                          .catches
                                                          .isNotEmpty)
                                                        Text(
                                                          'Catches',
                                                          style: textMethod(
                                                            Color.fromARGB(
                                                              255,
                                                              191,
                                                              155,
                                                              48,
                                                            ),
                                                            14.sp,
                                                            FontWeight.bold,
                                                            'Mulish-Regular',
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 15.h),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
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
