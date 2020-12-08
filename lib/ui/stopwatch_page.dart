import 'dart:async';

import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class StopwatchPage extends StatefulWidget {
  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  bool _isPaused = false;
  bool _isStopped = true;
  Duration _stopwatchTime = Duration.zero;
  Timer _timer;
  List<Duration> _capturedTime = [];

  void startTimer() {
    const oneSec = const Duration(milliseconds: 100);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          _stopwatchTime += Duration(milliseconds: 100);
        },
      ),
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String miliseconds =
        twoDigits(duration.inMilliseconds.remainder(1000) ~/ 10);
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds.$miliseconds";
  }

  @override
  void dispose() {
    if (_timer != null) _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 32),
        Stack(
          children: [
            CircularStepProgressIndicator(
              startingAngle: 3.14 * _stopwatchTime.inSeconds.remainder(60) / 30,
              totalSteps: 60,
              stepSize: 20,
              padding: 3.14 / 25,
              width: 250,
              height: 250,
              customColor: (index) => (_isStopped)
                  ? Colors.purple.withOpacity(0.5)
                  : index < 10
                      ? Colors.purple.withOpacity(0.5)
                      : index < 20
                          ? Colors.purple.withOpacity(0.6)
                          : index < 30
                              ? Colors.purple.withOpacity(0.7)
                              : index < 40
                                  ? Colors.purple.withOpacity(0.8)
                                  : index < 50
                                      ? Colors.purple.withOpacity(0.9)
                                      : Colors.purple.withOpacity(1),
            ),
            Container(
              height: 250,
              width: 250,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  _printDuration(_stopwatchTime),
                  style: TextStyle(
                    color: Colors.grey[200],
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  if (_isStopped || _isPaused) {
                    _isPaused = false;
                    _isStopped = false;
                    startTimer();
                  } else {
                    _timer.cancel();
                    _isStopped = true;
                    _capturedTime = [];
                    _stopwatchTime = Duration.zero;
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.purple[700],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isStopped || _isPaused ? Icons.play_arrow : Icons.stop,
                      color: Colors.white,
                    ),
                    Text(
                      _isStopped || _isPaused ? "Play" : "Stop",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: !_isStopped && !_isPaused,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _timer.cancel();
                    _isPaused = true;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Icon(
                    Icons.pause,
                    color: Colors.grey[200],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: !_isStopped && !_isPaused,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _capturedTime.add(_stopwatchTime);
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Icon(
                    Icons.flag,
                    color: Colors.grey[200],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: ListView.separated(
              itemCount: _capturedTime.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        (index + 1).toString(),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "+ " +
                            _printDuration((index < 1)
                                ? _capturedTime[index]
                                : _capturedTime[index] -
                                    _capturedTime[index - 1]),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        _printDuration(_capturedTime[index]),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  color: Colors.white.withOpacity(0.5),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
