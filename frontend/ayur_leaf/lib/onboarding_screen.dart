import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ayur_scan/home_page.dart';
import 'package:ayur_scan/intro_screens/intro_screen_1.dart';
import 'package:ayur_scan/intro_screens/intro_screen_2.dart';
import 'package:ayur_scan/intro_screens/intro_screen_3.dart';

class OnBoardingScreen extends StatefulWidget{
  const OnBoardingScreen({Key? key}): super(key:key);

  @override
  _OnboardingScreenState createState()=> _OnboardingScreenState() ;

}

class _OnboardingScreenState extends State<OnBoardingScreen> {

  PageController _controller = PageController();

  bool OnLastPage=false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: _controller,
              onPageChanged: (index){
                setState(() {
                  OnLastPage=(index==2);
                });
              },
              children: const [
                IntroPage1(),
                IntroPage2(),
                IntroPage3(),
              ],
            ),
            //dot indicators
            Container(
              alignment: Alignment(0,0.85),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:  [
                  GestureDetector(
                    onTap:() {
                      _controller.jumpToPage(2);

                    },
                    child: const Text('Skip',style:TextStyle(
                      color: Colors.white70,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w800,

                    ),),
                  ),

                  SmoothPageIndicator(controller:_controller, count:3),

                  OnLastPage
                      ? GestureDetector(

                    onTap: (){
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context){
                          return HomePage()  ;
                        },),
                      );

                    },
                    child: const Text('Proceed',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w800,
                      ),),
                  )
                      :GestureDetector(

                    onTap:(){
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );

                    },
                    child: const Text('Next',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        )
    );

  }
}