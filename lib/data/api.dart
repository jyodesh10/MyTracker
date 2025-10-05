import "package:http/http.dart" as http;

import "../constant.dart";

class Api {
  static Future<String> getCurrency() async {
    try {
      var response = await http.get(Uri.parse(currencyUrl));

      return response.body;
    } on Exception catch (e) {
      return e.toString();
    }
  }
}
