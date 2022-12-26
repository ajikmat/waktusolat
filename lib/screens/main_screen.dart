import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waktu_solat_malaysia/components/background_app.dart';
import 'package:waktu_solat_malaysia/components/centre_container.dart';
import 'package:waktu_solat_malaysia/components/digital_clock.dart';
import 'package:waktu_solat_malaysia/components/list_waktu_solat.dart';
import 'package:waktu_solat_malaysia/constant/constant.dart';
import 'package:waktu_solat_malaysia/constant/screen_config.dart';
import 'package:waktu_solat_malaysia/services/storage.dart';
import 'package:waktu_solat_malaysia/services/waktu_solat_data.dart';

class MainScreen extends StatefulWidget {
  MainScreen(
      {required this.currentLocation,
      this.currentWaktu,
      this.latitude,
      this.longitude});

  final currentLocation;
  late final currentWaktu;
  final latitude;
  final longitude;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late String negeri;
  late String daerah;
  late String masihi;
  late String date;
  var passDate;
  var data;
  bool isDispose = true;
  bool isLoading = true;
  var todayWaktu;

  var dateTime = DateTime.now();
  var nextDay =
      DateFormat('dd MMMM yyyy').format(DateTime.now().add(Duration(days: 1)));

  @override
  void initState() {
    super.initState();

    checkCurrentWaktu(widget.currentWaktu);

    updateFirstUI(widget.currentLocation, widget.currentWaktu);
    date = DateFormat('dd MMMM yyyy').format(dateTime);
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => isDispose = !isDispose);

    if (this.mounted) {
      setState(() {
        Timer.periodic(Duration(seconds: 3), (timer) {
          if (nextDay == DateFormat('dd MMMM yyyy').format(DateTime.now())) {
            Future.delayed(Duration(seconds: 2), () {
              setState(() {
                i++;
                date = DateFormat('dd MMMM yyyy').format(DateTime.now());
                passDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
                nextDay = DateFormat('dd MMMM yyyy')
                    .format(DateTime.now().add(Duration(days: 1)));

                updateWaktu(passDate);
              });
            });
          }
        });
      });
    }
  }

  void checkCurrentWaktu(var currentWaktu) {
    todayWaktu = widget.currentWaktu;
  }

  void updateFirstUI(var location, var currentData) async {
    setState(() {
      if (location == null && currentData == null) {
        location.name = null;
        location.locality = null;
        masihi = 'error';
        return;
      }

      negeri = location.administrativeArea;
      daerah = location.locality;
      masihi = currentData[6].toString();
    });
  }

  updateWaktu(passDate) async {
    data = await WaktuSolat(
      latitude: widget.latitude.toString(),
      longitude: widget.longitude.toString(),
    ).getListWaktuSolat2(passDate);
    if (isLoading == false) {
      isLoading = true;
    }

    setState(() {
      masihi = data[6];
    });
  }

  var i = 0;

  List<String> namaWaktu = [
    'Subuh',
    'Syuruk',
    'Zuhr',
    'Asar',
    'Maghrib',
    'Isya'
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'MyWaktu',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings),
          )
        ],
      ),
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              BackgroundApp(),
              Positioned(
                //JAM
                left: getProportionateScreenWidth(30),
                bottom: getProportionateScreenHeight(111),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DigitalClock(),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '$daerah, $negeri',
                      style: TextStyle(
                          fontSize: getProportionateScreenWidth(20),
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                builder: (builder, snapshot) {
                  return CenterContainer(
                      data: isDispose ? widget.currentWaktu : todayWaktu);
                },
              )
            ],
          ),
          SizedBox(
            height: getProportionateScreenHeight(75),
          ),
          Container(
            height: getProportionateScreenHeight(374),
            width: getProportionateScreenWidth(370),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: kDefaultBorderRadius,
              boxShadow: [
                BoxShadow(
                    offset: Offset(1, 3),
                    blurRadius: 1,
                    color: Color(0xFFc1c1c1).withOpacity(0.8))
              ],
              border: Border.all(color: Colors.transparent),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(3),
                  height: getProportionateScreenHeight(70),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: isLoading && (i > 0)
                            ? () async {
                                setState(() {
                                  i--;

                                  isLoading = false;

                                  date = DateFormat('dd MMMM yyyy').format(
                                      dateTime.subtract(Duration(days: -i)));

                                  passDate = DateFormat('yyyy-MM-dd').format(
                                      dateTime.subtract(Duration(days: -i)));
                                });

                                // final path = await Storage().getFilePath();
                                // if (File('$path/$passDate.json').existsSync() ==
                                //     true) {
                                //   print(
                                //       File('$path/$passDate.json').toString());
                                //   isLoading = false;
                                // }

                                updateWaktu(passDate);
                              }
                            : null,
                        child: Icon(
                          Icons.navigate_before,
                          size: getProportionateScreenHeight(40),
                          color:
                              isLoading && (i > 0) ? Colors.black : Colors.grey,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            (date),
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          FutureBuilder(
                            builder: (context, snapshot) {
                              return Text(
                                masihi,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15),
                              );
                            },
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: isLoading && (i < 31)
                            ? () async {
                                setState(() {
                                  i++;

                                  isLoading = false;
                                  date = DateFormat('dd MMMM yyyy')
                                      .format(dateTime.add(Duration(days: i)));

                                  passDate = DateFormat('yyyy-MM-dd')
                                      .format(dateTime.add(Duration(days: i)));
                                });

                                // final path = await Storage().getFilePath();
                                // if (File('$path/$passDate.json').existsSync() ==
                                //     false) {
                                //   print(
                                //       File('$path/$passDate.json').toString());
                                //   isLoading = false;
                                // }
                                updateWaktu(passDate);
                              }
                            : null,
                        child: Icon(
                          Icons.navigate_next,
                          size: getProportionateScreenHeight(40),
                          color: isLoading && (i < 31)
                              ? Colors.black
                              : Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
                Divider(
                  thickness: 1.5,
                ),
                ListWaktuSolat(
                  isLoading: isLoading,
                  isDispose: isDispose,
                  widget: widget,
                  data: data,
                  namaWaktu: namaWaktu,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
