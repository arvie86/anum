import 'dart:async';

import 'package:coba_animasi/dataku.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:ripple_animation/ripple_animation.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;
  int onTapIndex = -1;

  //
  //

  AudioPlayer _audioPlayer;
  PlayerState audioPlayerState = PlayerState.paused;
  PlayerState _playerState = PlayerState.stopped;
  bool get _isPlaying => _playerState == PlayerState.playing;
  bool get _distop => _playerState == PlayerState.stopped;
  bool get _dipause => _playerState == PlayerState.paused;

  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  final PageController pageCont = PageController();
  //
  //
  @override
  void initState() {
    super.initState();

    _audioPlayer = AudioPlayer();
    //
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(_animationController);

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
        // Timer(Duration(seconds: 4), () {
        //   _animationController.stop();
        // });
        _audioPlayer.onPlayerComplete.listen((event) {
          setState(() {
            _animationController.stop();
          });
        });
      }
    });
  }

  @override
  void dispose() {
    pageCont.addListener(() {
      _audioPlayer.stop();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/back.jpg"),
          fit: BoxFit.fitHeight,
          opacity: 0.4,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 35, bottom: 20),
            child: Container(
              alignment: Alignment.center,
              height: 120,
              child: Image.asset("assets/images/logohome.png"),
            ),
          ),
          Expanded(
            child: PageView(
              controller: pageCont,
              onPageChanged: (value) {
                _audioPlayer.stop();
                _animationController.stop();
                @override
                Future<void> dispose() async {
                  super.dispose(); //change here
                  await _audioPlayer.stop();
                }
              },
              children: <Widget>[
                gridku(gambare1, jenenge1, suarane1),
                gridku(gambare2, jenenge2, suarane2),
                gridku(gambare3, jenenge3, suarane3),
                gridku(gambare4, jenenge4, suarane4),
                gridku(gambare5, jenenge5, suarane5),
                gridku(gambare6, jenenge6, suarane6),
                // gridku(),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  GridView gridku(List<String> gambare, List<String> jenenge, List<String> suarane) {
    return GridView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: 20, bottom: 40, left: 10, right: 10),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: gambare.length,
        itemBuilder: (BuildContext ctx, i) {
          return GestureDetector(
            onTap: () {
              setState(() {
                onTapIndex = i;
              });
              _animationController.forward();
              if (_isPlaying) {
                _audioPlayer.stop();
              } else {
                _audioPlayer.play(AssetSource(suarane[i]));
              }
            },
            child: Container(
              decoration: BoxDecoration(
                // color: Color.fromARGB(255, 246, 231, 188),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  onTapIndex == i
                      ? RippleAnimation(
                          duration: Duration(seconds: 3),
                          repeat: false,
                          color: Color.fromARGB(255, 123, 132, 43),
                          minRadius: 70,
                          ripplesCount: 3,
                          child: Container(),
                        )
                      : SizedBox(),
                  onTapIndex == i
                      ? ScaleTransition(
                          scale: _animation,
                          child: Image.asset(
                            gambare[i],
                            fit: BoxFit.contain,
                            height: double.maxFinite,
                            width: double.maxFinite,
                          ),
                        )
                      : Image.asset(
                          gambare[i],
                          fit: BoxFit.contain,
                          height: double.maxFinite,
                          width: double.maxFinite,
                        ),
                  Positioned(
                    // bottom: 40,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: 190,
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            jenenge[i],
                            textAlign: TextAlign.center,
                            // maxLines: 2,
                            style: TextStyle(
                              fontFamily: "cartoon",
                              fontSize: 9,
                              height: 2,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 5
                                ..color = Colors.black, // <-- Border color
                            ),
                          ),
                        ),
                        Container(
                          width: 190,
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            jenenge[i],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "cartoon",
                              fontSize: 9,
                              height: 2,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 207, 233, 106), // <-- Inner color
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
