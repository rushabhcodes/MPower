import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:client/utils/colors.dart'; // Add this import statement

class BreathingPage extends StatefulWidget {
  @override
  _BreathingPageState createState() => _BreathingPageState();
}

class _BreathingPageState extends State<BreathingPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  bool _isBreathingIn = true;
  bool _isTextChanging = false;
  bool _animationPaused = true; // Flag to indicate whether animation is paused
  List<String> _texts = [
    'Breathe',
    'Breathe',
    'Breathe',
    'Breathe',
  ];
  int _currentTextIndex = 0;
  int _timerSeconds = 60;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    )..addStatusListener((status) {
        if (status == AnimationStatus.forward) {
          _isTextChanging = true; // Set flag when animation starts
        } else if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          _isTextChanging =
              false; // Reset flag when animation completes or restarts
        }
        if (status == AnimationStatus.completed) {
          setState(() {
            _isBreathingIn = !_isBreathingIn;
            _controller.reverse();
          });
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });

    _colorAnimation = ColorTween(
      begin: Color(0xFF44005D),
      end: Color(0xFF8C1C6B),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel(); // Cancel the timer when disposing the widget
    super.dispose();
  }

  void _startAnimation() {
    setState(() {
      _animationPaused = false;
    });
    _controller.forward();

    // Start timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      HapticFeedback.vibrate();

      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          _timer.cancel(); // Stop the timer when it reaches 0
          _showDialog(); // Display dialog when timer ends
        }
      });
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Breathing Exercise Completed"),
          content: Text("Do you want to continue?"),
          actions: <Widget>[
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                _timerSeconds = 60; // Reset timer
                _startAnimation(); // Start animation again
              },
            ),
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Return to home page
              },
            ),
          ],
        );
      },
    );
  }

  String _formatTime(int seconds) {
    int minutes = (seconds / 60).truncate();
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Breathing Exercise',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                  color: seaBlue, borderRadius: BorderRadius.circular(15)),
              child: Center(
                child: Text(
                  _formatTime(_timerSeconds),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            SizedBox(height: 50),
            Text(
              _texts[_currentTextIndex],
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                if (!_controller.isAnimating) {
                  _controller.forward();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    // BoxShadow(
                    //   color:lightPurple.withOpacity(0.3),
                    //   spreadRadius: 5,
                    //   blurRadius: 7,
                    //   offset: Offset(0, 3),
                    // ),
                  ],
                ),
                width: 300,
                height: 300,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _controller.value * 1.5,
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [seaBlue, deepPurple],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: lightPurple.withOpacity(0.3),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // ElevatedButton(
            //   onPressed: _startAnimation,
            //   child: Text('Start'),
            // ),
            SizedBox(
              height: 20,
            ),

            InkWell(
              onTap: _startAnimation,
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 20),
                height: 60,
                decoration: BoxDecoration(
                    color: deepPurple, borderRadius: BorderRadius.circular(15)),
                child: Center(
                    child: Text(
                  "Start Excersise",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
