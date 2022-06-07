import 'dart:isolate';

import 'package:ea_frontend/localization/language_constants.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class JovoRequest {
  String? version;
  String? platform;
  String? id;
  String? timestamp;
  String? timeZone;
  String? locale;
  List<Output>? output;
  Data? data;
  Input? input;
  Context? context;

  JovoRequest(
      {this.version,
      this.platform,
      this.id,
      this.timestamp,
      this.timeZone,
      this.locale,
      this.output,
      this.data,
      this.input,
      this.context});

  static Future<JovoRequest> textRequest(String text) async {
    String version = "4.0";
    String platform = "web";
    String id = const Uuid().v1().toString();
    String timestamp = DateTime.now().toUtc().toIso8601String();
    String timeZone =
        "Europe/Madrid"; //await FlutterNativeTimezone.getLocalTimezone();
    String locale = await getLocale().then((value) => value.toString());

    Input input = Input.text(text); //change to data input
    Context context = Context.preset();

    return JovoRequest(
        version: version,
        platform: platform,
        id: id,
        timestamp: timestamp,
        timeZone: timeZone,
        locale: locale,
        input: input,
        context: context);
  }

  static Future<JovoRequest> launchRequest() async {
    String version = "4.0";
    String platform = "web";
    String id = const Uuid().v1().toString();
    String timestamp = DateTime.now().toUtc().toIso8601String();
    String timeZone =
        "Europe/Madrid"; //await FlutterNativeTimezone.getLocalTimezone();
    String locale = await getLocale().then((value) => value.toString());

    Input input = Input.launch(); //change to data input
    Context context = Context.preset();

    return JovoRequest(
        version: version,
        platform: platform,
        id: id,
        timestamp: timestamp,
        timeZone: timeZone,
        locale: locale,
        input: input,
        context: context);
  }

  JovoRequest.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    platform = json['platform'];
    id = json['id'];
    timestamp = json['timestamp'];
    timeZone = json['timeZone'];
    locale = json['locale'];
    if (json['output'] != null) {
      output = <Output>[];
      json['output'].forEach((v) {
        output!.add(new Output.fromJson(v));
      });
    }
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    input = json['input'] != null ? new Input.fromJson(json['input']) : null;
    context =
        json['context'] != null ? new Context.fromJson(json['context']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['platform'] = this.platform;
    data['id'] = this.id;
    data['timestamp'] = this.timestamp;
    data['timeZone'] = this.timeZone;
    data['locale'] = this.locale;
    if (this.output != null) {
      data['output'] = this.output!.map((v) => v.toJson()).toList();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.input != null) {
      data['input'] = this.input!.toJson();
    }
    if (this.context != null) {
      data['context'] = this.context!.toJson();
    }
    return data;
  }
}

class Output {
  String? message;
  String? reprompt;
  bool? listen;

  Output({this.message, this.reprompt, this.listen});

  Output.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    reprompt = json['reprompt'];
    listen = json['listen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['reprompt'] = this.reprompt;
    data['listen'] = this.listen;
    return data;
  }
}

class Data {
  Data();

  Data.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}

class Input {
  String? type;
  String? intent;
  String? text;

  Input({this.type, this.intent, this.text});

  Input.launch() {
    type = "LAUNCH";
  }

  Input.text(String txt) {
    type = "TEXT";
    text = txt;
  }

  Input.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    intent = json['intent'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['intent'] = this.intent;
    data['text'] = this.text;
    return data;
  }
}

class Context {
  Device? device;
  Session? session;
  User? user;

  Context({this.device, this.session, this.user});

  Context.preset() {
    device = Device.textCapability();
    // no data in session
    session = Session(
        id: const Uuid().v1().toString(),
        isNew: true,
        updatedAt: DateTime.now().toUtc().toIso8601String());
    // no data in user
    user = User(id: const Uuid().v1().toString());
  }

  Context.fromJson(Map<String, dynamic> json) {
    device =
        json['device'] != null ? new Device.fromJson(json['device']) : null;
    session =
        json['session'] != null ? new Session.fromJson(json['session']) : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.device != null) {
      data['device'] = this.device!.toJson();
    }
    if (this.session != null) {
      data['session'] = this.session!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class Device {
  List<String>? capabilities;

  Device({this.capabilities});

  Device.textCapability() {
    capabilities = ["TEXT"];
  }

  Device.fromJson(Map<String, dynamic> json) {
    capabilities = json['capabilities'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['capabilities'] = this.capabilities;
    return data;
  }
}

class Session {
  String? id;
  Data? data;
  bool? isNew;
  String? updatedAt;

  Session({this.id, this.data, this.isNew, this.updatedAt});

  Session.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    isNew = json['isNew'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['isNew'] = this.isNew;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class User {
  String? id;
  Data? data;

  User({this.id, this.data});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
