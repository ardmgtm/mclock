import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CountdownPage extends StatefulWidget {
  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> {
  bool _isStopped = true;
  Duration _countdownTime = Duration.zero;
  Duration _lastCountDown = Duration.zero;
  Timer _timer;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_countdownTime.inSeconds > 0) {
            _isStopped = false;
            _countdownTime = _countdownTime - Duration(seconds: 1);
          } else {
            timer.cancel();
            _isStopped = true;
          }
        },
      ),
    );
  }

  String _printCountdownTime() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(_countdownTime.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(_countdownTime.inSeconds.remainder(60));
    return "${twoDigits(_countdownTime.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 16),
          CircularPercentIndicator(
            radius: 250,
            lineWidth: 8,
            percent: _isStopped
                ? 0.0
                : 1.0 -
                    ((_lastCountDown - _countdownTime).inSeconds /
                        _lastCountDown.inSeconds),
            center: Text(
              _printCountdownTime(),
              style: TextStyle(
                color: Colors.grey[200],
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: Colors.purple[700],
            backgroundColor: Colors.grey[200].withOpacity(0.1),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: _isStopped,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _countdownTime = _lastCountDown;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Icon(
                      Icons.refresh,
                      color: Colors.grey[200],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (_countdownTime == Duration.zero) {
                    } else if (_isStopped) {
                      _lastCountDown = _countdownTime;
                      startTimer();
                    } else {
                      _isStopped = true;
                      _countdownTime = Duration.zero;
                      _timer.cancel();
                    }
                  });
                },
                child: Opacity(
                  opacity: (_countdownTime == Duration.zero) ? 0.5 : 1.0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.purple[700],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _isStopped ? Icons.play_arrow : Icons.stop,
                          color: Colors.white,
                        ),
                        Text(
                          _isStopped ? "Play" : "Stop",
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
              ),
              Visibility(
                visible: _isStopped,
                child: GestureDetector(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Icon(
                      Icons.edit,
                      color: Colors.grey[200],
                    ),
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (BuildContext builder) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                          ),
                          height: MediaQuery.of(context).size.height / 3,
                          child: CupertinoTimerPicker(
                            mode: CupertinoTimerPickerMode.hms,
                            initialTimerDuration: _countdownTime,
                            onTimerDurationChanged: (Duration changedtimer) {
                              setState(() {
                                _countdownTime = changedtimer;
                              });
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
