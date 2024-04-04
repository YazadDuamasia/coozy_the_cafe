import 'dart:async';
import 'dart:math';

import 'package:coozy_cafe/AppLocalization.dart';
import 'package:coozy_cafe/database_helper/DatabaseHelper.dart';
import 'package:coozy_cafe/model/table_info_model.dart';
import 'package:coozy_cafe/pages/main_screen/table_screen/table_update_dialog.dart';
import 'package:coozy_cafe/repositories/components/restaurant_repository.dart';
import 'package:coozy_cafe/utlis/components/constants.dart';
import 'package:coozy_cafe/utlis/components/global.dart';
import 'package:coozy_cafe/utlis/components/string_image_path.dart';
import 'package:coozy_cafe/utlis/components/string_value.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:rxdart/rxdart.dart';

part 'table_screen_event.dart';

part 'table_screen_state.dart';

class TableScreenBloc extends Bloc<TableScreenEvent, TableScreenState> {
  TableScreenBloc() : super(TableScreenInitial()) {
    on<LoadTableScreenDataEvent>(_handleInitialLoadingData);
    on<SwitchViewTableInfoEvent>(_handleSwitchViewTableInfo);
    on<AddNewTableInfoEvent>(_handleAddNewTableInfo);
    on<UpdateTableInfoEvent>(_handlUpdateTableInfo);
    on<DeleteTableInfoEvent>(_handleDeleteTableInfo);
    on<onReOrderTableInfoEvent>(_handleOnReOrderTableInfo);
    on<onMoveItemUpTableInfoEvent>(_handleOnMoveItemUpTableInfo);
    on<onMoveItemDownTableInfoEvent>(_handleOnMoveItemDownTableInfo);
  }

  final BehaviorSubject<TableScreenState> _stateSubject = BehaviorSubject();

  Stream<TableScreenState> get stateStream => _stateSubject.stream;

  void emitState(TableScreenState state) => _stateSubject.sink.add(state);

  List<TableInfoModel>? tableList = [];

  List<TableInfoModel>? _placeHolderData() {
    return List.generate(
        25,
        (index) => TableInfoModel(
            name: "", id: index, nosOfChairs: 4, sortOrderIndex: index));
  }

  bool? isGridView = false;
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<void> close() {
    _stateSubject.close();
    return super.close();
  }

  FutureOr<void> _handleInitialLoadingData(
      LoadTableScreenDataEvent event, Emitter<TableScreenState> emit) async {
    tableList = [];
    isGridView = false;
    emit(TableScreenLoadingState());

    tableList = await RestaurantRepository().getTableInfoList();
    isGridView = false;
    await Future.delayed(Duration(seconds: 2));
    emit(TableScreenLoadedState(isGridView: isGridView, list: tableList));
  }

  Future<void> _handleSwitchViewTableInfo(
      SwitchViewTableInfoEvent event, Emitter<TableScreenState> emit) async {
    tableList = [];
    tableList = await RestaurantRepository().getTableInfoList();
    isGridView = !(isGridView ?? false);
    emit(TableScreenLoadedState(isGridView: isGridView, list: tableList));
  }

