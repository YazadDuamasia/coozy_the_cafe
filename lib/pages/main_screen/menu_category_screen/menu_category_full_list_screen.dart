import 'package:coozy_the_cafe/AppLocalization.dart';
import 'package:coozy_the_cafe/bloc/menu_category_full_list_cubit/menu_category_full_list_cubit.dart';
import 'package:coozy_the_cafe/model/category.dart';
import 'package:coozy_the_cafe/model/sub_category.dart';
import 'package:coozy_the_cafe/pages/main_screen/menu_category_screen/menu_sub_category_expansion_child_listview_widget.dart';
import 'package:coozy_the_cafe/pages/pages.dart';
import 'package:coozy_the_cafe/utlis/utlis.dart';
import 'package:coozy_the_cafe/widgets/empty_category_full_list_body.dart';
import 'package:coozy_the_cafe/widgets/post_time_text_widget/post_time_text_widget.dart';
import 'package:coozy_the_cafe/widgets/responsive_layout/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MenuCategoryFullListScreen extends StatefulWidget {
  const MenuCategoryFullListScreen({super.key});

  @override
  _MenuCategoryFullListScreenState createState() =>
      _MenuCategoryFullListScreenState();
}

class _MenuCategoryFullListScreenState
    extends State<MenuCategoryFullListScreen> {
  ScrollController? _controller = ScrollController();
  FocusNode? searchAnchorFocusNode = FocusNode();
  String? searchQuery = '';
  SearchController? searchController = SearchController();

  bool positive = false;
  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  // TextEditingController? searchController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    searchController = SearchController();
    searchAnchorFocusNode = FocusNode();
    searchQuery = "";
    _controller = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<MenuCategoryFullListCubit>(context).loadData();
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
                      ?.translate(StringValue.menu_category_appbar_title) ??
                  "Menu Category",
            ),
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: () async {
                  await handleNewCategory();
                },
                icon: const Icon(
                  Icons.add,
                ),
                tooltip: AppLocalizations.of(context)?.translate(
                        StringValue.add_menu_category_icon_tooltip_text) ??
                    "Add a new menu category",
              ),
            ],
          ),
          body: BlocConsumer<MenuCategoryFullListCubit,
              MenuCategoryFullListState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              if (state is InitialState) {
                return const LoadingPage();
              } else if (state is LoadingState) {
                return const LoadingPage();
              } else if (state is LoadedState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    searchBarWithSuggestionWidget(context, state),
                    Expanded(
                      child: menuItemWidget(state),
                    ),
                  ],
                );
              } else if (state is ErrorState) {
                return ErrorPage(
                  key: UniqueKey(),
                  onPressedRetryButton: () async =>
                      BlocProvider.of<MenuCategoryFullListCubit>(context)
                          .loadData(),
                );
              } else if (state is NoInternetState) {
                return NoInternetPage(
                  key: UniqueKey(),
                  onPressedRetryButton: () async =>
                      BlocProvider.of<MenuCategoryFullListCubit>(context)
                          .loadData(),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget searchBarWithSuggestionWidget(
      BuildContext context, LoadedState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: SearchAnchor(
              searchController: searchController,
              builder: (BuildContext context, SearchController controller) {
                return Theme(
                  data: Theme.of(context),
                  child: SearchBar(
                    controller: controller,
                    focusNode: searchAnchorFocusNode,
                    padding: const MaterialStatePropertyAll<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 10.0)),
                    onTap: () {
                      controller.openView();
                    },
                    onChanged: (value) {
                      Constants.debugLog(MenuCategoryFullListScreen,
                          "SearchAnchor:onChanged:$value");
                      if (!controller.isOpen) {
                        scrollToItemAndExpand(value);
                      } else {
                        controller.openView();
                      }
                    },

                    onSubmitted: (value) {
                      Constants.debugLog(MenuCategoryFullListScreen,
                          "SearchAnchor:onSubmitted:$value");
                      scrollToItemAndExpand(value);
                    },
                    leading: const Icon(Icons.search),
                  ),
                );
              },
              isFullScreen: false,
              viewConstraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * .35 < 220
                    ? 220
                    : MediaQuery.of(context).size.height * .35 > 220
                        ? 250
                        : MediaQuery.of(context).size.height * .35,
              ),
              suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
                List<String> suggestions = [];
                if (state.data != null &&
                    state.data!.isNotEmpty &&
                    state.data!.containsKey("categories") &&
                    state.data!['categories'] != null) {
                  state.data!['categories'].forEach((category) {
                    suggestions.add(category['name'].toString());

                    if (category['subCategories'] != null) {
                      // Ensure that 'subCategories' is a List<Map<String, dynamic>>
                      suggestions.addAll(
                          (category['subCategories'] as List<dynamic>).map(
                              (subCategory) => subCategory['name'].toString()));
                    }
                  });
                } else {
                  suggestions = [];
                }
                List<Widget> suggestionWidgets = suggestions
                    .where((suggestion) => suggestion
                        .toLowerCase()
                        .contains(controller.value.text.toLowerCase()))
                    .map((suggestion) => ListTile(
                          title: Text(suggestion),
                          onTap: () {
                            setState(() {
                              controller.closeView(suggestion);
                            });
                          },
                        ))
                    .toList();
                return suggestionWidgets.isEmpty
                    ? [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)?.translate(
                                          StringValue
                                              .menu_category_search_no_suggestions) ??
                                      "No suggestions",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                            ],
                          ),
                        )
                      ]
                    : suggestionWidgets;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget searchBarWidget(BuildContext context, LoadedState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: SearchBar(
              focusNode: searchAnchorFocusNode,
              padding: const MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 10.0)),
              onChanged: (value) {
                Constants.debugLog(MenuCategoryFullListScreen,
                    "SearchAnchor:onChanged:$value");
                scrollToItemAndExpand(value);
              },

              onSubmitted: (value) {
                Constants.debugLog(MenuCategoryFullListScreen,
                    "SearchAnchor:onSubmitted:$value");
                scrollToItemAndExpand(value);
              },
              leading: const Icon(Icons.search),
            ),
          ),
        ],
      ),
    );
  }

  // menuItemWidget(result!["categories"]) ,
  Widget menuItemWidget(LoadedState state) {
    var map = state.data?["categories"];
    if (map != null && map.isNotEmpty) {
      return CustomScrollView(
        shrinkWrap: true,
        controller: _controller,
        physics: const ClampingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              var category = map![index];
              return menuCategoryExpansionTileItem(
                  state: state,
                  model: category,
                  index: index,
                  totalItemLength: map?.length ?? 0);
            },
                addAutomaticKeepAlives: true,
                addRepaintBoundaries: false,
                childCount: map?.length ?? 0),
          ),
        ],
      );
    } else {
      return EmptyCategoryFullListBody(onAddNewCategory: handleNewCategory);
    }
  }

  Widget menuCategoryExpansionTileItem(
      {required LoadedState state,
      dynamic model,
      required int index,
      required int totalItemLength}) {
    Category category = Category(
        id: model["id"],
        createdDate: model["createdDate"],
        isActive: model["isActive"],
        name: model["name"]);

    List<dynamic>? dynamicSubCategories =
        model["subCategories"] as List<dynamic>?;

    List<SubCategory>? subCategoryList =
        SubCategory.convertDynamicListToSubCategoryList(dynamicSubCategories);
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(dividerColor: Colors.transparent),
      child: Padding(
        padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            bottom: (index < totalItemLength - 1) ? 0 : 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: ExpansionTile(
            // shape: Border(),
            key: state.expansionTileKeys![index] ?? GlobalKey(),
            maintainState: true,
            collapsedBackgroundColor: theme.colorScheme.primaryContainer,
            backgroundColor: theme.colorScheme.primaryContainer,
            tilePadding: EdgeInsets.zero,
            childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(child: Text(category.name ?? "")),
                ],
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          text: 'Enable Status: ',
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: category.isActive == 1
                                  ? AppLocalizations.of(context)?.translate(
                                          StringValue.common_active) ??
                                      "Active"
                                  : AppLocalizations.of(context)?.translate(
                                          StringValue.common_inactive) ??
                                      "inactive",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: category.isActive == 1
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                            ),
                          ],
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
                        child: PostTimeTextWidget(
                          key: UniqueKey(),
                          creationDate: category.createdDate ?? "",
                          localizedCode:
                              AppLocalizations.getCurrentLanguageCode(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            trailing: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 30,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Switch.adaptive(
                      value: category.isActive == 1 ? true : false,
                      onChanged: (bool isEnable) async {
                        BlocProvider.of<MenuCategoryFullListCubit>(context)
                            .handleIsEnableCategory(
                                context, category, isEnable);

                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      thumbIcon: thumbIcon,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(MdiIcons.circleEditOutline),
                  onPressed: () async {
                    Constants.debugLog(MenuCategoryFullListScreen,
                        "menuCategoryExpansionTileItem:IconButton:Index:${index}");
                    navigationRoutes
                        .navigateToUpdateMenuCategoryScreen(
                            categoryId: category.id)
                        .then((value) async => context
                            .read<MenuCategoryFullListCubit>()
                            .loadData());
                  },
                ),
              ],
            ),
            controller: state.expandedTitleControllerList![index],
            children: <Widget>[
              Visibility(
                visible: (subCategoryList != null && subCategoryList.isNotEmpty)
                    ? true
                    : false,
                child: ResponsiveLayout(
                  mobile: MenuSubCategoryExpansionChildListViewWidget(
                      key: UniqueKey(),
                      subCategoryList: subCategoryList,
                      itemsToShow: 5),
                  tablet: MenuSubCategoryExpansionChildListViewWidget(
                      key: UniqueKey(),
                      subCategoryList: subCategoryList,
                      itemsToShow: 10),
                  desktop: MenuSubCategoryExpansionChildListViewWidget(
                    key: UniqueKey(),
                    subCategoryList: subCategoryList,
                    itemsToShow: 10,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void scrollToItemAndExpand(String keyword) {
    if (BlocProvider.of<MenuCategoryFullListCubit>(context).state
        is LoadedState) {
      LoadedState loadedState =
          BlocProvider.of<MenuCategoryFullListCubit>(context).state
              as LoadedState;

      if (keyword != null &&
          keyword.isNotEmpty &&
          keyword != "menu_category_search_no_suggestions") {
        int index = -1;
        /*
        /*this also working Fine*/
        for (int i = 0; i < loadedState.data!['categories'].length; i++) {
          var category = loadedState.data!['categories'][i];
          if (category['name'].toString().toLowerCase() ==
              keyword.toLowerCase()) {
            index = i;
            break;
          }

          if (category['subCategories'] != null) {
            var subCategories = category['subCategories'];
            for (int j = 0; j < subCategories.length; j++) {
              if (subCategories[j]['name'].toString().toLowerCase() ==
                  keyword.toLowerCase()) {
                index = i;
                break;
              }
            }
          }
        }*/

        index = loadedState.data!['categories'].indexWhere((category) {
          bool isCategoryMatch = category['name']
              .toString()
              .toLowerCase()
              .contains(keyword.toLowerCase());

          if (isCategoryMatch) {
            return true;
          }

          if (category['subCategories'] != null) {
            return (category['subCategories'] as List).any((subCategory) =>
                subCategory['name']
                    .toString()
                    .toLowerCase()
                    .contains(keyword.toLowerCase()));
          }

          return false;
        });

        if (index != -1) {
          // Obtain the RenderBox
          RenderBox renderBox = loadedState
              .expansionTileKeys![index]!.currentContext
              ?.findRenderObject() as RenderBox;

          // Get the size of the RenderBox
          double itemHeight = renderBox.size.height;

          // Calculate the position
          double position = index * itemHeight;

          setState(() {
            // Toggle the isExpanded state
            if ((loadedState.expandedTitleControllerList != null ||
                    loadedState.expandedTitleControllerList!.isNotEmpty) &&
                loadedState.expandedTitleControllerList![index].isExpanded ==
                    false) {
              loadedState.expandedTitleControllerList![index].expand();
            }
          });

          // Scroll and toggle the isExpanded state
          _controller!.animateTo(
            position,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      } else {
        if (searchController!.isOpen == true) {
          Navigator.of(context).pop();
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).unfocus();
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> handleNewCategory() async {
    navigationRoutes.navigateToAddNewMenuCategoryScreen().then(
        (value) async => context.read<MenuCategoryFullListCubit>().loadData());
  }
}
