import 'dart:async';
import 'package:flutter/material.dart';
import 'package:waktu_solat_malaysia/constant/screen_config.dart';

class DigitalClock extends StatefulWidget {
  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  TimeOfDay _timeOfDay = TimeOfDay.now();

  @override
  void initState() {
    super.initState();

    if (this.mounted) {
      setState(() {
        Timer.periodic(Duration(seconds: 1), (timer) {
          if (_timeOfDay.minute != TimeOfDay.now().minute) {
            setState(() {
              _timeOfDay = TimeOfDay.now();
            });
          }
        });
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    String _period = _timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';
    return Row(
      children: [
        Text(
          '${_timeOfDay.hourOfPeriod}:${_timeOfDay.minute.toString().padLeft(2, '0')}',
          style: TextStyle(
            color: Colors.white,
            fontSize: getProportionateScreenWidth(70),
          ),
        ),
        RotatedBox(
          quarterTurns: 3,
          child: Text(
            _period,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(20),
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