  Future<void> _handlUpdateTableInfo(
      UpdateTableInfoEvent event, Emitter<TableScreenState> emit) async {
    Constants.debugLog(TableScreenBloc,
        "updateTableInfo:model:${event.updatedTableInfo.toString()}");
    await showDialog(
      context: event.context,
      builder: (context) {
        return TableUpdateDialog(
          currentTableName: event.updatedTableInfo,
          // Pass the current table name
          onUpdate: (tableInfoModel) async {
            // Updated table name
            try {
              Constants.debugLog(
                  TableScreenBloc, 'Updated table name: $tableInfoModel');
              await RestaurantRepository().updateTableInfo(tableInfoModel);
              tableList = await RestaurantRepository().getTableInfoList();
              emit(TableScreenLoadedState(
                  isGridView: isGridView, list: tableList));
              navigationRoutes.goBack();
              Constants.showToastMsg(
                  msg: AppLocalizations.of(context)!
                      .translate(StringValue.table_toast_updated_successfully) ??
                      "The table's information has been alter successfully.");
            } catch (e) {
              print(e);
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

  Future<void> _handleDeleteTableInfo(
      DeleteTableInfoEvent event, Emitter<TableScreenState> emit) async {
    Constants.debugLog(
        TableScreenBloc, 'Delete table with ID: ${event.tableInfoModel.id}');
    int? result = await RestaurantRepository()
        .deleteTableInfo(tableInfoModelToDelete: event.tableInfoModel);
    Constants.debugLog(
        TableScreenBloc, "Delete RestaurantRepository result:$result");
    if (result != null && result > 0) {
      if (tableList != null) {
        tableList = await RestaurantRepository().getTableInfoList();
        emit(TableScreenLoadedState(isGridView: isGridView, list: tableList));

        Constants.customAutoDismissAlertDialog(
            classObject: TableScreenBloc,
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
      emit(TableScreenLoadedState(isGridView: isGridView, list: tableList));
      Constants.customAutoDismissAlertDialog(
          classObject: TableScreenBloc,
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

  Future<void> _handleOnReOrderTableInfo(
      onReOrderTableInfoEvent event, Emitter<TableScreenState> emit) async {
    int newIndex = event.newIndex;
    int oldIndex = event.oldIndex;
    Constants.debugLog(
        TableScreenBloc, "reorder: ${event.oldIndex} -> ${event.newIndex}");

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
        for (int i = min(oldIndex, newIndex);
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
      emit(TableScreenLoadedState(isGridView: isGridView, list: tableList));
    } catch (error) {
      Constants.debugLog(
          TableScreenBloc, "_handleOnReOrderTableInfo:Error occurred: $error");

      // Revert back to the original state
      if (movingItem != null) {
        tableList!.insert(event.oldIndex, movingItem);
        tableList!.removeAt(event.newIndex);
      }
      emit(TableScreenLoadedState(isGridView: isGridView, list: tableList));
    }
  }

  Future<void> _handleOnMoveItemUpTableInfo(
      onMoveItemUpTableInfoEvent event, Emitter<TableScreenState> emit) async {
    int currentIndex = event.currentIndex;
    if (currentIndex > 0) {
      Constants.debugLog(
          TableScreenBloc, "move item up from $currentIndex index");
      var db = await _databaseHelper.database;

      final TableInfoModel movingItem = tableList!.removeAt(currentIndex);
      tableList!.insert(currentIndex - 1, movingItem);
      emit(TableScreenLoadedState(isGridView: isGridView, list: tableList));
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
        Constants.debugLog(TableScreenBloc,
            "_handleOnMoveItemUpTableInfo:Error occurred: $error");
        tableList!.insert(currentIndex, movingItem);
        tableList!.removeAt(currentIndex - 1);
        Constants.showToastMsg(msg: "Failed to update position");
        emit(TableScreenLoadedState(isGridView: isGridView, list: tableList));
      }
    }
  }

  Future<void> _handleOnMoveItemDownTableInfo(
      onMoveItemDownTableInfoEvent event,
      Emitter<TableScreenState> emit) async {
    int currentIndex = event.currentIndex;
    if (currentIndex < (tableList!.length - 1)) {
      Constants.debugLog(
          TableScreenBloc, "move item down from $currentIndex index");
      var db = await _databaseHelper.database;

      final TableInfoModel movingItem = tableList!.removeAt(currentIndex);
      tableList!.insert(currentIndex + 1, movingItem);
      emit(TableScreenLoadedState(isGridView: isGridView, list: tableList));
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
        Constants.debugLog(TableScreenBloc,
            "_handleOnMoveItemDownTableInfo:Error occurred: $error");
        tableList!.insert(currentIndex, movingItem);
        tableList!.removeAt(currentIndex + 1);
        Constants.showToastMsg(msg: "Failed to update position");
        emit(TableScreenLoadedState(isGridView: isGridView, list: tableList));
      }
    }
  }

  Future<void> _handleAddNewTableInfo(AddNewTableInfoEvent event, Emitter<TableScreenState> emit) async{
    tableList = await RestaurantRepository().getTableInfoList();
    emit(TableScreenLoadedState(isGridView: isGridView, list: tableList));
  }
}
