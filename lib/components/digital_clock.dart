import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DigitalClock extends StatefulWidget {
  const DigitalClock({super.key});

  @override
  State<DigitalClock> createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  late String _currentTime;
  late Timer _timer;

  void updateTime() {
    setState(() {
      _currentTime = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
    });
  }

  @override
  void initState() {
    super.initState();

    // update time
    updateTime();

    // update every 1 second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      updateTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _currentTime,
      style: TextStyle(fontSize: 16),
      overflow: TextOverflow.ellipsis,
    );
  }
}
