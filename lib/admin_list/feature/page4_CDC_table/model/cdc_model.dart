class CdcModel {
  final int id;
  final int index;
  final String owner;
  final String table_name;
  final String ac_grnt_yn;
  final String im_grnt_yn;
  final String ca_grnt_yn;
  final String wm_grnt_yn;
  final String dw_grnt_yn;
  final String rd_grnt_yn;
  final String pe_grnt_yn;
  final String bp_grnt_yn;
  final String ecube_grnt_yn;
  final String ecubeebm_grnt_yn;
  final String al_grnt_yn;
  final String pm_grnt_yn;
  final String cs_grnt_yn;
  final String bk_grnt_yn;
  final String am_grnt_yn;
  final String rp_grnt_yn;
  final String um_grnt_yn;
  final String ib_grnt_yn;
  final String ix_grnt_yn;
  final String ps_grnt_yn;
  final String log_tbl_crt_yn;
  final String log_tbl_biz_ownr;
  final String tbl_layout_copy_yn;
  final String chrg_job;
  final String load_dvsn;
  final String rgst_dt;
  final String data_cstd_stdr_dt;
  final String partition_yn;
  final String trns_step;

  CdcModel({
    required this.id,
    required this.index,
    required this.owner,
    required this.table_name,
    required this.ac_grnt_yn,
    required this.im_grnt_yn,
    required this.ca_grnt_yn,
    required this.wm_grnt_yn,
    required this.dw_grnt_yn,
    required this.rd_grnt_yn,
    required this.pe_grnt_yn,
    required this.bp_grnt_yn,
    required this.ecube_grnt_yn,
    required this.ecubeebm_grnt_yn,
    required this.al_grnt_yn,
    required this.pm_grnt_yn,
    required this.cs_grnt_yn,
    required this.bk_grnt_yn,
    required this.am_grnt_yn,
    required this.rp_grnt_yn,
    required this.um_grnt_yn,
    required this.ib_grnt_yn,
    required this.ix_grnt_yn,
    required this.ps_grnt_yn,
    required this.log_tbl_crt_yn,
    required this.log_tbl_biz_ownr,
    required this.tbl_layout_copy_yn,
    required this.chrg_job,
    required this.load_dvsn,
    required this.rgst_dt,
    required this.data_cstd_stdr_dt,
    required this.partition_yn,
    required this.trns_step,
  });

  factory CdcModel.fromJson(Map<String, dynamic> json) {
    return CdcModel(
        id: json["id"],
        index: json["index"],
        owner: json['owner'] ?? '',
        table_name: json['table_name'] ?? '',
        ac_grnt_yn: json['ac_grnt_yn'] ?? '',
        im_grnt_yn: json['im_grnt_yn'] ?? '',
        ca_grnt_yn: json['ca_grnt_yn'] ?? '',
        wm_grnt_yn: json['wm_grnt_yn'] ?? '',
        dw_grnt_yn: json['dw_grnt_yn'] ?? '',
        rd_grnt_yn: json['rd_grnt_yn'] ?? '',
        pe_grnt_yn: json['pe_grnt_yn'] ?? '',
        bp_grnt_yn: json['bp_grnt_yn'] ?? '',
        ecube_grnt_yn: json['ecube_grnt_yn'] ?? '',
        ecubeebm_grnt_yn: json['ecubeebm_grnt_yn'] ?? '',
        al_grnt_yn: json['al_grnt_yn'] ?? '',
        pm_grnt_yn: json['pm_grnt_yn'] ?? '',
        cs_grnt_yn: json['cs_grnt_yn'] ?? '',
        bk_grnt_yn: json['bk_grnt_yn'] ?? '',
        am_grnt_yn: json['am_grnt_yn'] ?? '',
        rp_grnt_yn: json['rp_grnt_yn'] ?? '',
        um_grnt_yn: json['um_grnt_yn'] ?? '',
        ib_grnt_yn: json['ib_grnt_yn'] ?? '',
        ix_grnt_yn: json['ix_grnt_yn'] ?? '',
        ps_grnt_yn: json['ps_grnt_yn'] ?? '',
        log_tbl_crt_yn: json['log_tbl_crt_yn'] ?? '',
        log_tbl_biz_ownr: json['log_tbl_biz_ownr'] ?? '',
        tbl_layout_copy_yn: json['tbl_layout_copy_yn'] ?? '',
        chrg_job: json['chrg_job'] ?? '',
        load_dvsn: json['load_dvsn'] ?? '',
        rgst_dt: json['rgst_dt'] ?? '',
        data_cstd_stdr_dt: json['data_cstd_stdr_dt'] ?? '',
        partition_yn: json['partition_yn'] ?? '',
        trns_step: json['trns_step'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "index": index,
      "owner": owner,
      "table_name": table_name,
      "ac_grnt_yn": ac_grnt_yn,
      "im_grnt_yn": im_grnt_yn,
      "ca_grnt_yn": ca_grnt_yn,
      "wm_grnt_yn": wm_grnt_yn,
      "dw_grnt_yn": dw_grnt_yn,
      "rd_grnt_yn": rd_grnt_yn,
      "pe_grnt_yn": pe_grnt_yn,
      "bp_grnt_yn": bp_grnt_yn,
      "ecube_grnt_yn": ecube_grnt_yn,
      "ecubeebm_grnt_yn": ecubeebm_grnt_yn,
      "al_grnt_yn": al_grnt_yn,
      "pm_grnt_yn": pm_grnt_yn,
      "cs_grnt_yn": cs_grnt_yn,
      "bk_grnt_yn": bk_grnt_yn,
      "am_grnt_yn": am_grnt_yn,
      "rp_grnt_yn": rp_grnt_yn,
      "um_grnt_yn": um_grnt_yn,
      "ib_grnt_yn": ib_grnt_yn,
      "ix_grnt_yn": ix_grnt_yn,
      "ps_grnt_yn": ps_grnt_yn,
      "log_tbl_crt_yn": log_tbl_crt_yn,
      "log_tbl_biz_ownr": log_tbl_biz_ownr,
      "tbl_layout_copy_yn": tbl_layout_copy_yn,
      "chrg_job": chrg_job,
      "load_dvsn": load_dvsn,
      "rgst_dt": rgst_dt,
      "data_cstd_stdr_dt": data_cstd_stdr_dt,
      "partition_yn": partition_yn,
      "trns_step": trns_step,
    };
  }
}
