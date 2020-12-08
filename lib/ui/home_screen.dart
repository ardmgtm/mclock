import 'package:flutter/material.dart';
import 'package:mclock/ui/alarm_page.dart';
import 'package:mclock/ui/countdown_page.dart';
import 'package:mclock/ui/stopwatch_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  List<String> _titles = ["Clock & Alarm", "Stopwatch", "Countdown"];
  String _title;

  @override
  void initState() {
    _controller = new TabController(vsync: this, length: 3);
    _title = _titles[0];
    _controller.addListener(_titleChange);
    super.initState();
  }

  void _titleChange() {
    setState(() {
      _title = _titles[_controller.index];
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF192734),
      appBar: AppBar(
        elevation: 0,
        title: Text(_title),
        backgroundColor: Color(0xFF192734),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(
              Icons.tune_rounded,
              color: Colors.grey[200],
            ),
          )
        ],
        bottom: TabBar(
          controller: _controller,
          indicatorColor: Colors.purple,
          isScrollable: true,
          tabs: <Widget>[
            Tab(
              icon: Icon(
                Icons.alarm,
                color: Colors.grey[200],
                size: 20,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.timer,
                color: Colors.grey[200],
                size: 20,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.hourglass_empty_outlined,
                color: Colors.grey[200],
                size: 20,
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          AlarmPage(),
          StopwatchPage(),
          CountdownPage(),
        ],
      ),
    );
  }
}
