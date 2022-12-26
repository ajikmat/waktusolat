import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class NetworkHelper {
  Future getData(String url) async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String data = response.body;

      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }

  Future postData(url, date) async {
    var tenDays =
        DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 10)));

    Map<String, dynamic> duration = {};

    duration['datestart'] = date;
    duration['dateend'] = tenDays;

    http.Response response = await http.post(
      Uri.parse(url),
      headers: {
        "Accept": "*/*",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: duration,
    );

    if (response.statusCode == 200) {
      String data = response.body;
      //print(response.body);
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}
