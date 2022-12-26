import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waktu_solat_malaysia/screens/main_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:waktu_solat_malaysia/services/waktu_solat_data.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late final double latitude;
  late final double longitude;
  var currentAddress;
  var first;
  var passDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  void getCurrentLocation() async {
    try {
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      latitude = position.latitude;
      longitude = position.longitude;
      print(position);
      print(passDate);
    } catch (e) {
      print(e);
    }

    var data = await getCurrentPrayerTime();

    getCurrentAddress(data);
  }

  Future<dynamic> getCurrentPrayerTime() async {
    try {
      WaktuSolat waktuSolat = WaktuSolat(
          longitude: longitude.toString(), latitude: latitude.toString());

      var data = await waktuSolat.getListWaktuSolat2(passDate);

      return data;
    } catch (e) {
      print(e);
    }
  }

  void getCurrentAddress(var data) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);

    Placemark place = placemarks[0];
    print("${place.locality}, ${place.postalCode}, ${place.country}");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MainScreen(
            currentLocation: place,
            currentWaktu: data,
            latitude: latitude,
            longitude: longitude,
          );
        },
      ),
    );

    //Negeri,  Daerah
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Loading Bero'),
      ),
    );
  }
}
