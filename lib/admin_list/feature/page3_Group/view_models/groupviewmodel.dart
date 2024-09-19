import 'package:get/get.dart';
import '../models/groupmodel.dart';
import '../repos/grouprepos.dart';

class GroupViewModelController extends GetxController {
  final ApiService _apiService;
  var groups = <L3GroupModel>[].obs;
  var filteredGroups = <L3GroupModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  GroupViewModelController(this._apiService);

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final data = await _apiService.fetchData();
      groups.assignAll(data); //groups.value = data;
      filteredGroups.assignAll(data);
    } catch (e) {
      "Failed to load data :${errorMessage.value}";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> InsertData() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _apiService.insertData();
      final data = await _apiService.fetchData();
      groups.assignAll(data);
      filteredGroups.assignAll(data);
    } catch (e) {
      "Failed to load data :${errorMessage.value}";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> DeleteData(L3GroupModel updatedGroup) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _apiService.deleteData(updatedGroup);
      groups.value = [
        for (final group in groups)
          if (group.group_seq == updatedGroup.group_seq) updatedGroup else group
      ];
      final data = await _apiService.fetchData();
      groups.assignAll(data);
      filteredGroups.assignAll(data);
    } catch (e) {
      "Failed to load data :${errorMessage.value}";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateData(L3GroupModel updatedGroup) async {
    try {
      await _apiService.updateData(updatedGroup);
      groups.value = [
        for (final group in groups)
          if (group.group_seq == updatedGroup.group_seq) updatedGroup else group
      ];
      final data = await _apiService.fetchData();
      // groups.assignAll(data);
      filteredGroups.assignAll(data);
    } catch (e) {
      errorMessage.value = '$e';
    }
  }

  Future<void> filterGroups(String query) async {
    if (query.isEmpty) {
      filteredGroups.assignAll(groups);
    } else {
      filteredGroups.assignAll(
        groups.where((group) =>
            // group.L3!.toLowerCase().contains(query.toLowerCase()))
            _matchesQuery(group, query)).toList(),
      );
    }
  }

  bool _matchesQuery(L3GroupModel group, String query) {
    String normalizedQuery = _normalize(query);
    return _normalize(group.L3!).contains(normalizedQuery) ||
        _normalize(group.adminLeader!).contains(normalizedQuery) ||
        _normalize(group.adminUser!).contains(normalizedQuery) ||
        _normalize(group.description!).contains(normalizedQuery);
  }

  String _normalize(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'[\s+]', multiLine: true), '');
  }
}
