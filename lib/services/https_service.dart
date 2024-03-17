import 'dart:convert';

import 'package:employee/models/employe_model.dart';
import 'package:http/http.dart';

class Network {

  //https://dummy.restapiexample.com/api/v1/employees

  static String BASE = "dummy.restapiexample.com";
  static Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8'
  };

  /* Http Apis*/
  static String API_POST_LIST = "/employees";
  static String API_POST_CREATE = "/create";
  static String API_POST_UPDATE = "/update/"; //{id}
  static String API_POST_DELETE = "/delete/"; //{id}

  /* Http Requests */
  static Future<String?> GET(String api, Map<String, String> params) async {
    var uri = Uri.http(BASE, api, params);
    var response = await get(uri, headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }

  static Future<String?> POST(String api, Map<String, String> params) async {
    var uri = Uri.http(BASE, api);
    var response = await post(uri, headers: headers, body: jsonEncode(params));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }
    return null;
  }

  static Future<String?> PUT(String api, Map<String, String> params) async {
    var uri = Uri.http(BASE, api);
    var response = await put(uri, headers: headers, body: jsonEncode(params));
    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }

  static Future<String?> DEL(String api, Map<String, String> params) async {
    var uri = Uri.http(BASE, api, params);
    var response = await delete(uri, headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }

  /* Http Params */
  static Map<String, String> paramsEmpty() {
    Map<String, String> params = Map();
    return params;
  }

  static Map<String, String> paramsCreate(Employe employe) {
    Map<String, String> params = new Map();
    params.addAll({
      'name': employe.name!,
      'salary': employe.salary.toString(),
      'age': employe.age.toString(),
    });
    return params;
  }

  static Map<String, String> paramsUpdate(Employe employe) {
    Map<String, String> params = new Map();
    params.addAll({
      'id':employe.id.toString()!,
      'name': employe.name!,
      'salary': employe.salary.toString()!,
      'age': employe.age.toString(),
    });
    return params;
  }

  /* Http Parsing */

  static List<Employe> parsePostList(String response) {
    dynamic json = jsonDecode(response);
    return List<Employe>.from(json.map((x) => Employe.fromJson(x)));
  }

  static Employe parsePost(String response) {
    dynamic json = jsonDecode(response);
    return Employe.fromJson(json);
  }

  static Employe parsePostRes(String response) {
    dynamic json = jsonDecode(response);
    return Employe.fromJson(json);
  }


}
