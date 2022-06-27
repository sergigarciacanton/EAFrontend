import 'package:ea_frontend/jovo_client/models/request.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:convert';

class JovoService {
  static var webHook = dotenv.env['JOVO_WEBHOOK'];

  static Future<JovoRequest> sendRequest(JovoRequest req) async {
    if (webHook == null) {
      webHook =
          "https://webhook.jovo.cloud/1651c792-5457-46cb-a12c-4317bbce3a81";
    }
    var res = await http.post(Uri.parse(webHook!),
        headers: {'content-type': 'application/json'},
        body: json.encode(req.toJson()));

    //if (res.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(res.body);
    return JovoRequest.fromJson(data);
  }
}
