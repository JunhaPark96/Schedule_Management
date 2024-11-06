import 'package:oneline2/admin_list/feature/page6_Pluto_Table/model/license_model.dart';

abstract class LicenseEvent {}

class FetchLicense extends LicenseEvent {}

class AddLicense extends LicenseEvent {
  final LicenseModel addevent;
  AddLicense(this.addevent);
}

class RemoveLicense extends LicenseEvent {
  final LicenseModel removeevent;
  RemoveLicense(this.removeevent);
}

class ModifyLicense extends LicenseEvent {
  final LicenseModel modifyevent;
  ModifyLicense(this.modifyevent);
}

 


// class FilterLicense extends LicenseEvent {
//   final String query;

//   FilterLicense(this.query);
// }