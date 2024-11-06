import '../models/backlogmodel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static Future<List<BacklogModel>> getTodaysBacklog() async {
    List<BacklogModel> backlogInstances = [];

    final url = Uri.parse("http://172.26.202.100:8090/get_imsplex_call");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // print("aa" + response.body);

      final List<dynamic> backLogLists = jsonDecode(response.body);

      for (var backLogList in backLogLists) {
        final backlogInstance = BacklogModel.fromjson(backLogList);
        backlogInstances.add(backlogInstance);
      }

      return Future.delayed(Duration(milliseconds: 500), () {
        return backlogInstances;
      });
    }
    throw Error();
  }
}
