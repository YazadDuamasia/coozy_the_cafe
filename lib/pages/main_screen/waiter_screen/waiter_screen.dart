import 'dart:ui';

import 'package:coozy_the_cafe/AppLocalization.dart';
import 'package:coozy_the_cafe/bloc/waiter_list_screen_bloc/waiter_list_screen_bloc.dart';
import 'package:coozy_the_cafe/model/table_info_model.dart';
import 'package:coozy_the_cafe/pages/main_screen/table_screen/new_table_info_dialog.dart';
import 'package:coozy_the_cafe/pages/startup_screens/error_page/error_page.dart';
import 'package:coozy_the_cafe/pages/startup_screens/loading_page/loading_page.dart';
import 'package:coozy_the_cafe/repositories/components/restaurant_repository.dart';
import 'package:coozy_the_cafe/utlis/components/menu_search_icons.dart';
import 'package:coozy_the_cafe/utlis/utlis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class WaiterScreen extends StatefulWidget {
  const WaiterScreen({Key? key}) : super(key: key);

  @override
  _WaiterScreenState createState() => _WaiterScreenState();
}

class _WaiterScreenState extends State<WaiterScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: BlocConsumer<WaiterListScreenBloc, WaiterListScreenState>(
          listener: (context, state) {
            if (state is WaiterListScreenErrorState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message ?? "")));
            }
          },
          builder: (context, state) {
            if (state is WaiterListScreenInitialState ||
                state is WaiterListScreenLoadingState) {
              return const LoadingPage();
            }
            if (state is WaiterListScreenErrorState) {
              return ErrorPage(onPressedRetryButton: () async {
                BlocProvider.of<WaiterListScreenBloc>(context)
                    .add(InitialLoadWaiterListScreenEvent());
              });
            } else if (state is WaiterListScreenLoadedState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10, top: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                          padding: const EdgeInsets.only(top: 30, bottom: 30),
                          tapTargetSize: MaterialTapTargetSize.padded,
                        ),
                        onPressed: () async {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Icon(
                                    Menu_search.fill_order_add_btn,
                                    size: 60,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          "Add new order",
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: Visibility(
                              visible:
                                  (state.isGridView == true) ? true : false,
                              replacement: Expanded(
                                  child: buildListView(state.tableList)),
                              child: Expanded(child: buildGridView(state.tableList)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildGridView(List<TableInfoModel>? list) {
    if (list != null && list.isNotEmpty) {
      return ReorderableGridView.builder(
        itemCount: list == null ? 0 : list.length ?? 0,
        itemBuilder: (context, index) =>
            buildGridItem(list[index], index, list),

        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: true,
        onReorder: (oldIndex, newIndex) async {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          setState(() {
            BlocProvider.of<WaiterListScreenBloc>(context).add(
              onReOrderTableInfoWaiterListScreenEvent(
                  oldIndex: oldIndex, newIndex: newIndex, context: context),
            );
          });
        },
        placeholderBuilder: (dragIndex, dropIndex, dragWidget) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.tertiary),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
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
        ),
      );
    } else {
      return emptyDataWidget();
    }
  }

  Widget buildGridItem(
      TableInfoModel model, var index, List<TableInfoModel>? list) {
    return Card(
      key: ValueKey("$index"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 3,
      child: Material(
        color: Colors.transparent,
        type: MaterialType.card,
        child: InkWell(
          onTap: () async {
            handleOrderInfo(model);
          },
          onLongPress: () async {
            onUpdateModel(model);
          },
          borderRadius: BorderRadius.circular(5.0),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                          "${AppLocalizations.of(context)?.translate(StringValue.table_color_indicator_label_text) ?? "Color Indicator"} : ",
                          textAlign: TextAlign.start),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Color(
                              int.parse(model.colorValue ?? "000000", radix: 16) |
                                  0xFF000000),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildListView(List<TableInfoModel>? list) {
    if (list != null && list.isNotEmpty) {
      return ReorderableListView.builder(
        itemCount: list == null ? 0 : list.length ?? 0,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) =>
            buildListItem(list[index], index, list),
        onReorder: (oldIndex, newIndex) async {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          setState(() {
            BlocProvider.of<WaiterListScreenBloc>(context).add(
              onReOrderTableInfoWaiterListScreenEvent(
                  oldIndex: oldIndex, newIndex: newIndex, context: context),
            );
          });
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
                child: buildListItem(list[index], index, list),
              );
            },
            child: child,
          );
        },
      );
    } else {
      return emptyDataWidget();
    }
  }

  Widget buildListItem(
      TableInfoModel model, var index, List<TableInfoModel>? list) {
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
            type: MaterialType.card,
            child: InkWell(
              onTap: () async {
                await handleOrderInfo(model);
              },
              onLongPress: () async {
                onUpdateModel(model);
              },
              borderRadius: BorderRadius.circular(5.0),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(
                            int.parse(model.colorValue ?? "000000", radix: 16) |
                                0xFF000000),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
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
                                const SizedBox(
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
                          IconButton(
                            onPressed: () async {
                              await handleOrderInfo(model);
                            },
                            icon: const Icon(Icons.navigate_next),
                          ),
                          // Visibility(
                          //   visible: index == 0 ? false : true,
                          //   child: IconButton(
                          //     onPressed: () async {
                          //       BlocProvider.of<WaiterListScreenBloc>(context)
                          //           .add(
                          //         onMoveItemUpTableInfoWaiterListScreenEvent(
                          //           currentIndex: index,
                          //           context: context,
                          //         ),
                          //       );
                          //     },
                          //     icon: const Icon(Icons.arrow_upward_rounded),
                          //   ),
                          // ),
                          // Visibility(
                          //   visible: index < (list!.length - 1),
                          //   child: IconButton(
                          //     onPressed: () async {
                          //       BlocProvider.of<WaiterListScreenBloc>(context)
                          //           .add(
                          //         onMoveItemDownTableInfoWaiterListScreenEvent(
                          //           currentIndex: index,
                          //           context: context,
                          //         ),
                          //       );
                          //     },
                          //     icon: const Icon(Icons.arrow_downward_rounded),
                          //   ),
                          // ),
                          /*   GestureDetector(
                            onTap: () async {
                              ondDelete(model, index);
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 24.0,
                            ),
                          ),*/
                        ],
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

  Widget emptyDataWidget() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(MenuIcons.round_table,
                color: Theme.of(context).primaryColor, size: 110),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text("No table records found.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                addNewTableInfo();
              },
              style: ElevatedButton.styleFrom(
                textStyle: Theme.of(context).textTheme.bodyLarge,
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  right: 25,
                  left: 25,
                ),
                elevation: 5,
              ),
              child: Text(AppLocalizations.of(context)
                      ?.translate(StringValue.table_btn_add_new_table_text) ??
                  'Add new table info'),
            ),
          ],
        ),
      ],
    );
  }

  void ondDelete(model, index) {
    Constants.customPopUpDialogMessage(
        classObject: WaiterScreen,
        context: context,
        titleIcon: Icon(
          Icons.info_outline,
          size: 40,
          color: Theme.of(context).primaryColor,
        ),
        title:
            "${AppLocalizations.of(context)?.translate(StringValue.table_screen_delete_title_txt) ?? "Are you sure ?"}",
        descriptions:
            "${AppLocalizations.of(context)?.translate(StringValue.table_screen_delete_subTitle_txt) ?? "Do you really want to delete this table information? You will not be able to undo this action."}",
        actions: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            TextButton(
              child: Text(
                "${AppLocalizations.of(context)!.translate(StringValue.common_cancel)}",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.white
                          : null,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text(
                "${AppLocalizations.of(context)!.translate(StringValue.common_okay)}",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.white
                          : null,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              onPressed: () {
                Navigator.pop(context);
                BlocProvider.of<WaiterListScreenBloc>(context).add(
                  DeleteTableWaiterListScreenEvent(
                    tableInfoModel: model,
                    index: index,
                    context: context,
                  ),
                );
              },
            )
          ],
        ));
  }

  void onUpdateModel(TableInfoModel model) async {
    Constants.debugLog(
        WaiterScreen, "updateTableInfo:model:${model.toString()}");
    BlocProvider.of<WaiterListScreenBloc>(context).add(
      UpdateTableWaiterListScreenEvent(
        context: context,
        updatedTableInfo: model,
      ),
    );
  }

  void addNewTableInfo() async {
    await showDialog(
      context: context,
      builder: (context) {
        return NewTableDialog(
          onCreate: (newTableInfoModel) async {
            // Handle the creation of the new table here
            Constants.debugLog(
                WaiterScreen, 'Created new table: $newTableInfoModel');
            int? result =
                await RestaurantRepository().addNewTableInfo(newTableInfoModel);
            Constants.debugLog(WaiterScreen, "Created new:$result");
            BlocProvider.of<WaiterListScreenBloc>(context)
                .add(AddNewTableWaiterListScreenEvent());
            Navigator.of(context).pop();
            if (result != null && result > 0) {
              Constants.customAutoDismissAlertDialog(
                  classObject: WaiterScreen,
                  context: context,
                  descriptions: AppLocalizations.of(context)?.translate(
                          StringValue.table_added_successfully_text) ??
                      "New table has been added successfully.",
                  title: "",
                  titleIcon: Lottie.asset(
                    MediaQuery.of(context).platformBrightness ==
                            Brightness.light
                        ? StringImagePath.done_light_brown_color_lottie
                        : StringImagePath.done_brown_color_lottie,
                    repeat: false,
                  ),
                  navigatorKey: navigatorKey);
            } else {
              Constants.customAutoDismissAlertDialog(
                  classObject: WaiterScreen,
                  context: context,
                  descriptions: AppLocalizations.of(context)
                          ?.translate(StringValue.table_failed_to_added_text) ??
                      "Fail to add new table info.",
                  title: "",
                  titleIcon: Lottie.asset(
                    MediaQuery.of(context).platformBrightness ==
                            Brightness.light
                        ? StringImagePath.done_light_brown_color_lottie
                        : StringImagePath.done_brown_color_lottie,
                    repeat: false,
                  ),
                  navigatorKey: navigatorKey);
            }
          },
        );
      },
    );
  }

  Future<void> handleOrderInfo(TableInfoModel model) async {
    Constants.debugLog(WaiterScreen, "navigate_next:${model.toJson()}");
  }
}
