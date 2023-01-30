import 'package:coba_animasi/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';

class Splash extends StatefulWidget {
  const Splash({Key key}) : super(key: key);

  @override
  State<Splash> createState() => _Splash();
}

class _Splash extends State<Splash> with SingleTickerProviderStateMixin {
  splashStart() async {
    var duration = const Duration(milliseconds: 2500);
    return Timer(duration, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  double opacityLevel = 0.0;

  void changeOpacity() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => opacityLevel = 1.0);
    splashStart();
  }

  @override
  void initState() {
    changeOpacity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomRight, stops: [0.1, 0.9], colors: [Colors.blue, Colors.purple])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.only(bottom: 60),
                child: AnimatedOpacity(
                  opacity: opacityLevel,
                  duration: const Duration(milliseconds: 2000),
                  child: Image.asset(
                    "assets/images/logoApp.png",
                    width: MediaQuery.of(context).size.width * 0.45,
                  ),
                ),
              ),
            ),
            // Positioned(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.end,
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       Align(
            //           alignment: FractionalOffset.bottomCenter,
            //           child: SvgPicture.asset('assets/images/aplikita.svg', color: Colors.white, width: MediaQuery.of(context).size.width * 0.4)),
            //       const SizedBox(height: 50),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
