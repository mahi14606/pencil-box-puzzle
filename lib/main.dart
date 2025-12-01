import 'dart:async';
// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const MaterialApp(home: TiltGame()));
}

class TiltGame extends StatefulWidget {
  const TiltGame({super.key});

  @override
  State<TiltGame> createState() => _TiltGameState();
}

class _TiltGameState extends State<TiltGame>
    with SingleTickerProviderStateMixin {
  double? screenWidth;
  double? screenHeight;

  double xPosition = 0;
  double yPosition = 0;

  double xVelocity = 0;
  double yVelocity = 0;

  double sensitivity = 0.1;
  double ballSize = 20;
  double friction = 0.96;

  late Ticker _ticker;

  double tiltX = 0;
  double tiltY = 0;

  double ballRestitution = -0.5;

  StreamSubscription? subscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _ticker = createTicker((elapsed) {
      setState(() {
        xVelocity = xVelocity - (tiltX * sensitivity);
        yVelocity = yVelocity + (tiltY * sensitivity);

        xPosition = xPosition + xVelocity;
        yPosition = yPosition + yVelocity;

        xVelocity = xVelocity * friction; // Friction
        yVelocity = yVelocity * friction; // Friction

        if (screenWidth != null && screenHeight != null) {
          if (xPosition < 0) {
            xPosition = 0;
            xVelocity = xVelocity * ballRestitution;
          } else if (xPosition > (screenWidth! - ballSize)) {
            xPosition = screenWidth! - ballSize;
            xVelocity = xVelocity * ballRestitution;
          }

          if (yPosition < 0) {
            yPosition = 0;
            yVelocity = yVelocity * ballRestitution;
          } else if (yPosition > (screenHeight! - ballSize)) {
            yPosition = screenHeight! - ballSize;
            yVelocity = yVelocity * ballRestitution;
          }
        }
      });
    });

    _ticker.start();

    subscription = accelerometerEventStream().listen((event) {
      tiltX = event.x;
      tiltY = event.y;
      /*       setState(() {

        xVelocity = xVelocity - (event.x * sensitivity);
        yVelocity = yVelocity + (event.y * sensitivity);
        xVelocity = xVelocity * friction; // Friction
        yVelocity = yVelocity * friction; // Friction
        
        xPosition = xPosition + xVelocity;
        yPosition = yPosition + yVelocity;

        if(xPosition < 0){
          xPosition = 0;
          xVelocity = 0;
        } else if(xPosition > (screenWidth! - ballSize)){
          xPosition = screenWidth! - ballSize;
          xVelocity = 0;
        }

        if(yPosition < 0){
          yPosition = 0;
          yVelocity = 0;
        } else if(yPosition > (screenHeight! - ballSize)){
          yPosition = screenHeight! - ballSize;
          yVelocity = 0;
        }

        /* if(screenWidth != null && screenHeight != null){
          // Constrain within screen bounds
          xPosition = xPosition.clamp(-screenWidth!/2 + ballSize/2, screenWidth!/2 - ballSize/2);
          yPosition = yPosition.clamp(-screenHeight!/2 + ballSize/2, screenHeight!/2 - ballSize/2);
        } */

       /* if(screenWidth != null){
          xPosition = xPosition.clamp(0, screenWidth!-ballSize);
        }
        if(screenHeight != null){
          yPosition = yPosition.clamp(0, screenHeight!-ballSize);
        } */
      }); */
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Stack(
        children: [
          Positioned(
            // left: MediaQuery.of(context).size.width / 2 - xPosition * sensitivity - ballSize / 2,
            // top: MediaQuery.of(context).size.height / 2 + yPosition * sensitivity - ballSize / 2,
            left: xPosition,
            top: yPosition,

            child: Container(
              width: ballSize,
              height: ballSize,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(185, 237, 228, 1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
            ),
            // child: const Icon(Icons.circle, size: 50, color: Colors.red),
          ),
        ],
        /* child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("X: ${x.toStringAsFixed(2)}, Y: ${y.toStringAsFixed(2)}", style: TextStyle(fontSize: 20))],
        ) */
      ),
    );
  }
}
