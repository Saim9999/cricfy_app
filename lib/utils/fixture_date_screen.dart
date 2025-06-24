import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FixtureDateWidget extends StatelessWidget {
  const FixtureDateWidget({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20.sp,
        color: Colors.white,
        fontFamily: 'SpaceGrotesk-Regular',
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class FixtureContainer extends StatelessWidget {
  const FixtureContainer({
    super.key,
    required this.matchText,
    required this.timeText,
    required this.stadiumText,
    required this.roundStageText,
    required this.firstTeamFlag,
    required this.firstTeamName,
    required this.secondTeamFlag,
    required this.secondTeamName,
  });

  final String matchText;
  final String timeText;
  final String stadiumText;
  final String roundStageText;
  final String firstTeamFlag;
  final String firstTeamName;
  final String secondTeamFlag;
  final String secondTeamName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 130.h,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/Decorated container.png'),
              fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(4.r)),
      child: Column(
        children: [
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                matchText,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontFamily: 'SpaceGrotesk-Regular',
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                timeText,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Color.fromARGB(255, 114, 255, 48),
                  fontFamily: 'SpaceGrotesk-Regular',
                  fontWeight: FontWeight.normal,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    stadiumText,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.white,
                      fontFamily: 'SpaceGrotesk-Regular',
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              Text(
                roundStageText,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                  fontFamily: 'SpaceGrotesk-Regular',
                  fontWeight: FontWeight.normal,
                ),
              )
            ],
          ),
          Divider(
            color: Colors.white,
          ),
          Row(
            children: [
              Container(
                height: 18.h,
                width: 32.w,
                child: Image.asset(
                  firstTeamFlag,
                  fit: BoxFit.fitHeight,
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    firstTeamName,
                    style: TextStyle(
                      fontSize: 26.sp,
                      color: Colors.white,
                      fontFamily: 'SpaceGrotesk-Regular',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              Container(
                height: 18.h,
                width: 32.w,
                child: Image.asset(
                  secondTeamFlag,
                  fit: BoxFit.fitHeight,
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    secondTeamName,
                    style: TextStyle(
                      fontSize: 26.sp,
                      color: Colors.white,
                      fontFamily: 'SpaceGrotesk-Regular',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
