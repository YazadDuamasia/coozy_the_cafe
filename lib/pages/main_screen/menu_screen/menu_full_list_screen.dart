import 'package:coozy_the_cafe/AppLocalization.dart';
import 'package:coozy_the_cafe/model/menu_item.dart';
import 'package:coozy_the_cafe/pages/startup_screens/loading_page/loading_page.dart';
import 'package:coozy_the_cafe/repositories/components/restaurant_repository.dart';
import 'package:coozy_the_cafe/routing/routs.dart';
import 'package:coozy_the_cafe/utlis/components/menu_search_icons.dart';
import 'package:coozy_the_cafe/utlis/utlis.dart';
import 'package:coozy_the_cafe/widgets/animated_hint_textfield/animated_hint_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MenuFullListScreen extends StatefulWidget {
  const MenuFullListScreen({super.key});

  @override
  _MenuFullListScreenState createState() => _MenuFullListScreenState();
}

class _MenuFullListScreenState extends State<MenuFullListScreen>
    with TickerProviderStateMixin {
  List<MenuItem>? list = [];
  List<MenuItem>? filteredList = [];
  List<ValueNotifier<bool>> expandedStateList = [];
  List<ExpansionTileController>? filteredExpansionTileControllerList = [];

  bool isLoading = true;
  TextEditingController? searchController = TextEditingController(text: "");
  String searchQuery = '';
  int? expandedIndex = -1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      list = [];
      filteredList = [];
      expandedStateList = [];
      filteredExpansionTileControllerList = [];

      isLoading = true;
      searchController = TextEditingController(text: "");
      searchController!.addListener(() {
        setState(() {
          searchQuery = searchController!.text;
          _filterMenuItems();
        });
      });
      searchQuery = '';
      expandedIndex = -1;
      setState(() {});

      loadData();
    });
  }

  void _filterMenuItems() {
    filteredList = list?.where((item) {
      return item.name!.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    expandedStateList = List.generate(
        filteredList?.length ?? 0, (index) => ValueNotifier(false));

    filteredExpansionTileControllerList = List.generate(
        filteredList?.length ?? 0, (index) => new ExpansionTileController());

    setState(() {});
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
            title: const Text("Menu Item List"),
            leadingWidth: 35,
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: () async {
                  String arg = AddEditMenuItemArgument.addEditMenuItemToJson(
                      AddEditMenuItemArgument(menuItem: null));
                  Constants.debugLog(
                      MenuFullListScreen, "Add:newMenu:arguments:$arg");
                  navigationRoutes
                      .navigateTAddNewMenuItemScreen(arg)
                      .then((value) {
                    loadData();
                  });
                },
                icon: const Icon(Icons.add, color: Colors.white),
                tooltip: "Add new menu item",
              ),
            ],
          ),
          body: isLoading
              ? const LoadingPage()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: AnimatedHintTextField(
                              controller: searchController,
                              animationType: AnimationType.typer,
                              hintTextStyle: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                overflow: TextOverflow.ellipsis,
                              ),
                              textInputAction: TextInputAction.done,
                              hintTexts: const ['Search dish by name'],
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: Visibility(
                                  visible: (searchController!.text == null ||
                                          searchController!.text == "" ||
                                          searchController!.text.isEmpty)
                                      ? false
                                      : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        searchController!.clear();
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      });
                                    },
                                    child: const Icon(Icons.clear),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.only(
                                    left: 10, right: 10, bottom: 5, top: 5),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).disabledColor,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.error),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.error),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Visibility(
                        visible: (filteredList == null || filteredList!.isEmpty)
                            ? false
                            : true,
                        child: RefreshIndicator(
                          onRefresh: _refreshData,
                          child: SlidableAutoCloseBehavior(
                            child: ListView.builder(
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.onDrag,
                              shrinkWrap: true,
                              primary: true,
                              physics: const ClampingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              addAutomaticKeepAlives: false,
                              addRepaintBoundaries: true,
                              itemCount: filteredList?.length ?? 0,
                              itemBuilder: (context, index) {
                                final item = filteredList![index];
                                double? profitMargin = calculateProfitMargin(
                                    filteredList![index].costPrice,
                                    filteredList![index].sellingPrice);
                                return Padding(
                                  padding: EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                      top: index == 0 ? 0 : 5,
                                      bottom: index == filteredList!.length - 1
                                          ? 10
                                          : 0),
                                  child: itemView(
                                      item, context, profitMargin, index),
                                );
                              },
                            ),
                          ),
                        ),
                        replacement: Visibility(
                          visible: searchController!.text == null ||
                              searchController!.text == "" ||
                              searchController!.text.isEmpty,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(
                                    MenuIcons.recipe,
                                    size: 120,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "No Data Found",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ElevatedButton(
                                    child: Text("Add new menu items"),
                                    onPressed: () async {
                                      String arg = AddEditMenuItemArgument
                                          .addEditMenuItemToJson(
                                              AddEditMenuItemArgument(
                                                  menuItem: null));
                                      Constants.debugLog(MenuFullListScreen,
                                          "EmptyList:Add:newMenu:arguments:$arg");
                                      navigationRoutes
                                          .navigateTAddNewMenuItemScreen(arg)
                                          .then((value) {
                                        loadData();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          replacement: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(
                                    Menu_search.menu_search,
                                    size: 120,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "No Search result Found",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget itemView(
      MenuItem item, BuildContext context, double? profitMargin, int index) {
    final isExpandedNotifier = expandedStateList[index];

    return ValueListenableBuilder<bool>(
        valueListenable: isExpandedNotifier,
        builder: (context, isExpanded, child) {
          return Slidable(
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (BuildContext context) async {
                    String arg = AddEditMenuItemArgument.addEditMenuItemToJson(
                        AddEditMenuItemArgument(menuItem: item));
                    Constants.debugLog(
                        MenuFullListScreen, "Update:newMenu:arguments:$arg");
                    await navigationRoutes.navigateTAddNewMenuItemScreen(arg);

                    loadData();
                  },
                  backgroundColor: Colors.lightBlueAccent,
                  foregroundColor: Colors.white,
                  icon: MdiIcons.circleEditOutline,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(0),
                    topRight: Radius.circular(0),
                  ),
                  label: 'Edit',
                ),
                SlidableAction(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  autoClose: true,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    topLeft: Radius.circular(0),
                    bottomLeft: Radius.circular(0),
                  ),
                  icon: Icons.delete,
                  label: 'Delete',
                  onPressed: (BuildContext context) async {
                    await RestaurantRepository().deleteMenuItem(item.id);
                    loadData();
                  },
                ),
              ],
            ),
            child: Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              elevation: 5,
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: expandedIndex == index,
                  tilePadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  childrenPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  collapsedShape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  maintainState: true,
                  controller: filteredExpansionTileControllerList![index] ??
                      ExpansionTileController(),
                  onExpansionChanged: (bool expanded) {
                    setState(() {
                      if (expanded) {
                        expandedIndex = index;
                        for (int i = 0; i < expandedStateList.length; i++) {
                          if (i != index) {
                            expandedStateList[i].value = false;
                            filteredExpansionTileControllerList![i].collapse();
                          } else {
                            expandedStateList[i].value = true;
                          }
                        }
                      } else if (expandedIndex == index) {
                        expandedIndex = null;
                        expandedStateList[index].value = false;
                      }
                    });
                  },
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              item.name ?? '',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: !isExpanded,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Cooking duration: ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w700),
                                    ),
                                    TextSpan(
                                      text:
                                          "${item.duration == null || item.duration == 0 ? "N/A" : Constants.convertSecondsToHMS(item.duration ?? 0)}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: !isExpanded,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Selling Price: ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w700),
                                    ),
                                    TextSpan(
                                      text: item.sellingPrice
                                              ?.toStringAsFixed(2) ??
                                          "0.00",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: !isExpanded,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Purchase quantity: ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w700),
                                    ),
                                    TextSpan(
                                      text:
                                          "${item.quantity ?? ""} ${item.purchaseUnit}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Description: ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.w700),
                                          ),
                                          TextSpan(
                                            text: item.description ?? "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5.0),
                                      child: SwitchListTile.adaptive(
                                        contentPadding: const EdgeInsets.only(
                                            bottom: 5,
                                            top: 5,
                                            left: 5,
                                            right: 5),
                                        visualDensity: VisualDensity
                                            .adaptivePlatformDensity,
                                        thumbIcon: WidgetStateProperty
                                            .resolveWith<Icon>(
                                          (Set<WidgetState> states) {
                                            if (states.containsAll([
                                              WidgetState.disabled,
                                              WidgetState.selected
                                            ])) {
                                              return const Icon(Icons.check,
                                                  color: Colors.red);
                                            }
                                            if (states.contains(
                                                WidgetState.disabled)) {
                                              return const Icon(
                                                Icons.close,
                                              );
                                            }

                                            if (states.contains(
                                                WidgetState.selected)) {
                                              return const Icon(Icons.check,
                                                  color: Colors.green);
                                            }

                                            return const Icon(
                                              Icons.close,
                                            );
                                          },
                                        ),
                                        title: Text(
                                          "${AppLocalizations.of(context)!.translate(StringValue.today_available) ?? "Today Available"}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                        value: item.isTodayAvailable ?? false,
                                        onChanged: (newValue) {
                                          item.isTodayAvailable = newValue;
                                          setState(() {});
                                          RestaurantRepository()
                                              .updateMenuItem(item);
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Cooking Duration: ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.w700),
                                          ),
                                          TextSpan(
                                            text: Constants.convertSecondsToHMS(
                                                item.duration ?? 0),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Food Type: ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.w700),
                                          ),
                                          TextSpan(
                                            text: item.foodType ?? "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Purchase quantity: ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.w700),
                                          ),
                                          TextSpan(
                                            text:
                                                "${item.quantity ?? ""} ${item.purchaseUnit}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Costing Price: ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.w700),
                                          ),
                                          TextSpan(
                                            text: item.costPrice
                                                    ?.toStringAsFixed(2) ??
                                                "0.00",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Selling Price: ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.w700),
                                          ),
                                          TextSpan(
                                            text: item.sellingPrice
                                                    ?.toStringAsFixed(2) ??
                                                "0.00",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Profit Margin: ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.w700),
                                          ),
                                          TextSpan(
                                            text:
                                                "${profitMargin!.toStringAsFixed(2) ?? "0.00"} %",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  color: profitMargin < 0
                                                      ? Colors.red
                                                      : profitMargin == 0
                                                          ? null
                                                          : Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> loadData() async {
    setState(() {});
    isLoading = true;
    setState(() {});
    list = await RestaurantRepository().getMenuItems();
    searchController!.text = "";
    searchQuery = "";
    Constants.debugLog(MenuFullListScreen, "LoadData:$list");
    setState(() {
      isLoading = false;
      _filterMenuItems(); // Initialize the filtered list
    });
  }

  Future<void> _refreshData() async {
    loadData();
  }

  double? calculateProfitMargin(double? dishPrice, double? dishSellingAmount) {
    // Log the parsed values for debugging
    Constants.debugLog(MenuFullListScreen, "CP_amt: $dishPrice");
    Constants.debugLog(MenuFullListScreen, "SP_amt: $dishSellingAmount");

    // Check for invalid input to avoid division by zero
    if (dishPrice == 0.0) {
      // Log the issue for debugging
      Constants.debugLog(MenuFullListScreen, "Invalid cost price: $dishPrice");
      return 0.0; // Returning 0.0 to indicate an invalid profit margin
    }

    if (dishSellingAmount == 0.0) {
      // Log the issue for debugging
      Constants.debugLog(
          MenuFullListScreen, "Invalid selling price: $dishSellingAmount");
      return 0.0; // Returning 0.0 to indicate an invalid profit margin
    }

    // Calculate the profit
    final profit = dishSellingAmount! - dishPrice!;

    // Calculate the profit margin as a percentage of the cost price
    final profitMargin = (profit / dishPrice) * 100;

    // Log the calculated profit margin for debugging
    Constants.debugLog(MenuFullListScreen, "Profit margin: $profitMargin%");

    // Return the calculated profit margin
    return profitMargin;
  }

  @override
  void dispose() {
    searchController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
