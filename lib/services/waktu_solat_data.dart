import 'dart:convert';
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
  Storage storage = Storage();
  Storage2 storage2 = Storage2();
  NetworkHelper networkHelper = NetworkHelper();

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

  Future<List<String>> getListWaktuSolat2(String passDate) async {
    List<String> listWaktuSolat3 = [];

    var zoneData =
        await networkHelper.getData(_urlzone + '$latitude,$longitude');

    String zone = zoneData['data']['attributes']['jakim_code'];

    try {
      var data = await networkHelper.postData(
        _url + '$zone' + '&period=duration',
        passDate,
      );

      await storage2.saveToFile(jsonEncode(data), zone);

      await storage2.readFromFile(zone).then((value) async {
        listWaktuSolat3 = decodeWaktu(value);
      });
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

  Future<List<String>> decodeWaktubyJ(int j) async {
    print(j);
    var zoneData =
        await networkHelper.getData(_urlzone + '$latitude,$longitude');

    String zone = zoneData['data']['attributes']['jakim_code'];

    var data = await storage2.readFromFile(zone);
    List<String> listWaktuSolat2 = [];
    var time;

    for (var i = 0; i < waktu.length; i++) {
      time = DateFormat.jm().format(DateFormat("hh:mm:ss")
          .parse(jsonDecode(data)['prayerTime'][j][waktu[i]]));

      listWaktuSolat2.add(time);
    }

    List month =
        jsonDecode(data)['prayerTime'][j]['hijri'].toString().split('-');
    String noOfMonth =
        jsonDecode(data)['prayerTime'][j]['hijri'].toString().split('-')[1];

    String hijri =
        '${month[2]} ${month[1].replaceAll(noOfMonth, namaBulanIslam[noOfMonth].toString())} ${month[0]}H';

    listWaktuSolat2.add(hijri);

    return listWaktuSolat2;
  }
}
