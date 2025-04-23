import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:google_fonts/google_fonts.dart';

class IntroPage1 extends StatelessWidget{
  const IntroPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          elevation: 0.0,
          actions: [],

        ),
        body: Stack(

          alignment: Alignment.bottomCenter,
          children: [
            Container(
              padding: const EdgeInsets.only(left:50, right:50,bottom:80),
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/splash1_bg.jpg'),
                    fit: BoxFit.cover ),
              ),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  SizedBox(height:250, child: Lottie.network('https://assets7.lottiefiles.com/packages/lf20_vlsxlcyq.json'),),
                  const SizedBox(height: 20,),

                  const Text(('AYUR SCAN'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 50,
                      fontFamily: HttpHeaders.acceptHeader,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(('Discover the power of Ayurveda at your fingertips'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 20,
                      fontStyle: FontStyle.italic,

                    ),),

                ],

              ),
            )
          ],
        )

    );

  }
}
