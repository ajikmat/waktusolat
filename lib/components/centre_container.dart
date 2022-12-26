import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waktu_solat_malaysia/constant/constant.dart';
import 'package:waktu_solat_malaysia/constant/screen_config.dart';

class CenterContainer extends StatefulWidget {
  CenterContainer({Key? key, this.data}) : super(key: key);

  final data;

  @override
  _CenterContainerState createState() => _CenterContainerState();
}

class _CenterContainerState extends State<CenterContainer> {
  var indexWaktu;

  var waktuSubuhTime;
  var waktuSyurukTime;
  var waktuZuhrTime;
  var waktuAsrTime;
  var waktuMaghribTime;
  var waktuIsyakTime;
  String centre = '';
  List<String> namaWaktu = [
    'Subuh',
    'Syuruk',
    'Zuhr',
    'Asar',
    'Maghrib',
    'Isya'
  ];

  DateTime currentTime = DateTime.now();
  var formatted = DateFormat("HH:mm:ss");
  var date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  var asdfnextDay =
      DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 1)));

  @override
  void initState() {
    super.initState();
    changeFormatted(widget.data);
    checkCurrentWaktu();

    if (this.mounted) {
      setState(() {
        Timer.periodic(Duration(seconds: 2), (timer) {
          setState(() {
            checkCurrentWaktu();
          });
        });
      });
    }
  }

  void changeFormatted(var data) {
    waktuSubuhTime = DateTime.parse(
        date + ' ' + formatted.format(DateFormat.jm().parse(data[0])));

    waktuSyurukTime = DateTime.parse(
        date + ' ' + formatted.format(DateFormat.jm().parse(data[1])));

    waktuZuhrTime = DateTime.parse(
        date + ' ' + formatted.format(DateFormat.jm().parse(data[2])));

    waktuAsrTime = DateTime.parse(
        date + ' ' + formatted.format(DateFormat.jm().parse(data[3])));

    waktuMaghribTime = DateTime.parse(
        date + ' ' + formatted.format(DateFormat.jm().parse(data[4])));

    waktuIsyakTime = DateTime.parse(
        date + ' ' + formatted.format(DateFormat.jm().parse(data[5])));
  }

  void checkCurrentWaktu() async {
    if (DateTime.now().isAfter(waktuSubuhTime) && //next waktu is syuruk
        DateTime.now().isBefore(waktuSyurukTime)) {
      indexWaktu = 1;
      updateUI(indexWaktu);
    } else if (DateTime.now().isAfter(waktuSyurukTime) && //next waktu is zuhr
        DateTime.now().isBefore(waktuZuhrTime)) {
      indexWaktu = 2;
      updateUI(indexWaktu);
    } else if (DateTime.now().isAfter(waktuSubuhTime) && //next waktu is asar
        currentTime.isBefore(waktuAsrTime)) {
      indexWaktu = 3;
      updateUI(indexWaktu);
    } else if (DateTime.now().isAfter(waktuAsrTime) && //next waktu is maghrib
        DateTime.now().isBefore(waktuMaghribTime)) {
      indexWaktu = 4;
      updateUI(indexWaktu);
    } else if (DateTime.now().isAfter(waktuMaghribTime) && //next waktu is isyak
        DateTime.now().isBefore(waktuIsyakTime)) {
      indexWaktu = 5;
      updateUI(indexWaktu);
    } else {
      indexWaktu = 0;
      updateUI(indexWaktu);

      if (DateFormat('yyyy-MM-dd').format(DateTime.now()) == asdfnextDay) {
        Future.delayed(Duration(seconds: 1), () {
          indexWaktu = 0;
          updateUI(indexWaktu);
          changeFormatted(widget.data);
          asdfnextDay = DateFormat('yyyy-MM-dd')
              .format(DateTime.now().add(Duration(days: 1)));
        });
      }
    }
  }

  void updateUI(int index) {
    setState(() {
      indexWaktu = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: getProportionateScreenWidth(310),
      child: Container(
        padding:
            EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
        width: getProportionateScreenWidth(370),
        height: getProportionateScreenHeight(110),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 3),
                blurRadius: 1,
                color: Color(0xFFc1c1c1).withOpacity(0.8))
          ],
          border: Border.all(color: Colors.transparent),
          color: Colors.white,
          borderRadius: kDefaultBorderRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Upcoming prayer',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(child: FutureBuilder(builder: (context, snapshot) {
              return Text(
                // indexWaktu != 404 ?
                '${namaWaktu[indexWaktu]} at ${widget.data[indexWaktu]} ',
                // : 'Selamat Malam!',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: getProportionateScreenHeight(25),
                ),
              );
            })),
            SizedBox(
              height: 5,
            ),
            Center(
              child: Text(
                '02:20:04',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: getProportionateScreenWidth(15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
