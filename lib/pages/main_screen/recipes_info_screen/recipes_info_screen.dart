import 'dart:io';

import 'package:coozy_cafe/model/recipe_model.dart';
import 'package:coozy_cafe/model/translator_language/translator_language.dart';
import 'package:coozy_cafe/utlis/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipesInfoScreen extends StatefulWidget {
  RecipeModel? model;

  RecipesInfoScreen({Key? key, required this.model}) : super(key: key);

  @override
  _RecipesInfoScreenState createState() => _RecipesInfoScreenState();
}

class _RecipesInfoScreenState extends State<RecipesInfoScreen> {
  Size? size;
  Orientation? orientation;

  List<bool> isIngredientsEnglishTranslationSelection = [true, false, false];
  List<bool> isInstructionEnglishTranslationSelection = [true, false, false];
  StringBuffer? ingredientsInfoString;
  StringBuffer? instructionInfoString;

  final translator = GoogleTranslator();
  TranslatorLanguageModel? ingredientSelectedLanguage;
  TranslatorLanguageModel? instructionSelectedLanguage;

  @override
  void initState() {
    super.initState();
    ingredientsInfoString = StringBuffer("");
    ingredientsInfoString
        ?.write(widget.model?.recipeTranslatedIngredients ?? "");
    Constants.debugLog(RecipesInfoScreen, "Ingredients:$ingredientsInfoString");
    ingredientSelectedLanguage = TranslatorLanguageModel(
      name: "Hindi",
      code2: "hi",
    );

    instructionInfoString = StringBuffer("");
    instructionInfoString
        ?.write(widget.model?.recipeTranslatedInstructions ?? "");
    Constants.debugLog(
        RecipesInfoScreen, "Instructions:$instructionInfoString");
    instructionSelectedLanguage = TranslatorLanguageModel(
      name: "Hindi",
      code2: "hi",
    );
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    orientation = MediaQuery.of(context).orientation;
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
              " Recipes Details",
            ),
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
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
                                text: 'Title: ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              TextSpan(
                                text: '${widget.model?.recipeName ?? ""}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
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
                                text: 'Translated title: ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              TextSpan(
                                text:
                                    '${widget.model?.translatedRecipeName ?? ""}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
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
                                text: 'Servings: ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              TextSpan(
                                text: '${widget.model?.recipeServings ?? 0}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
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
                                text: 'Total cooking time: ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              TextSpan(
                                text:
                                    '${widget.model?.recipeTotalTimeInMins ?? 0} mins',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
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
                                text: 'Cooking time: ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              TextSpan(
                                text:
                                    '${widget.model?.recipeCookingTimeInMins ?? 0} mins',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
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
                                text: 'Preparation time: ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              TextSpan(
                                text:
                                    '${widget.model?.recipePreparationTimeInMins ?? 0} mins',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
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
                                text: 'Cuisine: ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              TextSpan(
                                text: '${widget.model?.recipeCuisine ?? ""}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
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
                                text: 'Course: ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              TextSpan(
                                text: '${widget.model?.recipeCourse ?? 0}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
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
                                text: 'Diet: ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              TextSpan(
                                text: '${widget.model?.recipeDiet ?? ""}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  elevation: 5,
                  margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(Icons.link),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Reference link:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w700),
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
                                    child: TextButton(
                                      onPressed: () async {
                                        String? url =
                                            widget.model?.recipeReferenceUrl;
                                        if (url != null && url.isNotEmpty) {
                                          if (!await launchUrl(
                                              Uri.parse(url ?? ""))) {
                                            throw Exception(
                                                'Could not launch $url');
                                          }
                                        }
                                      },
                                      child: Text(
                                        '${widget.model?.recipeReferenceUrl ?? ""}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: Colors.blue),
                                      ),
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              /*         TextSpan(
                                text:
                                    '${widget.model?.recipeReferenceUrl ?? ""}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    // Handle the click event here, for example, open the URL
                                    String? url =
                                        widget.model?.recipeReferenceUrl;
                                    if (url != null && url.isNotEmpty) {
                                      if (!await launchUrl(
                                          Uri.parse(url ?? ""))) {
                                        throw Exception(
                                            'Could not launch $url');
                                      }
                                    }
                                  },
                              ),*/
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ingredientsWidget(),
                cookingInstructionsWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget cookingInstructionsWidget() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Text("Cooking Instructions: ",
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                ],
              ),
            ),
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(
                    height: 1,
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
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return ToggleButtons(
                                renderBorder: false,
                                constraints: BoxConstraints.expand(
                                    width: constraints.maxWidth / 3),
                                borderRadius: BorderRadius.circular(5),
                                isSelected:
                                    isInstructionEnglishTranslationSelection,
                                onPressed: (int index) async {
                                  for (int i = 0;
                                      i <
                                          isInstructionEnglishTranslationSelection
                                              .length;
                                      i++) {
                                    if (i == index) {
                                      isInstructionEnglishTranslationSelection[
                                          i] = (i == index) ? true : false;
                                      if (i == 0) {
                                        instructionInfoString!.clear();
                                        instructionInfoString?.write(widget
                                                .model
                                                ?.recipeTranslatedInstructions ??
                                            "");
                                      } else if (i == 1) {
                                        instructionInfoString!.clear();
                                        instructionInfoString?.write(
                                            widget.model?.recipeInstructions ??
                                                "");
                                      } else if (i == 2) {
                                        instructionInfoString?.clear();
                                        _translateInstructions("en",
                                            ingredientSelectedLanguage!.code2);
                                      }
                                    } else {
                                      isInstructionEnglishTranslationSelection[
                                          i] = false;
                                    }
                                  }

                                  setState(() {});
                                },
                                children: const <Widget>[
                                  Text(
                                    'English',
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'Offline Translation',
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'Other Language',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    height: 1,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  instructionsInfoWidget(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    /*
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Text("Cooking Instructions: ",
                      style: Theme.of(context).textTheme.titleMedium),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(
            height: 1,
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
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return ToggleButtons(
                        renderBorder: false,
                        constraints: BoxConstraints.expand(
                            width: constraints.maxWidth / 3),
                        borderRadius: BorderRadius.circular(5),
                        isSelected: isInstructionEnglishTranslationSelection,
                        onPressed: (int index) async {
                                  for (int i = 0;
                                      i <
                                          isInstructionEnglishTranslationSelection
                                              .length;
                                      i++) {
                                    if (i == index) {
                                      isInstructionEnglishTranslationSelection[
                                          i] = (i == index) ? true : false;
                                      if (i == 0) {
                                        instructionInfoString!.clear();
                                        instructionInfoString?.write(widget.model
                                                ?.recipeTranslatedInstructions ??
                                            "");
                                      } else if (i == 1) {
                                        instructionInfoString!.clear();
                                        instructionInfoString?.write(
                                            widget.model?.recipeInstructions ??
                                                "");
                                      } else if (i == 2) {
                                        instructionInfoString?.clear();
                                        _translateInstructions("en",
                                            ingredientSelectedLanguage!.code2);
                                      }
                                    } else {
                                      isInstructionEnglishTranslationSelection[
                                          i] = false;
                                    }
                                  }

                                  setState(() {});
                                },
                        children: const <Widget>[
                          Text(
                            'English',
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Offline Translation',
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Other Language',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(
            height: 1,
          ),
          const SizedBox(
            height: 5,
          ),
          instructionsInfoWidget(),
        ],
      ),
    );*/
  }

  Widget ingredientsWidget() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Text("Ingredients:",
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                ],
              ),
            ),
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(
                    height: 1,
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
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return ToggleButtons(
                                renderBorder: false,
                                constraints: BoxConstraints.expand(
                                    width: constraints.maxWidth / 3),
                                borderRadius: BorderRadius.circular(5),
                                isSelected:
                                    isIngredientsEnglishTranslationSelection,
                                onPressed: (int index) async {
                                  for (int i = 0;
                                      i <
                                          isIngredientsEnglishTranslationSelection
                                              .length;
                                      i++) {
                                    if (i == index) {
                                      isIngredientsEnglishTranslationSelection[
                                          i] = (i == index) ? true : false;
                                      if (i == 0) {
                                        setState(() {
                                          ingredientsInfoString!.clear();
                                          ingredientsInfoString?.write(widget
                                                  .model
                                                  ?.recipeTranslatedIngredients ??
                                              "");
                                          Constants.debugLog(RecipesInfoScreen,
                                              "Ingredients:0:$ingredientsInfoString");
                                        });
                                      } else if (i == 1) {
                                        setState(() {
                                          ingredientsInfoString!.clear();
                                          ingredientsInfoString?.write(
                                              widget.model?.recipeIngredients ??
                                                  "");
                                          Constants.debugLog(RecipesInfoScreen,
                                              "Ingredients:1:${ingredientsInfoString!}");
                                        });
                                      } else if (i == 2) {
                                        setState(() {
                                          ingredientsInfoString!.clear();
                                          _translateIngredients(
                                              "en",
                                              ingredientSelectedLanguage!
                                                  .code2);
                                        });
                                      }
                                    } else {
                                      isIngredientsEnglishTranslationSelection[
                                          i] = false;
                                    }
                                  }

                                  setState(() {});
                                },
                                children: const <Widget>[
                                  Text(
                                    'English',
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'Offline Translation',
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'Other Language',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    height: 1,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ingredientsInfoWidget(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    /*
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Text("Ingredients: ",
                      style: Theme.of(context).textTheme.titleMedium),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(
            height: 1,
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
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return ToggleButtons(
                        renderBorder: false,
                        constraints: BoxConstraints.expand(
                            width: constraints.maxWidth / 3),
                        borderRadius: BorderRadius.circular(5),
                        isSelected: isIngredientsEnglishTranslationSelection,
                        onPressed: (int index) async {
                          for (int i = 0;
                              i <
                                  isIngredientsEnglishTranslationSelection
                                      .length;
                              i++) {
                            if (i == index) {
                              isIngredientsEnglishTranslationSelection[i] =
                                  (i == index) ? true : false;
                              if (i == 0) {
                                setState(() {
                                  ingredientsInfoString!.clear();
                                  ingredientsInfoString?.write(widget
                                          .model?.recipeTranslatedIngredients ??
                                      "");
                                });
                              } else if (i == 1) {
                                setState(() {
                                  ingredientsInfoString!.clear();
                                  ingredientsInfoString?.write(
                                      widget.model?.recipeIngredients ?? "");
                                });
                              } else if (i == 2) {
                                setState(() {
                                  ingredientsInfoString!.clear();
                                  _translateIngredients(
                                      "en", ingredientSelectedLanguage!.code2);
                                });
                              }
                            } else {
                              isIngredientsEnglishTranslationSelection[i] =
                                  false;
                            }
                          }

                          setState(() {});
                        },
                        children: const <Widget>[
                          Text(
                            'English',
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Offline Translation',
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Other Language',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(
            height: 1,
          ),
          const SizedBox(
            height: 5,
          ),
          ingredientsInfoWidget(),
        ],
      ),
    );
    */
  }

  void _translateIngredients(String? fromLanguage, String? toLanguage) async {
    try {
      Constants.showLoadingDialog(context);
      await translator
          .translate(widget.model?.recipeTranslatedIngredients ?? "",
              from: fromLanguage ?? "auto", to: toLanguage!)
          .then((value) {
        Navigator.pop(context);
        setState(() {
          ingredientsInfoString!.clear();
          ingredientsInfoString?.write(value.text ?? "");
        });
      });
    } on SocketException catch (e) {
      Navigator.pop(context);
      SnackBar mySnackbar = const SnackBar(
        content: Text('Internet not Connected'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(mySnackbar);
      setState(() {});
    } catch (e) {
      Navigator.pop(context);
      SnackBar mySnackbar = const SnackBar(
        content: Text('Failed to translate content. Please try again'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(mySnackbar);
      setState(() {});
    }
  }

  Widget ingredientsInfoWidget() {
    bool? isTranslateEnable = false;
    for (int i = 0; i < isIngredientsEnglishTranslationSelection.length; i++) {
      if (isIngredientsEnglishTranslationSelection[i] && i != 0) {
        isTranslateEnable = true;
      } else {
        isTranslateEnable = false;
      }
    }
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
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
                child: Text(ingredientsInfoString!.toString()),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Visibility(
            visible: isTranslateEnable!,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: TextButton.icon(
                    onPressed: () async {
                      _showIngredientLanguageSelectionBottomSheet(context);
                    },
                    icon: const Icon(Icons.translate),
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Expanded(
                          child: Text("translate"),
                        ),
                        const Text("-"),
                        Expanded(
                          child: Text(
                            "${ingredientSelectedLanguage?.name ?? ""}",
                            textAlign: TextAlign.center,
                          ),
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
    );
  }

  Widget instructionsInfoWidget() {
    bool? isTranslateEnable = false;
    for (int i = 0; i < isInstructionEnglishTranslationSelection.length; i++) {
      if (isInstructionEnglishTranslationSelection[i] && i != 0) {
        isTranslateEnable = true;
      } else {
        isTranslateEnable = false;
      }
    }
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 0),
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
                child: Text(instructionInfoString!.toString()),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Visibility(
            visible: isTranslateEnable!,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: TextButton.icon(
                    onPressed: () async {
                      _showInstructiontLanguageSelectionBottomSheet(context);
                    },
                    icon: const Icon(Icons.translate),
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Expanded(
                          child: Text("translate"),
                        ),
                        const Text("-"),
                        Expanded(
                          child: Text(
                            "${instructionSelectedLanguage?.name ?? ""}",
                            textAlign: TextAlign.center,
                          ),
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
    );
  }

  void _showIngredientLanguageSelectionBottomSheet(BuildContext context) {
    List<TranslatorLanguageModel> filteredLanguages = List.from(Constants.languages);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Language',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        filteredLanguages = Constants.languages
                            .where((lang) => lang.name
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredLanguages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(filteredLanguages[index].name),
                          onTap: () {
                            Navigator.pop(context, filteredLanguages[index]);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((selectedLanguage) {
      if (selectedLanguage != null) {
        setState(() {
          ingredientSelectedLanguage = selectedLanguage;
        });
        _translateIngredients("en", ingredientSelectedLanguage!.code2);
      }
    });
  }

  void _showInstructiontLanguageSelectionBottomSheet(BuildContext context) {
    List<TranslatorLanguageModel> filteredLanguages =
        List.from(Constants.languages);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Language',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        filteredLanguages = Constants.languages
                            .where((lang) => lang.name
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredLanguages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(filteredLanguages[index].name),
                          onTap: () {
                            Navigator.pop(context, filteredLanguages[index]);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((selectedLanguage) {
      if (selectedLanguage != null) {
        setState(() {
          ingredientSelectedLanguage = selectedLanguage;
        });
        _translateInstructions("en", ingredientSelectedLanguage!.code2);
      }
    });
  }

  void _translateInstructions(String? fromLanguage, String? toLanguage) async {
    try {
      Constants.showLoadingDialog(context);
      await translator
          .translate(widget.model?.recipeTranslatedInstructions ?? "",
              from: fromLanguage ?? "auto", to: toLanguage!)
          .then((value) {
        Navigator.pop(context);
        setState(() {
          instructionInfoString!.clear();
          instructionInfoString?.write(value.text ?? "");
        });
      });
    } on SocketException catch (e) {
      Navigator.pop(context);
      SnackBar mySnackbar = const SnackBar(
        content: Text('Internet not Connected'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(mySnackbar);
      setState(() {});
    } catch (e) {
      Navigator.pop(context);
      SnackBar mySnackbar = const SnackBar(
        content: Text('Failed to translate content. Please try again'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(mySnackbar);
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
