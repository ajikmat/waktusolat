import 'package:flutter/material.dart';

import 'package:waktu_solat_malaysia/screens/loading_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: LoadingScreen(),
    );
  }
}

//TODO: Location ada yang tak tunjuk dekat text bawah jam
//TODO: ada latitude/longitude MPT tak dapat kesan, cuba try bundarkan no tersebut
//TODO: Countdown
//TODO: Notification
//TODO: Dekat DecodebyJ, cari cara utk buangkan guna internet utk cari ZONE.
//TODO: Refactor balik code dekat STORAGE