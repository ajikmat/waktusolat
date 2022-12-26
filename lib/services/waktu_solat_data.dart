import 'dart:convert';
import 'dart:io';
import 'package:waktu_solat_malaysia/services/networking.dart';
import 'package:waktu_solat_malaysia/services/storage.dart';
import 'package:intl/intl.dart';

const _url =
    'https://www.e-solat.gov.my/index.php?r=esolatApi/takwimsolat&zone=';

const _urlzone = 'https://mpt.i906.my/api/prayer/';

class WaktuSolat {
  WaktuSolat({required this.latitude, required this.longitude});

  String longitude;
  String latitude;

  DateTime dateTime = DateTime.now();

  final List<String> waktu = [
    'fajr',
    'syuruk',
    'dhuhr',
    'asr',
    'maghrib',
    'isha',
  ];

  Map<String, String> namaBulanIslam = {
    '01': 'Muharram',
    '02': 'Safar',
    '03': 'Rabiul Awal',
    '04': 'Rabiul Akhir',
    '05': 'Jamadil Awal',
    '06': 'Jamadil Akhir',
    '07': 'Rejab',
    '08': 'Syaaban',
    '09': 'Ramadhan',
    '10': 'Syawal',
    '11': 'Zulkaedah',
    '12': 'Zulhijjah',
  };

  Future<List<String>> getListWaktuSolat2(String month) async {
    List<String> listWaktuSolat3 = [];
    Storage storage = Storage();

    NetworkHelper networkHelper = NetworkHelper();

    var zoneData =
        await networkHelper.getData(_urlzone + '$latitude,$longitude');

    String zone = zoneData['data']['attributes']['jakim_code'];

    try {
      final path = await storage.getFilePath();

      if (File('$path/$month-$zone.json').existsSync() == false) {
        var data = await networkHelper.postData(
          _url + '$zone' + '&period=duration',
          month,
        );

        await storage.saveToFile(jsonEncode(data), month, zone);

        print('${month.toString()}-$zone File Does Not Exist, Creating File');
        await storage.readFromFile(month, zone).then((value) async {
          listWaktuSolat3 = decodeWaktu(value);
        });
      } else {
        print('${month.toString()}-$zone File Exist, Reading File');
        var data = await storage.readFromFile(month, zone);

        if (data.contains('null')) {
          print(data);
          var data2 = await networkHelper.postData(
            _url + '$zone' + '&period=duration',
            month,
          );
          print(data2);

          await storage.saveToFile(jsonEncode(data2), month, zone);
          data = await storage.readFromFile(month, zone);
        }

        data.toString();
        listWaktuSolat3 = decodeWaktu(data);
      }
    } catch (e) {
      throw e;
    }

    return listWaktuSolat3;
  }

  List<String> decodeWaktu(var data) {
    List<String> listWaktuSolat2 = [];
    var time;

    for (var i = 0; i < waktu.length; i++) {
      time = DateFormat.jm().format(DateFormat("hh:mm:ss")
          .parse(jsonDecode(data)['prayerTime'][0][waktu[i]]));

      listWaktuSolat2.add(time);
    }

    //Amik data untuk Bulan Islam.
    List month =
        jsonDecode(data)['prayerTime'][0]['hijri'].toString().split('-');
    String noOfMonth =
        jsonDecode(data)['prayerTime'][0]['hijri'].toString().split('-')[1];

    String hijri =
        '${month[2]} ${month[1].replaceAll(noOfMonth, namaBulanIslam[noOfMonth].toString())} ${month[0]}H';

    listWaktuSolat2.add(hijri);

    return listWaktuSolat2;
  }
}
