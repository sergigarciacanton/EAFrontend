import 'package:ea_frontend/jovo_client/models/request.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:convert';

class JovoService {
  static var webHook = const String.fromEnvironment('JOVO_WEBHOOK',
      defaultValue:
          "https://webhook.jovo.cloud/3c560306-c965-4bd9-89d4-fb3c42854ddf");

  static Future<JovoRequest> sendRequest(JovoRequest req) async {
    var res = await http.post(Uri.parse(webHook),
        headers: {'content-type': 'application/json'},
        body: json.encode(req.toJson()));

    //if (res.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(res.body);
    return JovoRequest.fromJson(data);
  }
}
