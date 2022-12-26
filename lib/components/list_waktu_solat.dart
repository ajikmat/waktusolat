import 'package:flutter/material.dart';
import 'package:waktu_solat_malaysia/constant/screen_config.dart';
import 'package:waktu_solat_malaysia/models/models.dart';
import 'package:waktu_solat_malaysia/screens/main_screen.dart';

class ListWaktuSolat extends StatelessWidget {
  const ListWaktuSolat({
    Key? key,
    required this.isLoading,
    required this.isDispose,
    required this.widget,
    required this.data,
    required this.namaWaktu,
  }) : super(key: key);

  final bool isLoading;
  final bool isDispose;
  final MainScreen widget;
  final data;
  final List<String> namaWaktu;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: (context, snapshot) {
      return Container(
          padding: EdgeInsets.only(top: 5, right: 5, left: 5),
          height: getProportionateScreenHeight(258),
          width: getProportionateScreenWidth(350),
          child: ListViewTime(
            data: isDispose ? widget.currentWaktu : data ?? [''],
            namaWaktu: namaWaktu,
          ));
    });
  }
}
