import 'dart:convert';

import 'package:http/http.dart' as http;

typedef successCallback = void Function(Object json, String message);

typedef failedCallback = void Function(String message);

class APIManger {
  Map<String, String> headers = {"Content-type": "application/json"};

  void apiRequest(String apiName, Map<String, dynamic> params,
      successCallback success, failedCallback failed) async {
    // make POST request

    final response = await http.post(Uri.parse(apiName), body: params);

    if (response.statusCode == 200) {
      var resBody = json.decode(response.body.toString());
      if (resBody["status"] == true) {
        //Map<String, dynamic> responseJson = resBody["response"];
        success(resBody["response"], resBody["message"]);
      } else {
        failed(resBody["message"]);
      }
    } else {
      failed("Something went wrong");
      // throw Exception('Failed to create new sign up');
    }
  }
}
