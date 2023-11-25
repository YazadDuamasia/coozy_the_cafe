import 'dart:math';
import 'dart:ui';

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
            title: const Text(
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
                tooltip:
                    isGridView ? "Switch to List View" : "Switch to Grid View",
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
                          var result = await RestaurantRepository()
                              .addNewTableInfo(newTableInfoModel);
                          Constants.debugLog(
                              TableScreen, "Created new:$result");
                          setState(() {
                            loadData();
                          });
                          Navigator.of(context).pop(); // Close the dialog
                          Constants.customTimerPopUpDialogMessage(
                              classObject: TableScreen,
                              isLoading: true,
                              context: context,
                              descriptions:
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
                        },
                      );
                    },
                  );
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                tooltip: "Add new Table",
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
      itemCount: list == null ? 0 : list?.length ?? 0,
      itemBuilder: (context, index) => buildGridItem(list![index], index),
      onReorder: (oldIndex, newIndex) async {
        Constants.debugLog(TableScreen, "reorder: $oldIndex -> $newIndex");
        var db = await _databaseHelper.database;

        await db!.transaction((txn) async {
          // Update sortOrderIndex in the database
          final int minIndex = min(oldIndex, newIndex);
          final int maxIndex = max(oldIndex, newIndex);

          // Get the item being moved
          final TableInfoModel movingItem = list!.removeAt(oldIndex);
          // Insert the item at the new position
          list!.insert(newIndex, movingItem);

          // Update sortOrderIndex for affected items
          for (int i = minIndex; i <= maxIndex; i++) {
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
        setState(() {});
      },
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

  Widget buildReorderableListView() {
    return ReorderableListView.builder(
      itemCount: list == null ? 0 : list?.length ?? 0,
      itemBuilder: (context, index) => buildListItem(list![index], index),
      onReorder: (oldIndex, newIndex) async {
        Constants.debugLog(TableScreen, "reorder: $oldIndex -> $newIndex");
        var db = await _databaseHelper.database;

        await db!.transaction((txn) async {
          // Update sortOrderIndex in the database
          final int minIndex = min(oldIndex, newIndex);
          final int maxIndex = max(oldIndex, newIndex);

          // Get the item being moved
          final TableInfoModel movingItem = list!.removeAt(oldIndex);
          // Insert the item at the new position
          list!.insert(newIndex, movingItem);

          // Update sortOrderIndex for affected items
          for (int i = minIndex; i <= maxIndex; i++) {
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
        setState(() {});
      },
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child:
                            Text("${model.name}", textAlign: TextAlign.center),
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
              onTap: () async {
                // Handle the delete action here
                Constants.debugLog(
                    TableScreen, 'Delete table with ID: ${model.id}');
                int? result =
                    await RestaurantRepository().deleteTableInfo(model.id!);
                Constants.debugLog(
                    TableScreen, "Delete RestaurantRepository result:$result");
                if (result != -1) {
                  list?.removeAt(index);
                  setState(() {});
                  Constants.customTimerPopUpDialogMessage(
                      classObject: TableScreen,
                      isLoading: true,
                      context: context,
                      descriptions:
                          "Select table has been remove successfully.",
                      title: "",
                      titleIcon: Lottie.asset(
                        MediaQuery.of(context).platformBrightness ==
                                Brightness.light
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
                      descriptions: "Failed to delete you select table.",
                      title: "",
                      titleIcon: Lottie.asset(
                        MediaQuery.of(context).platformBrightness ==
                                Brightness.light
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
              },
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
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child:
                            Text("${model.name}", textAlign: TextAlign.center),
                      ),
                      GestureDetector(
                        onTap: () async {
                          // Handle the delete action here
                          Constants.debugLog(
                              TableScreen, 'Delete table with ID: ${model.id}');
                          int? result = await RestaurantRepository()
                              .deleteTableInfo(model.id!);
                          Constants.debugLog(TableScreen,
                              "Delete RestaurantRepository result:$result");
                          if (result != -1) {
                            list?.removeAt(index);
                            setState(() {});
                            Constants.customTimerPopUpDialogMessage(
                                classObject: TableScreen,
                                isLoading: true,
                                context: context,
                                descriptions:
                                    "Select table has been remove successfully.",
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
                            // Fluttertoast.showToast(
                            //     msg: "Select table has been remove successfully.",
                            //     timeInSecForIosWeb: 3,
                            //     toastLength: Toast.LENGTH_SHORT);
                          } else {
                            Constants.customTimerPopUpDialogMessage(
                                classObject: TableScreen,
                                isLoading: true,
                                context: context,
                                descriptions:
                                    "Failed to delete you select table.",
                                title: "",
                                titleIcon: Lottie.asset(
                                  MediaQuery.of(context).platformBrightness ==
                                          Brightness.light
                                      ? StringImagePath
                                          .done_light_brown_color_lottie
                                      : StringImagePath.done_brown_color_lottie,
                                  // fit: BoxFit.fill,
                                  // width: 22,
                                  // height: 22,
                                  // animate: true,
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
                        },
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
    Constants.debugLog(TableScreen,"updateTableInfo:model:${model.toString()}");
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
}
