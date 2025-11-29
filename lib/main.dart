import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const MaterialApp(home: TiltGame()));
}

class TiltGame extends StatefulWidget {
  const TiltGame({super.key});

  @override
  State<TiltGame> createState() => _TiltGameState();
}

class _TiltGameState extends State<TiltGame> {
  double x = 0;
  double y = 0;

  double sensitivity = 30;
  double ballSize = 20;
    
  StreamSubscription? subscription;  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription =  accelerometerEventStream().listen((event) {
      setState(() {
        x = event.x;
        y = event.y;
      });
    });
  }

  @override
  void dispose(){
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Stack(
        children: [
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - x * sensitivity - ballSize / 2,
            top: MediaQuery.of(context).size.height / 2 + y * sensitivity - ballSize / 2,
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

