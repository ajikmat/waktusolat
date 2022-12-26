import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ListViewTime extends StatelessWidget {
  ListViewTime({
    this.data,
    this.namaWaktu,
  });

  final data;
  final namaWaktu;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.only(top: 0.0),
        physics: BouncingScrollPhysics(),
        itemCount: data?.length - 1,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            child: ListTile(
              leading: Container(
                  width: 30,
                  height: 30,
                  color: Colors.transparent,
                  child: Icon(Icons.nights_stay_rounded)),
              //   SvgPicture.asset(
              //   'assets/images/svg_$index.svg',
              //   width: 100,
              //   height: 100,
              // ),
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      namaWaktu[index],
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(data[index]),
                  ],
                ),
              ),
              trailing: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.lightGreenAccent[100],
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Icon(Icons.notifications_active),
              ),
            ),
          );
        });
  }
}
