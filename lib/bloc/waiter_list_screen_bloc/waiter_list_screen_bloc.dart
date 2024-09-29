import 'dart:async';
import 'dart:math';

import 'package:coozy_the_cafe/AppLocalization.dart';
import 'package:coozy_the_cafe/database/database.dart';
import 'package:coozy_the_cafe/model/table_info_model.dart';
import 'package:coozy_the_cafe/pages/main_screen/table_screen/table_update_dialog.dart';
import 'package:coozy_the_cafe/repositories/repositories.dart';
import 'package:coozy_the_cafe/utlis/utlis.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:rxdart/rxdart.dart';

part 'waiter_list_screen_event.dart';
part 'waiter_list_screen_state.dart';

class WaiterListScreenBloc
    extends Bloc<WaiterListScreenEvent, WaiterListScreenState> {
  WaiterListScreenBloc() : super(WaiterListScreenInitialState()) {
    on<InitialLoadWaiterListScreenEvent>(_handleInitialLoadingData);
    on<SwitchViewWaiterListScreenEvent>(_handleSwitchViewData);
    on<UpdateTableWaiterListScreenEvent>(_handlUpdateTableInfoData);
    on<DeleteTableWaiterListScreenEvent>(_handleDeleteTableData);
    on<onReOrderTableInfoWaiterListScreenEvent>(_handleOnReOrderTableData);
    on<onMoveItemUpTableInfoWaiterListScreenEvent>(
        _handleOnMoveItemUpTableData);
    on<onMoveItemDownTableInfoWaiterListScreenEvent>(
        _handleOnMoveItemDownTableData);
    on<AddNewTableWaiterListScreenEvent>(_handleOnAddNewTableWaiterListData);
  }

  final BehaviorSubject<WaiterListScreenState> _stateSubject =
      BehaviorSubject();

  Stream<WaiterListScreenState> get stateStream => _stateSubject.stream;

  void emitState(WaiterListScreenState state) => _stateSubject.sink.add(state);

  List<TableInfoModel>? tableList = [];

  List<TableInfoModel>? _placeHolderData() {
    return List.generate(
        25,
        (index) => TableInfoModel(
            name: "", id: index, nosOfChairs: 04, sortOrderIndex: index));
  }

  bool? isGridView = false;
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<void> close() {
    _stateSubject.close();
    return super.close();
  }

  FutureOr<void> _handleInitialLoadingData(
      InitialLoadWaiterListScreenEvent event,
      Emitter<WaiterListScreenState> emit) async {
    tableList = [];
    isGridView = false;
    emit(WaiterListScreenLoadingState());

    tableList = await RestaurantRepository().getTableInfoList();
    isGridView = false;
    await Future.delayed(const Duration(seconds: 2));
    emit(WaiterListScreenLoadedState(
        isGridView: isGridView, tableList: tableList));
  }

  FutureOr<void> _handleSwitchViewData(SwitchViewWaiterListScreenEvent event,
      Emitter<WaiterListScreenState> emit) async {
    tableList = [];
    tableList = await RestaurantRepository().getTableInfoList();
    isGridView = !(isGridView ?? false);
    Constants.debugLog(
        WaiterListScreenBloc, "_handleSwitchViewData:isGridView:$isGridView");
    emit(WaiterListScreenLoadedState(
        isGridView: isGridView, tableList: tableList));
  }

  FutureOr<void> _handlUpdateTableInfoData(
      UpdateTableWaiterListScreenEvent event,
      Emitter<WaiterListScreenState> emit) async {
    Constants.debugLog(WaiterListScreenBloc,
        "updateTableInfo:model:${event.updatedTableInfo.toString()}");
    await showDialog(
      context: event.context,
      builder: (context) {
        return TableUpdateDialog(
          currentTableName: event.updatedTableInfo,
          onUpdate: (tableInfoModel) async {
            try {
              Constants.debugLog(
                  WaiterListScreenBloc, 'Updated table name: $tableInfoModel');
              await RestaurantRepository().updateTableInfo(tableInfoModel);
              tableList = await RestaurantRepository().getTableInfoList();
              emit(WaiterListScreenLoadedState(
                  isGridView: isGridView, tableList: tableList));
              navigationRoutes.goBack();
              Constants.showToastMsg(
                  msg: AppLocalizations.of(context)!.translate(
                          StringValue.table_toast_updated_successfully) ??
                      "The table's information has been alter successfully.");
            } catch (e) {
              Constants.debugLog(WaiterListScreenBloc,
                  'Updated table error:_handlUpdateTableInfoData: $e');
              navigationRoutes.goBack();
              Constants.showToastMsg(
                  msg: AppLocalizations.of(context)!
                          .translate(StringValue.common_error_msg) ??
                      "Something when wrong. Please try again.");
            }
          },
        );
      },
    );
  }

  FutureOr<void> _handleDeleteTableData(DeleteTableWaiterListScreenEvent event,
      Emitter<WaiterListScreenState> emit) async {
    Constants.debugLog(WaiterListScreenBloc,
        'Delete table with ID: ${event.tableInfoModel.id}');
    int? result = await RestaurantRepository()
        .deleteTableInfo(tableInfoModelToDelete: event.tableInfoModel);
    Constants.debugLog(
        WaiterListScreenBloc, "Delete RestaurantRepository result:$result");
    if (result != null && result > 0) {
      if (tableList != null) {
        tableList = await RestaurantRepository().getTableInfoList();
        emit(WaiterListScreenLoadedState(
            isGridView: isGridView, tableList: tableList));

        Constants.customAutoDismissAlertDialog(
            classObject: WaiterListScreenBloc,
            context: event.context,
            descriptions: AppLocalizations.of(event.context)
                    ?.translate(StringValue.table_deleted_successfully_text) ??
                "Select table has been deleted successfully.",
            title: "",
            titleIcon: Lottie.asset(
              MediaQuery.of(event.context).platformBrightness ==
                      Brightness.light
                  ? StringImagePath.done_light_brown_color_lottie
                  : StringImagePath.done_brown_color_lottie,
              repeat: false,
            ),
            navigatorKey: navigatorKey);
      }
    } else {
      tableList = await RestaurantRepository().getTableInfoList();
      emit(WaiterListScreenLoadedState(
          isGridView: isGridView, tableList: tableList));
      Constants.customAutoDismissAlertDialog(
          classObject: WaiterListScreenBloc,
          context: event.context,
          descriptions: AppLocalizations.of(event.context)
                  ?.translate(StringValue.table_failed_to_deleted_text) ??
              "Failed to delete you select table.",
          title: null,
          titleIcon: Lottie.asset(
            MediaQuery.of(event.context).platformBrightness == Brightness.light
                ? StringImagePath.done_light_brown_color_lottie
                : StringImagePath.done_brown_color_lottie,
            repeat: false,
          ),
          navigatorKey: navigatorKey);
    }
  }

  FutureOr<void> _handleOnReOrderTableData(
      onReOrderTableInfoWaiterListScreenEvent event,
      Emitter<WaiterListScreenState> emit) async {
    int? newIndex = event.newIndex;
    int? oldIndex = event.oldIndex;
    Constants.debugLog(WaiterListScreenBloc,
        "_handleOnReOrderTableData:reorder: ${event.oldIndex} -> ${event.newIndex}");

    TableInfoModel?
        movingItem; // Declare movingItem outside the try-catch block

    var db = await _databaseHelper.database;

    if (event.newIndex > event.oldIndex) {
      // Adjust the index if the item is moved down in the list
      newIndex = event.newIndex - 1; // Update the value of newIndex
    }

    movingItem =
        tableList!.removeAt(event.oldIndex); // Assign the value of movingItem
    tableList!.insert(event.newIndex, movingItem);

    try {
      await db!.transaction((txn) async {
        // Update sortOrderIndex for affected items
        for (int i = min(oldIndex, newIndex!);
            i <= max(oldIndex, newIndex);
            i++) {
          final TableInfoModel currentItem = tableList![i];
          currentItem.sortOrderIndex = i;
          await txn.update(
            _databaseHelper.tableInfoTable,
            currentItem.toJson(),
            where: 'id = ?',
            whereArgs: [currentItem.id],
          );
        }
      });
      emit(WaiterListScreenLoadedState(
          isGridView: isGridView, tableList: tableList));
    } catch (error) {
      Constants.debugLog(WaiterListScreenBloc,
          "_handleOnReOrderTableData:Error occurred: $error");

      // Revert back to the original state
      if (movingItem != null) {
        tableList!.insert(event.oldIndex, movingItem);
        tableList!.removeAt(event.newIndex);
      }
      emit(WaiterListScreenLoadedState(
          isGridView: isGridView, tableList: tableList));
    }
  }

  FutureOr<void> _handleOnMoveItemUpTableData(
      onMoveItemUpTableInfoWaiterListScreenEvent event,
      Emitter<WaiterListScreenState> emit) async {
    int currentIndex = event.currentIndex;
    if (currentIndex > 0) {
      Constants.debugLog(
          WaiterListScreenBloc, "move item up from $currentIndex index");
      var db = await _databaseHelper.database;

      final TableInfoModel movingItem = tableList!.removeAt(currentIndex);
      tableList!.insert(currentIndex - 1, movingItem);
      emit(WaiterListScreenLoadedState(
          isGridView: isGridView, tableList: tableList));
      try {
        await db!.transaction((txn) async {
          for (int i = currentIndex - 1; i <= currentIndex; i++) {
            final TableInfoModel currentItem = tableList![i];
            currentItem.sortOrderIndex = i;

            await txn.update(
              _databaseHelper.tableInfoTable,
              currentItem.toJson(),
              where: 'id = ?',
              whereArgs: [currentItem.id],
            );
          }
        });
      } catch (error) {
        Constants.debugLog(WaiterListScreenBloc,
            "_handleOnMoveItemUpTableData:Error occurred: $error");
        tableList!.insert(currentIndex, movingItem);
        tableList!.removeAt(currentIndex - 1);
        Constants.showToastMsg(
            msg: "_handleOnMoveItemUpTableData:Failed to update position");
        emit(WaiterListScreenLoadedState(
            isGridView: isGridView, tableList: tableList));
      }
    }
  }

  FutureOr<void> _handleOnMoveItemDownTableData(
      onMoveItemDownTableInfoWaiterListScreenEvent event,
      Emitter<WaiterListScreenState> emit) async {
    int currentIndex = event.currentIndex;
    if (currentIndex < (tableList!.length - 1)) {
      Constants.debugLog(
          WaiterListScreenBloc, "move item down from $currentIndex index");
      var db = await _databaseHelper.database;

      final TableInfoModel movingItem = tableList!.removeAt(currentIndex);
      tableList!.insert(currentIndex + 1, movingItem);
      emit(WaiterListScreenLoadedState(
          isGridView: isGridView, tableList: tableList));
      try {
        await db!.transaction((txn) async {
          for (int i = currentIndex; i <= currentIndex + 1; i++) {
            final TableInfoModel currentItem = tableList![i];
            currentItem.sortOrderIndex = i;

            await txn.update(
              _databaseHelper.tableInfoTable,
              currentItem.toJson(),
              where: 'id = ?',
              whereArgs: [currentItem.id],
            );
          }
        });
      } catch (error) {
        Constants.debugLog(WaiterListScreenBloc,
            "_handleOnMoveItemDownTableData:Error occurred: $error");
        tableList!.insert(currentIndex, movingItem);
        tableList!.removeAt(currentIndex + 1);
        Constants.showToastMsg(
            msg: "_handleOnMoveItemDownTableData:Failed to update position");
        emit(WaiterListScreenLoadedState(
            isGridView: isGridView, tableList: tableList));
      }
    }
  }

  FutureOr<void> _handleOnAddNewTableWaiterListData(
      AddNewTableWaiterListScreenEvent event,
      Emitter<WaiterListScreenState> emit) async {
    tableList = await RestaurantRepository().getTableInfoList();
    emit(WaiterListScreenLoadedState(isGridView: isGridView, tableList: tableList));
  }
}
