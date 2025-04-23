import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage3 extends StatelessWidget{
  const IntroPage3({Key? key}) : super(key: key);

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

              padding: const EdgeInsets.only(left:50, right:50,bottom:80,top:0),
              decoration: const BoxDecoration(

                image: DecorationImage(
                    image: AssetImage('assets/splash3_bg.jpg'),
                    fit: BoxFit.cover ),

              ),

              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height:250, child: Lottie.network('https://assets7.lottiefiles.com/packages/lf20_juote5w5.json'),),
                  const SizedBox(height: 20,),
                  const Text(('From leaf to remedy: explore the world of Ayurveda with just one click'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23,
                      fontStyle: FontStyle.italic,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],

              ),
            )
          ],
        )

    );

  }
}