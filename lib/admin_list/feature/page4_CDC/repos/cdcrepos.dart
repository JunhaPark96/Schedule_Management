import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/cdcmodel.dart';

class ApiService {
  final Uri url;
  ApiService(this.url);
  // final url = Uri.parse("http://172.26.202.100:8090/get_cdc_call");

  Future<List<DataModel>> fetchData() async {
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => DataModel.fromJson(item)).toList();
      } else {
        throw Exception("Failed to load data:  ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load data: $e ");
    }
  }
}
