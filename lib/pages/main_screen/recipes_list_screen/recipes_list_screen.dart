import 'package:coozy_cafe/AppLocalization.dart';
import 'package:coozy_cafe/bloc/bloc.dart';
import 'package:coozy_cafe/model/recipe_model.dart';
import 'package:coozy_cafe/pages/pages.dart';
import 'package:coozy_cafe/repositories/components/restaurant_repository.dart';
import 'package:coozy_cafe/utlis/utlis.dart';
import 'package:coozy_cafe/widgets/pager/src/pager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../../widgets/fliter_system_widget/filter_system.dart';

class RecipesListScreen extends StatefulWidget {
  const RecipesListScreen({Key? key}) : super(key: key);

  @override
  _RecipesListScreenState createState() => _RecipesListScreenState();
}

class _RecipesListScreenState extends State<RecipesListScreen> {
  TextEditingController _searchController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: "");
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
            actions: [
              IconButton(
                  tooltip: "Bookmarks",
                  onPressed: () async {
                    List<RecipeModel>? data;
                    try {
                      data =
                          await RestaurantRepository().getBookmarkedRecipes();
                    } catch (e) {
                      print(e);
                      return;
                    }
                    if (data == null || data.isEmpty) {
                      Constants.showToastMsg(
                          msg: "Please select recipes to bookmark");
                    } else {
                      await navigationRoutes
                          .navigateToRecipesBookmarkListScreen(data)
                          .then((value) {
                        setState(() {});
                      });
                    }
                    // await navigationRoutes
                    //     .navigateToRecipesBookmarkListScreen(data)
                    //     .then((value) {
                    //   setState(() {});
                    // });
                  },
                  icon: Icon(MdiIcons.bookmarkMultiple)),
            ],
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0, right: 10, top: 5, bottom: 5),
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Recipe name',
                                  contentPadding: EdgeInsets.zero,
                                  prefixIcon: const Icon(Icons.search),
                                  suffixIcon: _searchController.text.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: () {
                                            _searchController.clear();
                                            BlocProvider.of<
                                                        RecipesFullListCubit>(
                                                    context)
                                                .searchRecipes('');
                                          },
                                        )
                                      : null,
                                ),
                                onChanged: (value) => setState(() {}),
                                onSubmitted: (value) async =>
                                    BlocProvider.of<RecipesFullListCubit>(
                                            context)
                                        .searchRecipes(value),
                              ),
                            ),
                          ),
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
                        visible: state.isInternalLoading == null ||
                                state.isInternalLoading == false
                            ? true
                            : false,
                        replacement: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(child: LoadingPage()),
                          ],
                        ),
                        child: Visibility(
                          visible: (state.totalPages == null ||
                                  state.totalPages == 0)
                              ? false
                              : true,
                          replacement: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  MenuIcons.recipe,
                                  size: 120,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          AppLocalizations.of(context)
                                                  ?.translate(StringValue
                                                      .recipes_list_screen_no_data_title_msg) ??
                                              "No data founded",
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          AppLocalizations.of(context)
                                                  ?.translate(StringValue
                                                      .recipes_list_screen_no_data_sub_title_msg) ??
                                              "Please try again with different filter choices to pick from.",
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          child: Scrollbar(
                            thumbVisibility: true,
                            interactive: true,
                            radius: const Radius.circular(10.0),
                            child: CustomScrollView(
                              physics: const ClampingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics(),
                              ),
                              shrinkWrap: true,
                              slivers: [
                                SliverList(
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
                              ],
                            ),
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
                                  : state.currentPage!,
                              totalPages: state.totalPages == null
                                  ? 1
                                  : state.totalPages!,
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
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: () async {
            Constants.debugLog(RecipesListScreen, model.toString());
            navigationRoutes.navigateToRecipesInfoScreen(model);
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                /*  Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: CircleAvatar(child: Text("${(state.startIndex??0 )+ index+1}"),),
                ),*/
                Expanded(
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
                                      .bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.w700)),
                            )
                          ],
                        ),
                      ),
                      Visibility(
                        visible: (model.recipeName == null ||
                                model.recipeName!.isEmpty)
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
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                              )
                            ],
                          ),
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
                                  text: 'Servings: ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontWeight: FontWeight.w700),
                                  children: [
                                    TextSpan(
                                        text: model.recipeServings.toString() ??
                                            "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Total cooking time: ',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w700),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${model.recipeTotalTimeInMins ?? 0} mins',
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
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Cooking time: ',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w700),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${model.recipeCookingTimeInMins ?? 0} mins',
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
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Preparation time: ',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w700),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${model.recipePreparationTimeInMins ?? 0} mins',
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
                          )
                        ],
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!),
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!),
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
                IconButton(
                    onPressed: () async {
                      setState(() {
                        BlocProvider.of<RecipesFullListCubit>(context)
                            .updateBookmark(
                                model: model,
                                context: context,
                                currentIndex: index);
                      });
                    },
                    icon: Icon(model.isBookmark == true
                        ? Icons.bookmark
                        : Icons.bookmark_outline)),
              ],
            ),
          ),
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
                type: FilterType.RadioGroup,
                filterOptions: context
                        .read<RecipesFullListCubit>()
                        .servingsFilterOptionsList ??
                    [],
                previousApplied: _getPreviousAppliedFilters(
                    context.read<RecipesFullListCubit>().appliedFilterList,
                    'servings'),
                title: 'Servings',
                filterKey: 'servings',
                backgroundColor: Theme.of(context).colorScheme.background,
              ),
              FilterListModel(
                type: FilterType.CheckboxList,
                filterOptions: context
                        .read<RecipesFullListCubit>()
                        .cuisineFilterOptionsList ??
                    [],
                previousApplied: _getPreviousAppliedFilters(
                    context.read<RecipesFullListCubit>().appliedFilterList,
                    'cuisine'),
                title: 'Cuisine',
                filterKey: 'cuisine',
                backgroundColor: Theme.of(context).colorScheme.background,
              ),
              FilterListModel(
                type: FilterType.CheckboxList,
                filterOptions: context
                        .read<RecipesFullListCubit>()
                        .courseFilterOptionsList ??
                    [],
                previousApplied: _getPreviousAppliedFilters(
                    context.read<RecipesFullListCubit>().appliedFilterList,
                    'course'),
                title: 'Course',
                filterKey: 'course',
                backgroundColor: Theme.of(context).colorScheme.background,
              ),
              FilterListModel(
                type: FilterType.RadioGroup,
                filterOptions: context
                        .read<RecipesFullListCubit>()
                        .dietFilterOptionsList ??
                    [],
                previousApplied: _getPreviousAppliedFilters(
                    context.read<RecipesFullListCubit>().appliedFilterList,
                    'diet'),
                title: 'Diet',
                filterKey: 'diet',
                backgroundColor: Theme.of(context).colorScheme.background,
              ),
              FilterListModel(
                type: FilterType.RangeSlider,
                filterOptions: context
                        .read<RecipesFullListCubit>()
                        .totalCookingTimeFilterOptionsList ??
                    [],
                previousApplied: _getPreviousAppliedFilters(
                    context.read<RecipesFullListCubit>().appliedFilterList,
                    'total_cooking_time'),
                title: 'Total cooking time',
                filterKey: 'total_cooking_time',
                backgroundColor: Theme.of(context).colorScheme.background,
                sliderTileThemeProps: SliderTileThemeProps(
                    label_suffix_str: "mins",
                    tooltip_suffix_str: "mins",
                    stepSize: 1,
                    fractionDigits: 0),
              ),
              FilterListModel(
                type: FilterType.Slider,
                filterOptions: context
                        .read<RecipesFullListCubit>()
                        .cookingTimeFilterOptionsList ??
                    [],
                previousApplied: _getPreviousAppliedFilters(
                    context.read<RecipesFullListCubit>().appliedFilterList,
                    'cooking_time'),
                title: 'Cooking Time',
                filterKey: 'cooking_time',
                backgroundColor: Theme.of(context).colorScheme.background,
                sliderTileThemeProps: SliderTileThemeProps(
                    label_suffix_str: "mins",
                    tooltip_suffix_str: "mins",
                    sliderThemeData: SfRangeSliderThemeData(),
                    stepSize: 1,
                    fractionDigits: 0),
              ),
              FilterListModel(
                  type: FilterType.DatePicker,
                  filterOptions: [],
                  previousApplied: [],
                  title: 'Date',
                  filterKey: 'date_time',
                  backgroundColor: Theme.of(context).colorScheme.background,
                  datePickerDateOrder: DatePickerDateOrder.dmy,
                  initialDate: DateUtil.dateToString(
                      DateTime.now(), DateUtil.DATE_FORMAT9),
                  inputDateFormat: DateFormat(DateUtil.DATE_FORMAT9),
                  minimumDate: DateUtil.simpleDateFormatChanger(
                      DateTime.now(), DateUtil.DATE_FORMAT9),
                  maximumDate: DateUtil.simpleDateFormatChanger(
                      DateTime(DateTime.now().year + 100, 31, 24),
                      DateUtil.DATE_FORMAT9),
                  labelText: "Date Picker",
                  hintText: "Please Enter date"),
              FilterListModel(
                  type: FilterType.TimePicker,
                  filterOptions: [],
                  previousApplied: [],
                  title: 'Time',
                  filterKey: 'time',
                  backgroundColor: Theme.of(context).colorScheme.background,
                  initialDate: DateUtil.dateToString(
                      DateTime.now(), DateUtil.TIME_FORMAT1),
                  inputDateFormat: DateFormat(DateUtil.TIME_FORMAT1),
                  labelText: "Time Picker",
                  hintText: "Please Enter time"),
              FilterListModel(
                  type: FilterType.RangeDatePicker,
                  filterOptions: [],
                  previousApplied: [],
                  title: 'RangeDate',
                  filterKey: 'range_date',
                  helpText: "Please select date",
                  backgroundColor: Theme.of(context).colorScheme.background,
                  initialDate: DateUtil.dateToString(
                      DateTime.now(), DateUtil.DATE_FORMAT9),
                  inputDateFormat: DateFormat(DateUtil.DATE_FORMAT9),
                  labelText: "Date Range Picker",
                  hintText: "Please enter date"),
              FilterListModel(
                  type: FilterType.RangeTimePicker,
                  filterOptions: [],
                  previousApplied: [],
                  title: 'Range Time',
                  filterKey: 'range_time',
                  helpText: "Please select time",
                  backgroundColor: Theme.of(context).colorScheme.background,
                  initialDate: DateUtil.dateToString(
                      DateTime.now(), DateUtil.TIME_FORMAT1),
                  inputDateFormat: DateFormat(DateUtil.TIME_FORMAT1),
                  labelText: "Time Range Picker",
                  hintText: "Please enter time"),
            ],
            themeProps: ThemeProps(
              activeFilterTextColor:
                  Theme.of(context).textTheme.bodyLarge!.color,
              dividerColor: Theme.of(context).dividerColor,
              inActiveFilterItemBackgroundColor:
                  Theme.of(context).colorScheme.secondaryContainer,
              inActiveFilterTextColor:
                  Theme.of(context).textTheme.bodyLarge!.color,
              submitButtonColor: Theme.of(context).colorScheme.secondary,
              resetButtonColor: Theme.of(context).colorScheme.secondary,
            ),
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
      AppliedFilterModel? previousFilter = appliedFilterList.firstWhere(
        (element) => element.filterKey == filterKey,
        orElse: null,
      );

      if (previousFilter == null) {
        return [];
      } else {
        return previousFilter.applied;
      }
    }
  }
}
