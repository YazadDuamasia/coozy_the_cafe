import 'dart:math';
import 'dart:ui';

import 'package:coozy_cafe/AppLocalization.dart';
import 'package:coozy_cafe/database_helper/DatabaseHelper.dart';
import 'package:coozy_cafe/model/table_info_model.dart';
import 'package:coozy_cafe/pages/main_screen/table_screen/new_table_info_dialog.dart';
import 'package:coozy_cafe/pages/main_screen/table_screen/table_update_dialog.dart';
import 'package:coozy_cafe/pages/startup_screens/loading_page/loading_page.dart';
import 'package:coozy_cafe/repositories/repositories.dart';
import 'package:coozy_cafe/utlis/utlis.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({Key? key}) : super(key: key);

  @override
  _TableScreenState createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen>
    with TickerProviderStateMixin {
  List<TableInfoModel>? list = [];
  bool isLoading = true;
  bool isGridView = true; // Added to track the current view type
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)
                      ?.translate(StringValue.table_info_app_bar_title) ??
                  "Table Info",
            ),
            leadingWidth: 35,
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: () {
                  // Toggle between list and grid view
                  setState(() {
                    isGridView = !isGridView;
                  });
                },
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: isGridView
                      ? const Icon(
                          Icons.list,
                          key: ValueKey('list'),
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.grid_view,
                          key: ValueKey('grid'),
                          color: Colors.white,
                        ),
                ),
                tooltip: isGridView
                    ? (AppLocalizations.of(context)
                            ?.translate(StringValue.common_list_view_tooltip) ??
                        "Switch to List View")
                    : (AppLocalizations.of(context)
                            ?.translate(StringValue.common_grid_view_tooltip) ??
                        "Switch to Grid View"),
              ),
              IconButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return NewTableDialog(
                        onCreate: (newTableInfoModel) async {
                          // Handle the creation of the new table here
                          Constants.debugLog(TableScreen,
                              'Created new table: ${newTableInfoModel}');
                          int? result = await RestaurantRepository()
                              .addNewTableInfo(newTableInfoModel);
                          Constants.debugLog(
                              TableScreen, "Created new:$result");
                          setState(() {
                            loadData();
                          });
                          Navigator.of(context).pop();
                          if (result != null && result > 0) {
                            Constants.customTimerPopUpDialogMessage(
                                classObject: TableScreen,
                                isLoading: true,
                                context: context,
                                descriptions: AppLocalizations.of(context)
                                        ?.translate(StringValue
                                            .table_added_successfully_text) ??
                                    "New table has been added successfully.",
                                title: "",
                                titleIcon: Lottie.asset(
                                  MediaQuery.of(context).platformBrightness ==
                                          Brightness.light
                                      ? StringImagePath
                                          .done_light_brown_color_lottie
                                      : StringImagePath.done_brown_color_lottie,
                                  repeat: false,
                                ),
                                showForHowDuration: const Duration(seconds: 3),
                                navigatorKey: navigatorKey);
                          } else {
                            Constants.customTimerPopUpDialogMessage(
                                classObject: TableScreen,
                                isLoading: true,
                                context: context,
                                descriptions: AppLocalizations.of(context)
                                        ?.translate(StringValue
                                            .table_failed_to_added_text) ??
                                    "Fail to add new table info.",
                                title: "",
                                titleIcon: Lottie.asset(
                                  MediaQuery.of(context).platformBrightness ==
                                          Brightness.light
                                      ? StringImagePath
                                          .done_light_brown_color_lottie
                                      : StringImagePath.done_brown_color_lottie,
                                  repeat: false,
                                ),
                                showForHowDuration: const Duration(seconds: 3),
                                navigatorKey: navigatorKey);
                          }
                        },
                      );
                    },
                  );
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                tooltip: AppLocalizations.of(context)
                        ?.translate(StringValue.add_table_icon_tooltip_text) ??
                    "Add a new Table",
              ),
            ],
          ),
          body: isLoading == true
              ? const LoadingPage()
              : Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: isGridView
                        ? Center(child: buildReorderableGridView())
                        : buildReorderableListView(),
                  )),
        ),
      ),
    );
  }

  Widget buildReorderableGridView() {
    return ReorderableGridView.builder(
      itemCount: list == null ? 0 : list!.length,
      itemBuilder: (context, index) => buildGridItem(list![index], index),
      onReorder: onReOrder,
      placeholderBuilder: (dragIndex, dropIndex, dragWidget) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.tertiary),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: const FrostedGlassWidget(
              child: SizedBox(),
            ),
          ),
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.0,
          mainAxisExtent: 120),
    );
  }

  Widget buildGridItem(TableInfoModel model, var index) {
    return Card(
      key: ValueKey("$index"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 5,
      child: Stack(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                await updateTableInfo(model, index);
              },
              borderRadius: BorderRadius.circular(5.0),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                                "${AppLocalizations.of(context)?.translate(StringValue.table_name_label_text) ?? "Table Name"}: ${model.name}",
                                textAlign: TextAlign.start),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                                "${AppLocalizations.of(context)?.translate(StringValue.table_nos_of_chairs_label_text) ?? "Nos Of Chairs per Table"}: ${model.nosOfChairs}",
                                textAlign: TextAlign.start),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 8.0, // Adjust the top position as needed
            right: 8.0, // Adjust the right position as needed
            child: GestureDetector(
              onTap: () async => onDeletedAction(model, index),
              child: const Icon(
                Icons.delete,
                color: Colors.red,
                size: 24.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReorderableListView() {
    return ReorderableListView.builder(
      itemCount: list == null ? 0 : list!.length,
      itemBuilder: (context, index) => buildListItem(list![index], index),
      onReorder: onReOrder,
      proxyDecorator: (child, index, animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? child) {
            final double animValue =
                Curves.easeInOut.transform(animation.value);
            final double elevation = lerpDouble(1, 6, animValue)!;
            final double scale = lerpDouble(1, 1.02, animValue)!;
            return Transform.scale(
              scale: scale,
              child: buildListItem(list![index], index),
            );
          },
          child: child,
        );
      },
    );
  }

  Widget buildListItem(TableInfoModel model, var index) {
    return Card(
      key: ValueKey("$index"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                await updateTableInfo(model, index);
              },
              borderRadius: BorderRadius.circular(5.0),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                    "${AppLocalizations.of(context)?.translate(StringValue.table_name_label_text) ?? "Table Name"}: ${model.name}",
                                    textAlign: TextAlign.start),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                    "${AppLocalizations.of(context)?.translate(StringValue.table_nos_of_chairs_label_text) ?? "Nos Of Chairs per Table"}: ${model.nosOfChairs}",
                                    textAlign: TextAlign.start),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: index == 0 ? false : true,
                      child: IconButton(
                        onPressed: () async {
                          await onMoveItemUp(index);
                        },
                        icon: Icon(Icons.arrow_upward_rounded),
                      ),
                    ),
                    Visibility(
                      visible: index < (list!.length - 1),
                      child: IconButton(
                        onPressed: () async {
                          await onMoveItemDown(index);
                        },
                        icon: Icon(Icons.arrow_downward_rounded),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async => onDeletedAction(model, index),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 24.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });
    list = await RestaurantRepository().getTableInfoList();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> updateTableInfo(TableInfoModel model, index) async {
    Constants.debugLog(
        TableScreen, "updateTableInfo:model:${model.toString()}");
    showDialog(
      context: context,
      builder: (context) {
        return TableUpdateDialog(
          currentTableName: model, // Pass the current table name
          onUpdate: (newName) async {
            // Updated table name
            Constants.debugLog(TableScreen, 'Updated table name: $newName');
          },
        );
      },
    );
  }

  onDeletedAction(TableInfoModel model, index) async {
    // Handle the delete action here
    Constants.debugLog(TableScreen, 'Delete table with ID: ${model.id}');
    int? result = await RestaurantRepository()
        .deleteTableInfo(tableInfoModelToDelete: model);
    Constants.debugLog(
        TableScreen, "Delete RestaurantRepository result:$result");
    if (result != null && result > 0) {
      list?.removeAt(index);
      setState(() {});
      Constants.customTimerPopUpDialogMessage(
          classObject: TableScreen,
          isLoading: true,
          context: context,
          descriptions: AppLocalizations.of(context)
                  ?.translate(StringValue.table_deleted_successfully_text) ??
              "Select table has been deleted successfully.",
          title: "",
          titleIcon: Lottie.asset(
            MediaQuery.of(context).platformBrightness == Brightness.light
                ? StringImagePath.done_light_brown_color_lottie
                : StringImagePath.done_brown_color_lottie,
            repeat: false,
          ),
          showForHowDuration: const Duration(seconds: 3),
          navigatorKey: navigatorKey);
      // Fluttertoast.showToast(
      //     msg: "Select table has been remove successfully.",
      //     timeInSecForIosWeb: 3,
      //     toastLength: Toast.LENGTH_SHORT);
    } else {
      Constants.customTimerPopUpDialogMessage(
          classObject: TableScreen,
          isLoading: true,
          context: context,
          descriptions: AppLocalizations.of(context)
                  ?.translate(StringValue.table_failed_to_deleted_text) ??
              "Failed to delete you select table.",
          title: null,
          titleIcon: Lottie.asset(
            MediaQuery.of(context).platformBrightness == Brightness.light
                ? StringImagePath.done_light_brown_color_lottie
                : StringImagePath.done_brown_color_lottie,
            repeat: false,
          ),
          showForHowDuration: const Duration(seconds: 3),
          navigatorKey: navigatorKey);
      // Fluttertoast.showToast(
      //     msg: "Failed to delete you select table.",
      //     timeInSecForIosWeb: 3,
      //     toastLength: Toast.LENGTH_SHORT);
      setState(() {});
    }
  }

  void onReOrder(int oldIndex, int newIndex) async {
    Constants.debugLog(TableScreen, "reorder: $oldIndex -> $newIndex");
    var db = await _databaseHelper.database;
    setState(() {
      if (newIndex > oldIndex) {
        // Adjust the index if the item is moved down in the list
        newIndex -= 1;
      }

      final TableInfoModel movingItem = list!.removeAt(oldIndex);
      list!.insert(newIndex, movingItem);
    });

    await db!.transaction((txn) async {
      // Update sortOrderIndex for affected items
      for (int i = min(oldIndex, newIndex); i <= max(oldIndex, newIndex); i++) {
        final TableInfoModel currentItem = list![i];
        currentItem.sortOrderIndex = i;
        await txn.update(
          _databaseHelper.tableInfoTable,
          currentItem.toJson(),
          where: 'id = ?',
          whereArgs: [currentItem.id],
        );
      }
    });
  }

  Future<void> onMoveItemUp(int currentIndex) async {
    if (currentIndex > 0) {
      Constants.debugLog(TableScreen, "move item up from $currentIndex index");
      var db = await _databaseHelper.database;

      setState(() {
        final TableInfoModel movingItem = list!.removeAt(currentIndex);
        list!.insert(currentIndex - 1, movingItem);
      });
      await db!.transaction((txn) async {
        for (int i = currentIndex - 1; i <= currentIndex; i++) {
          final TableInfoModel currentItem = list![i];
          currentItem.sortOrderIndex = i;

          await txn.update(
            _databaseHelper.tableInfoTable,
            currentItem.toJson(),
            where: 'id = ?',
            whereArgs: [currentItem.id],
          );
        }
      });
    }
  }

  Future<void> onMoveItemDown(int currentIndex) async {
    if (currentIndex < (list!.length - 1)) {
      Constants.debugLog(
          TableScreen, "move item down from $currentIndex index");
      var db = await _databaseHelper.database;

      setState(() {
        final TableInfoModel movingItem = list!.removeAt(currentIndex);
        list!.insert(currentIndex + 1, movingItem);
      });

      await db!.transaction((txn) async {
        for (int i = currentIndex; i <= currentIndex + 1; i++) {
          final TableInfoModel currentItem = list![i];
          currentItem.sortOrderIndex = i;

          await txn.update(
            _databaseHelper.tableInfoTable,
            currentItem.toJson(),
            where: 'id = ?',
            whereArgs: [currentItem.id],
          );
        }
      });
    }
  }
}
