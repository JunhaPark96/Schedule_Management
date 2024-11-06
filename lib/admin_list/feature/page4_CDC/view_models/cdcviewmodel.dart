import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import '../repos/cdcrepos.dart';
import '../models/cdcmodel.dart';

class CdcViewModel extends ChangeNotifier {
  List<DataModel> _data = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<DataModel> get data => _data;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final ApiService _apiService;
  CdcViewModel(this._apiService);

  Future<void> fetchData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _data = await _apiService.fetchData();
    } catch (e) {
      _errorMessage = "Failed to load data : $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
