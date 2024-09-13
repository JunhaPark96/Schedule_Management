import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:oneline2/admin_list/feature/page4_CDC_table/model/cdc_model.dart';
import 'package:oneline2/admin_list/feature/page4_CDC_table/repos/cdc_repos.dart';
import 'package:oneline2/admin_list/feature/page4_CDC_table/view_models/cdc_event.dart';
import 'package:oneline2/admin_list/feature/page4_CDC_table/view_models/cdc_state.dart';
import '../lib/pluto_grid.dart';

class CdcBloc extends Bloc<CdcEvent, CdcState> {
  CdcBloc()
      : super(
          CdcState(
            list: [],
            prow: [],
          ),
        ) {
    on<FetchCdc>(_onFetchCdc);
    on<RemoveCdc>(_onRemoveCdc);
    on<AddCdc>(_onAddCdc);
    on<ModifyCdc>(_onModifyCdc);

    // on<FilterCdc>(_onFilterCdc); //event name
  }

  List<PlutoRow> convertModelToRows(List<CdcModel> cdc) {
    return cdc.map((cdc) {
      return PlutoRow(
        cells: {
          'INDEX': PlutoCell(value: cdc.index),
          'ID': PlutoCell(value: cdc.id),
          'owner': PlutoCell(value: cdc.owner),
          'table_name': PlutoCell(value: cdc.table_name),
          'ac_grnt_yn': PlutoCell(value: cdc.ac_grnt_yn),
          'im_grnt_yn': PlutoCell(value: cdc.im_grnt_yn),
          'ca_grnt_yn': PlutoCell(value: cdc.ca_grnt_yn),
          'wm_grnt_yn': PlutoCell(value: cdc.wm_grnt_yn),
          'dw_grnt_yn': PlutoCell(value: cdc.dw_grnt_yn),
          'rd_grnt_yn': PlutoCell(value: cdc.rd_grnt_yn),
          'pe_grnt_yn': PlutoCell(value: cdc.pe_grnt_yn),
          'bp_grnt_yn': PlutoCell(value: cdc.bp_grnt_yn),
          'ecube_grnt_yn': PlutoCell(value: cdc.ecube_grnt_yn),
          'ecubeebm_grnt_yn': PlutoCell(value: cdc.ecubeebm_grnt_yn),
          'al_grnt_yn': PlutoCell(value: cdc.al_grnt_yn),
          'pm_grnt_yn': PlutoCell(value: cdc.pm_grnt_yn),
          'cs_grnt_yn': PlutoCell(value: cdc.cs_grnt_yn),
          'bk_grnt_yn': PlutoCell(value: cdc.bk_grnt_yn),
          'am_grnt_yn': PlutoCell(value: cdc.am_grnt_yn),
          'rp_grnt_yn': PlutoCell(value: cdc.rp_grnt_yn),
          'um_grnt_yn': PlutoCell(value: cdc.um_grnt_yn),
          'ib_grnt_yn': PlutoCell(value: cdc.ib_grnt_yn),
          'ix_grnt_yn': PlutoCell(value: cdc.ix_grnt_yn),
          'ps_grnt_yn': PlutoCell(value: cdc.ps_grnt_yn),
          'log_tbl_crt_yn': PlutoCell(value: cdc.log_tbl_crt_yn),
          'log_tbl_biz_ownr': PlutoCell(value: cdc.log_tbl_biz_ownr),
          'tbl_layout_copy_yn': PlutoCell(value: cdc.tbl_layout_copy_yn),
          'chrg_job': PlutoCell(value: cdc.chrg_job),
          'load_dvsn': PlutoCell(value: cdc.load_dvsn),
          'rgst_dt': PlutoCell(value: cdc.rgst_dt),
          'data_cstd_stdr_dt': PlutoCell(value: cdc.data_cstd_stdr_dt),
          'partition_yn': PlutoCell(value: cdc.partition_yn),
          'trns_step': PlutoCell(value: cdc.trns_step),
          'status': PlutoCell(value: 'saved'),
        },
      );
    }).toList();
  }

  void _onFetchCdc(FetchCdc event, Emitter<CdcState> emit) async {
    try {
      List<CdcModel> list = await ApiService().fetchData();
      List<PlutoRow> rowlist = convertModelToRows(list);

      emit(state.copyWith(list: list, prow: rowlist));
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _onRemoveCdc(RemoveCdc event, Emitter<CdcState> emit) async {
    try {
      await ApiService().deleteData(event.removeevent); //백엔드 데이터 삭제 수행
      final removeCdcs = state.list.where((instance) {
        return instance.id != event.removeevent.id;
      }).toList();
      List<PlutoRow> rowlist = convertModelToRows(removeCdcs);

      emit(state.copyWith(
        prow: rowlist,
      ));
    } catch (e) {
      // debugPrint('Error : $e');
      // emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onModifyCdc(ModifyCdc event, Emitter<CdcState> emit) async {
    try {
      await ApiService().updateData(event.modifyevent);

      // List<CdcModel> updateList = state.prow.map((element) {
      //   return (element.id == event.modifyevent.id)
      //       ? event.modifyevent
      //       : element;
      // }).toList();

      emit(state.copyWith(
          // prow: updateList,
          ));
      // print(event.modifyevent.isCompleted);
    } catch (e) {
      // debugPrint('Error : $e');
      // emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onAddCdc(AddCdc event, Emitter<CdcState> emit) async {
    try {
      final added = await ApiService().insertData(event.addevent);
      final updateList = List<CdcModel>.from(state.prow)..add(added);
      List<PlutoRow> rowlist = convertModelToRows(updateList);

      emit(state.copyWith(prow: rowlist));
    } catch (e) {
      // debugPrint('Error : $e');
      // emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
