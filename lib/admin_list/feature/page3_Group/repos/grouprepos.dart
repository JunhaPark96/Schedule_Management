import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/groupmodel.dart';

class ApiService {
  final Uri url;
  ApiService(this.url);

  Future<List<L3GroupModel>> fetchData() async {
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => L3GroupModel.fromJson(item)).toList();
      } else {
        throw Exception("Failed to load data:  ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load data: $e ");
    }
  }

  Future<void> insertData() async {
    final updateUrl = Uri.parse('${url.toString()}/insert');
    print(updateUrl);
    final response = await http.post(
      updateUrl,
      headers: {
        'Content-Type': 'application/json',
        'Aceept': 'application/json',
      },
      body: jsonEncode(
        {
          'l3': "NewL3",
          'admin_user': 'New adminUser',
          'admin_leader': 'New adminLeader',
          'description': 'New description',
        },
      ),
    );
    if (response.statusCode != 200) {
      throw Exception("failed to update Data: ${response.statusCode}");
    }
  }

  Future<void> updateData(L3GroupModel updatedGroup) async {
    final updateUrl = Uri.parse('${url.toString()}/update');
    print(updateUrl);
    final response = await http.post(
      updateUrl,
      headers: {
        'Content-Type': 'application/json',
        'Aceept': 'application/json',
      },
      body: jsonEncode(
        {
          'group_seq': updatedGroup.group_seq,
          'l3': updatedGroup.L3,
          'admin_user': updatedGroup.adminUser,
          'admin_leader': updatedGroup.adminLeader,
          'description': updatedGroup.description,
        },
      ),
    );
    if (response.statusCode != 200) {
      throw Exception("failed to update Data: ${response.statusCode}");
    }
  }

  Future<void> deleteData(L3GroupModel deletedGroup) async {
    final deleteUrl = Uri.parse('${url.toString()}/delete');
    print(deleteUrl);
    final response = await http.post(
      deleteUrl,
      headers: {
        'Content-Type': 'application/json',
        'Aceept': 'application/json',
      },
      body: jsonEncode(
        {
          'group_seq': deletedGroup.group_seq,
        },
      ),
    );
    if (response.statusCode != 200) {
      throw Exception("failed to update Data: ${response.statusCode}");
    }
  }
}
