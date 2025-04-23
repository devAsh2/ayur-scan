import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage2 extends StatelessWidget{
  const IntroPage2({Key? key}) : super(key: key);

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
                    image: AssetImage('assets/splash2_bg.jpg'),
                    fit: BoxFit.cover ),

              ),

              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height:300, child: Lottie.network('https://assets6.lottiefiles.com/private_files/lf30_j4v2bg0q.json'),),
                  const SizedBox(height: 20,),
                  const Text(('Identify the medicinal properties of your home grown plants with ease!'),
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