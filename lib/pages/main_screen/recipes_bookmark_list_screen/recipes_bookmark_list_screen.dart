import 'package:coozy_the_cafe/AppLocalization.dart';
import 'package:coozy_the_cafe/bloc/bloc.dart';
import 'package:coozy_the_cafe/bloc/recipes_bookmark_list_cubit/recipes_bookmark_list_cubit.dart';
import 'package:coozy_the_cafe/model/recipe_model.dart';
import 'package:coozy_the_cafe/pages/pages.dart';
import 'package:coozy_the_cafe/routing/configs/route_contants.dart';
import 'package:coozy_the_cafe/utlis/utlis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecipesBookmarkListScreen extends StatefulWidget {
  RecipesBookmarkListScreen({Key? key}) : super(key: key);

  @override
  _RecipesBookmarkListScreenState createState() =>
      _RecipesBookmarkListScreenState();
}

class _RecipesBookmarkListScreenState extends State<RecipesBookmarkListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<RecipesBookmarkListCubit>(context).loadData();
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
            title: const Text('Recipe Bookmarks'),
          ),
          body:
              BlocConsumer<RecipesBookmarkListCubit, RecipesBookmarkListState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              if (state is RecipesBookmarkListInitialState ||
                  state is RecipesBookmarkListLoadingState) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(child: LoadingPage()),
                  ],
                );
              } else if (state is RecipesBookmarkListLoadedState) {
                return Visibility(
                  visible: (state.data == null || state.data!.isEmpty)
                      ? false
                      : true,
                  replacement: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        MenuIcons.recipe_bookmark,
                        size: 120,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 0, left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "${AppLocalizations.of(context)!.translate(StringValue.recipes_bookmark_no_record_title)}",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "${AppLocalizations.of(context)!.translate(StringValue.recipes_bookmark_no_record_sub_title)}",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  child: Scrollbar(
                    thumbVisibility: true,
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
                            RecipeModel model = state.data![index];
                            return RepaintBoundary(
                              child: recipeItem(
                                model: model,
                                index: index,
                              ),
                            );
                          },
                              addSemanticIndexes: true,
                              addAutomaticKeepAlives: true,
                              addRepaintBoundaries: false,
                              childCount: state.data?.length ?? 0),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is RecipesBookmarkListErrorState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: ErrorPage(
                        onPressedRetryButton: () async {
                          setState(() {
                            BlocProvider.of<RecipesBookmarkListCubit>(context)
                                .loadData();
                          });
                        },
                      ),
                    ),
                  ],
                );
              } else if (state is RecipesBookmarkListNoInternetState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: NoInternetPage(
                        onPressedRetryButton: () async {
                          setState(() {
                            BlocProvider.of<RecipesBookmarkListCubit>(context)
                                .loadData();
                          });
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

  Widget recipeItem({required RecipeModel model, required int index}) {
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
            Constants.debugLog(RecipesBookmarkListScreen, model.toString());
            navigationRoutes.navigateToRecipesInfoScreen(model: model);
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
                                      .titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w600)),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        MenuIcons.total_cooking_time,
                                        size: 30,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                          "${model.recipeTotalTimeInMins ?? "0"} mins",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        MenuIcons.coooking_time,
                                        size: 30,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                          "${model.recipeCookingTimeInMins ?? "0"} mins",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge),
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
                      BlocProvider.of<RecipesBookmarkListCubit>(context)
                          .updateRecipe(
                              model.copyWith(isBookmark: !model.isBookmark!));
                    });
                  },
                  icon: Icon(
                    model.isBookmark == true
                        ? Icons.delete
                        : Icons.delete_outlined,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
