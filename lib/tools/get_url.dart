// this class for method get url by http

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class GetUrl {
  Future getUrlMethod(Uri url) async {
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        var itemCount = jsonResponse;
        return itemCount;
      } else {
        return "failed";
      }
    } catch (ex) {
      return "failed";
    }
  }
}
