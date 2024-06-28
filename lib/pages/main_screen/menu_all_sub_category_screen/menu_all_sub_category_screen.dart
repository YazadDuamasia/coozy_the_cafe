import 'package:coozy_the_cafe/AppLocalization.dart';
import 'package:coozy_the_cafe/bloc/bloc.dart';
import 'package:coozy_the_cafe/model/category.dart';
import 'package:coozy_the_cafe/model/sub_category.dart';
import 'package:coozy_the_cafe/pages/main_screen/menu_all_sub_category_screen/menu_all_sub_category_update_dialog.dart';
import 'package:coozy_the_cafe/pages/pages.dart';
import 'package:coozy_the_cafe/utlis/utlis.dart';
import 'package:coozy_the_cafe/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MenuAllSubCategoryScreen extends StatefulWidget {
  @override
  _MenuAllSubCategoryScreenState createState() =>
      _MenuAllSubCategoryScreenState();
}

class _MenuAllSubCategoryScreenState extends State<MenuAllSubCategoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<MenuSubCategoryBloc>(context)
          .add(InitialLoadingDataEvent());
    });
  }

  @override
  void dispose() {
    context.read<MenuSubCategoryBloc>().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Subcategories'),
      ),
      body: BlocConsumer<MenuSubCategoryBloc, MenuSubCategoryState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is MenuSubCategoryLoadingState) {
            return const LoadingPage();
          } else if (state is MenuSubCategoryLoadedState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSearchField(context, state),
                Expanded(
                  child: _buildSubCategoryList(state),
                ),
              ],
            );
          } else if (state is MenuSubCategoryErrorState) {
            Constants.debugLog(MenuAllSubCategoryScreen,
                "MenuSubCategoryErrorState:error:${state.errorMessage}");
            return ErrorPage(
              onPressedRetryButton: () async {
                context
                    .read<MenuSubCategoryBloc>()
                    .add(InitialLoadingDataEvent());
              },
            );
          } else {
            return Container(); // Placeholder for other states
          }
        },
      ),
    );
  }

  _buildSearchField(BuildContext context, MenuSubCategoryState state) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                onChanged: (query) async {
                  context
                      .read<MenuSubCategoryBloc>()
                      .add(SearchSubCategoryEvent(query));
                },
                decoration: const InputDecoration(
                  hintText: 'Search Subcategories',
                  prefixIcon: Icon(Icons.search),
                ),
              )),
        ),
      ],
    );
  }

  Widget _buildSubCategoryList(MenuSubCategoryLoadedState state) {
    return Visibility(
      visible: state.subCategories != null && state.subCategories!.isNotEmpty,
      replacement: Visibility(
        visible: state.isSearchActive == true,
        replacement: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(MenuIcons.menu_empty_paceholder,
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
                        child: Text("No data has been inserted.",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                              "Please insert sub-category from menu category screen or you can add it from below button.",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
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
                          await handleNewCategory();
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
                        child: Text(AppLocalizations.of(context)?.translate(
                                StringValue.menu_category_add_new_category) ??
                            'Add new category'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(MenuIcons.check_list,
                      color: Theme.of(context).primaryColor, size: 100),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text("No data Found.",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      child: AzListView(
        data: state.subCategories ?? [],
        itemCount: state.subCategories?.length ?? 0,
        indexBarData: state.indexBarData ?? [],
        padding: const EdgeInsets.only(right: 40),
        physics: const ClampingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        indexBarOptions: IndexBarOptions(
          needRebuild: true,
          color: Colors.grey.shade300,
          downColor: Theme.of(context).primaryColor.withOpacity(0.5),
          indexHintWidth: 50.0,
        ),
        indexHintBuilder: (BuildContext context, String hint) {
          return Container(
            alignment: Alignment.center,
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Text(
              hint.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(color: Colors.white),
            ),
          );
        },
        itemBuilder: (context, index) {
          var subCategory = state.subCategories![index];
          Category? category;
          if (state.allCategory != null && state.allCategory!.isNotEmpty) {
            category = state.allCategory!
                .firstWhere((cat) => cat.id == subCategory.categoryId);
          } else {
            category = null;
          }

          return itemView(index, state, subCategory, context, category);
        },
      ),
    );
  }

  Widget itemView(int index, MenuSubCategoryLoadedState state,
      SubCategory subCategory, BuildContext context, Category? category) {
    return Card(
      elevation: 5,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      margin: EdgeInsets.only(
          bottom: index == ((state.subCategories?.length ?? 0) - 1) ? 0 : 10,
          left: 10,
          right: 0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text("${subCategory.name}",
                            style: Theme.of(context).textTheme.bodyLarge),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: 'Active Status: ',
                            style: Theme.of(context).textTheme.bodyMedium,
                            children: [
                              TextSpan(
                                text: subCategory.isActive==0
                                    ? 'Inactive'
                                    : 'Active',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: subCategory.isActive==0
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: category != null &&
                        category.name != null &&
                        category.name!.isNotEmpty,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            "${AppLocalizations.of(context)?.translate(StringValue.menu_sub_category_under_category)} ${category?.name ?? ""}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Material(
              shape: const CircleBorder(),
              color: Theme.of(context).colorScheme.primaryContainer,
              child: IconButton(
                icon: Icon(
                  MdiIcons.circleEditOutline,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () async {
                  await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return MenuAllSubCategoryUpdateDialog(
                        currentSubCategory: subCategory,
                        onUpdate: (newModel) async {
                          context.read<MenuSubCategoryBloc>().add(
                              EditSubCategoryEvent(newModel, index, context));
                        },
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> handleNewCategory() async {
    var res = await navigationRoutes.navigateToAddNewMenuCategoryScreen();
    context.read<MenuSubCategoryBloc>().add(InitialLoadingDataEvent());
  }
}
