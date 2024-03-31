import 'package:coozy_cafe/AppLocalization.dart';
import 'package:coozy_cafe/bloc/bloc.dart';
import 'package:coozy_cafe/model/recipe_model.dart';
import 'package:coozy_cafe/pages/pages.dart';
import 'package:coozy_cafe/utlis/utlis.dart';
import 'package:coozy_cafe/widgets/pager/src/pager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/fliter_system_widget/filter_system.dart';

class RecipesListScreen extends StatefulWidget {
  const RecipesListScreen({Key? key}) : super(key: key);

  @override
  _RecipesListScreenState createState() => _RecipesListScreenState();
}

class _RecipesListScreenState extends State<RecipesListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<RecipesFullListCubit>(context).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text('Recipes'),
          ),
          body: BlocConsumer<RecipesFullListCubit, RecipesFullListState>(
            listener: (BuildContext context, RecipesFullListState state) {},
            builder: (BuildContext context, RecipesFullListState state) {
              if (state is RecipesInitialState) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(child: LoadingPage()),
                  ],
                );
              }
              if (state is RecipesLoadingState) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(child: LoadingPage()),
                  ],
                );
              } else if (state is RecipesLoadedState) {
                Constants.debugLog(RecipesListScreen,
                    "RecipesLoadedState:currentPage:${state.currentPage}");
                Constants.debugLog(RecipesListScreen,
                    "RecipesLoadedState:totalPages:${state.totalPages}");
                Constants.debugLog(RecipesListScreen,
                    "RecipesLoadedState:itemsPerPage:${state.itemsPerPage}");
                Constants.debugLog(RecipesListScreen,
                    "RecipesLoadedState:startIndex:${state.startIndex}");
                Constants.debugLog(RecipesListScreen,
                    "RecipesLoadedState:endIndex:${state.endIndex}");

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ElevatedButton.icon(
                            onPressed: () async {
                              await showFilterView();
                            },
                            icon: const Icon(Icons.filter_list, size: 24),
                            label: const Text("Filter"),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10), // Adjust the value to change roundness
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      child: Visibility(
                        visible:
                            (state.totalPages == null || state.totalPages == 0)
                                ? false
                                : true,
                        child: Scrollbar(
                          thumbVisibility: true,
                          child: CustomScrollView(
                            physics: const ClampingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics(),
                            ),
                            shrinkWrap: true,
                            slivers: [
                              SliverPadding(
                                padding: const EdgeInsets.only(top: 5),
                                sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                    RecipeModel model =
                                        state.paginatedData![index];
                                    return recipeItem(
                                      state: state,
                                      model: model,
                                      index: index,
                                    );
                                  },
                                      addSemanticIndexes: true,
                                      addAutomaticKeepAlives: true,
                                      addRepaintBoundaries: false,
                                      childCount:
                                          state.paginatedData?.length ?? 0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        replacement: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                MenuIcons.recipe,
                                size: 100,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        AppLocalizations.of(context)?.translate(
                                                StringValue
                                                    .recipes_list_screen_no_data_title_msg) ??
                                            "No data founded",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                               Padding(
                                 padding: const EdgeInsets.symmetric(horizontal: 20),
                                 child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        AppLocalizations.of(context)?.translate(
                                            StringValue
                                                .recipes_list_screen_no_data_sub_title_msg) ??
                                            "Please try again with different filter choices to pick from.",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.titleSmall,
                                      ),
                                    ),
                                  ],
                                                               ),
                               ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if ((state.totalPages == null || state.totalPages == 0)
                        ? false
                        : true)
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(top: 5),
                        child: Column(
                          children: [
                            Pager(
                              currentItemsPerPage: state.itemsPerPage ?? 1,
                              currentPage: state.currentPage == null
                                  ? 1
                                  : state.currentPage,
                              totalPages: state.totalPages == null
                                  ? 1
                                  : state.totalPages,
                              numberButtonSelectedColor:
                                  Theme.of(context).colorScheme.primary,
                              numberTextSelectedColor: Colors.white,
                              numberTextUnselectedColor: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .color!,
                              onPageChanged: (nextPage) {
                                print("nextPage:${nextPage}");

                                BlocProvider.of<RecipesFullListCubit>(context)
                                    .updatePageNumber(nextPage);
                              },
                              showItemsPerPage: true,
                              onItemsPerPageChanged: (itemsPerPage) async {
                                print("onItemsPerPageChanged:${itemsPerPage}");

                                BlocProvider.of<RecipesFullListCubit>(context)
                                    .updatePageItems(
                                        itemsPerPage: itemsPerPage);
                              },
                              itemsPerPageList: state.itemsPerPageList,
                              itemsPerPageAlignment: Alignment.center,
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              } else if (state is RecipesErrorState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: ErrorPage(
                        onPressedRetryButton: () async {
                          BlocProvider.of<RecipesFullListCubit>(context)
                              .loadData();
                        },
                      ),
                    ),
                  ],
                );
              } else if (state is NoInternetRecipesState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: NoInternetPage(
                        onPressedRetryButton: () async {
                          BlocProvider.of<RecipesFullListCubit>(context)
                              .loadData();
                        },
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
      ),
    );
  }

  Widget recipeItem(
      {required RecipesLoadedState state,
      required RecipeModel model,
      required int index}) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Visibility(
              visible: (model.translatedRecipeName == null ||
                      model.translatedRecipeName!.isEmpty)
                  ? false
                  : true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Text(model.translatedRecipeName ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w600)),
                  )
                ],
              ),
            ),
            Visibility(
              visible: (model.recipeName == null || model.recipeName!.isEmpty)
                  ? false
                  : true,
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Text(model.recipeName ?? "",
                          style: Theme.of(context).textTheme.bodyMedium),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              MenuIcons.total_cooking_time,
                              size: 30,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text("${model.recipeTotalTimeInMins ?? "0"} mins",
                                style: Theme.of(context).textTheme.bodyLarge),
                          ],
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              MenuIcons.coooking_time,
                              size: 30,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text("${model.recipeCookingTimeInMins ?? "0"} mins",
                                style: Theme.of(context).textTheme.bodyLarge),
                          ],
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              MenuIcons.serving_time,
                              size: 30,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                                "${model.recipePreparationTimeInMins ?? "0"} mins",
                                style: Theme.of(context).textTheme.bodyLarge),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'Cuisine: ',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.w700),
                        children: [
                          TextSpan(
                              text: "${model.recipeCuisine}",
                              style: Theme.of(context).textTheme.bodyMedium!),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'Course: ',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.w700),
                        children: [
                          TextSpan(
                              text: model.recipeCourse ?? "",
                              style: Theme.of(context).textTheme.bodyMedium!),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future showFilterView() async {
    return showModalBottomSheet(
      isDismissible: false,
      context: context,
      enableDrag: false,
      constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          minWidth: MediaQuery.of(context).size.width,
          minHeight: 0,
          maxHeight: MediaQuery.of(context).size.height * 0.7),
      isScrollControlled: true,
      builder: (_) {
        return FilterWidget(
          filterProps: FilterProps(
            onFilterChange: (List<AppliedFilterModel> value) async {
              // print('Applied filer - ${value.map((e) => e.toMap())}');
              Constants.debugLog(RecipesListScreen,
                  "Applied filer:${value.map((e) => e.toMap())}");
              BlocProvider.of<RecipesFullListCubit>(context)
                  .applyFilter(fliter: value);
            },
            filters: [
              FilterListModel(
                filterOptions: context
                        .read<RecipesFullListCubit>()
                        .servingsFilterOptionsList ??
                    [],
                previousApplied: _getPreviousAppliedFilters(
                    context.read<RecipesFullListCubit>().appliedFilterList,
                    'servings'),
                title: 'Servings',
                filterKey: 'servings',
              ),
              FilterListModel(
                filterOptions: context
                        .read<RecipesFullListCubit>()
                        .cuisineFilterOptionsList ??
                    [],
                previousApplied: _getPreviousAppliedFilters(
                    context.read<RecipesFullListCubit>().appliedFilterList,
                    'cuisine'),
                title: 'Cuisine',
                filterKey: 'cuisine',
              ),
              FilterListModel(
                filterOptions: context
                        .read<RecipesFullListCubit>()
                        .courseFilterOptionsList ??
                    [],
                previousApplied: _getPreviousAppliedFilters(
                    context.read<RecipesFullListCubit>().appliedFilterList,
                    'course'),
                title: 'Course',
                filterKey: 'course',
              ),
              FilterListModel(
                filterOptions: context
                        .read<RecipesFullListCubit>()
                        .dietFilterOptionsList ??
                    [],
                previousApplied: _getPreviousAppliedFilters(
                    context.read<RecipesFullListCubit>().appliedFilterList,
                    'diet'),
                title: 'Diet',
                filterKey: 'diet',
              ),
            ],
          ),
        );
      },
    );
  }

  List<FilterItemModel> _getPreviousAppliedFilters(
      List<AppliedFilterModel>? appliedFilterList, String filterKey) {
    if (appliedFilterList == null || appliedFilterList.isEmpty) {
      return [];
    } else {
      AppliedFilterModel? previousFilter = appliedFilterList?.firstWhere(
        (element) => element.filterKey == filterKey,
      );

      if (previousFilter == null) {
        return [];
      } else {
        return previousFilter.applied;
      }
    }
  }
}
