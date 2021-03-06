import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mclock/model/alarm.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AlarmPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Alarm> _alarmList = [
      Alarm(Duration(hours: 05, minutes: 30), true, true, "Wake Up !"),
      Alarm(Duration(hours: 07, minutes: 00), true, true, "Start Working"),
      Alarm(Duration(hours: 13, minutes: 30), false, true, "Meet Client"),
      Alarm(Duration(hours: 16, minutes: 00), true, true, "Go Home"),
      Alarm(Duration(hours: 17, minutes: 00), false, true, "Go Shopping"),
    ];
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              Container(
                height: 200,
                width: 200,
                padding: EdgeInsets.all(16),
                child: AnalogClock(
                  datetime: DateTime.now(),
                  showDigitalClock: false,
                  showNumbers: false,
                  showTicks: false,
                  hourHandColor: Colors.grey[100],
                  minuteHandColor: Colors.grey[200],
                  secondHandColor: Colors.purple[600],
                  isLive: true,
                ),
              ),
              Text(
                DateTime.now().timeZoneName,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.purple[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
              TimerBuilder.periodic(
                Duration(seconds: 1),
                builder: (context) {
                  DateTime now = DateTime.now();
                  return Text(
                    "${DateFormat("hh:mm a").format(now)}",
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.grey[200],
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
        SlidingUpPanel(
          color: Colors.grey[200],
          margin: EdgeInsets.symmetric(horizontal: 16),
          minHeight: MediaQuery.of(context).size.height * 0.3,
          maxHeight: MediaQuery.of(context).size.height -
              Scaffold.of(context).appBarMaxHeight -
              16,
          parallaxOffset: 0.6,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          panel: Column(
            children: [
              Container(
                height: 4,
                width: 32,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
                margin: EdgeInsets.all(8),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.purple[700],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      "+ add alarm",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: _alarmList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat.jm().format(
                                  DateTime(0).add(_alarmList[index].time),
                                ),
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: _alarmList[index].isActive
                                      ? Colors.grey[800]
                                      : Colors.grey[400],
                                ),
                              ),
                              Text(
                                _alarmList[index].label,
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                            ],
                          ),
                          Switch(
                            activeColor: Colors.purple[700],
                            activeTrackColor: Colors.grey[400],
                            inactiveTrackColor: Colors.grey[400],
                            value: _alarmList[index].isActive,
                            onChanged: (bool value) {},
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
