class DataModel {
  final String owner;
  final String table_name;
  final String ac_grnt_yn;
  final String im_grnt_yn;
  final String ca_grnt_yn;
  final String wm_grnt_yn;
  final String dw_grnt_yn;
  final String rgst_dt;
  final String partition_yn;
  final String trns_step;

  DataModel(
      {required this.owner,
      required this.table_name,
      required this.ac_grnt_yn,
      required this.im_grnt_yn,
      required this.ca_grnt_yn,
      required this.wm_grnt_yn,
      required this.dw_grnt_yn,
      required this.rgst_dt,
      required this.partition_yn,
      required this.trns_step});

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      owner: json['OWNER'] ?? '',
      table_name: json['TABLE_NAME'] ?? '',
      ac_grnt_yn: json['AC_GRNT_YN'] ?? '',
      im_grnt_yn: json['IM_GRNT_YN'] ?? '',
      ca_grnt_yn: json['CA_GRNT_YN'] ?? '',
      wm_grnt_yn: json['WM_GRNT_YN'] ?? '',
      dw_grnt_yn: json['DW_GRNT_YN'] ?? '',
      rgst_dt: json['RGST_DT'] ?? '',
      partition_yn: json['PARTITION_YN'] ?? '',
      trns_step: json['TRNS_STEP'] ?? '',
    );
  }
}
