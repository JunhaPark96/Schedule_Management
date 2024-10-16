import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:oneline2/admin_list/feature/page7_EOS/models/eos_model.dart';

class ApiService {
  Future<List<EOSModel>> fetchData() async {
    final url = Uri.parse("http://172.26.202.100:8090/get_eos_fetch");
    final response = await http.get(url);

    try {
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => EOSModel.fromJson(item)).toList();
      } else {
        throw Exception("Failed to load data:  ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load data: $e ");
    }
  }

  Future<void> deleteData(EOSModel deleted) async {
    final deleteUrl = Uri.parse('http://172.26.202.100:8090/get_eos_delete');
    // print(deleteUrl);
    final response = await http.post(
      deleteUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(deleted.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception("failed to deleteData Data: ${response.statusCode}");
    }
  }

  Future<EOSModel> insertData(EOSModel insert) async {
    final insertUrl = Uri.parse('http://172.26.202.100:8090/get_eos_insert');
    // print(insertUrl);
    final response = await http.post(
      insertUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(insert.toJson()),
    );
    if (response.statusCode == 200) {
      // print("insert code: 200  ${response.body}");
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      // print(responseData);
      return EOSModel.fromJson(responseData);
    } else {
      throw Exception(
          "failed to insertData : ${response.statusCode} ${response.body}");
    }
  }

  Future<EOSModel> updateData(EOSModel update) async {
    final updateUrl = Uri.parse('http://172.26.202.100:8090/get_eos_update');
    // print(updateUrl);
    final response = await http.post(
      updateUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(update.toJson()),
    );
    if (response.statusCode == 200) {
      // print("update code: 200  ${response.body}");
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      // print(responseData);
      return EOSModel.fromJson(responseData);
    } else {
      throw Exception(
          "failed to update Data: ${response.statusCode} ${response.body}");
    }
  }
}