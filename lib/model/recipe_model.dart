// To parse this JSON data, do
//
//     final recipeModel = recipeModelFromJson(jsonString);

import 'dart:convert';

import 'package:coozy_the_cafe/widgets/widgets.dart';

List<RecipeModel> recipeModelFromJson(String str) => List<RecipeModel>.from(
    json.decode(str).map((x) => RecipeModel.fromJson(x)));

String recipeModelToJson(List<RecipeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RecipeModel extends ISuspensionBean {
  int? recipeID;
  int? id;
  String? recipeName;
  String? translatedRecipeName;
  String? recipeIngredients;
  String? recipeTranslatedIngredients;
  int? recipePreparationTimeInMins;
  int? recipeCookingTimeInMins;
  int? recipeTotalTimeInMins;
  int? recipeServings;
  String? recipeCuisine;
  String? recipeCourse;
  String? recipeDiet;
  String? recipeInstructions;
  String? recipeTranslatedInstructions;
  String? recipeReferenceUrl;

  bool? isBookmark;

  RecipeModel({
    this.recipeID,
    this.id,
    this.recipeName,
    this.translatedRecipeName,
    this.recipeIngredients,
    this.recipeTranslatedIngredients,
    this.recipePreparationTimeInMins,
    this.recipeCookingTimeInMins,
    this.recipeTotalTimeInMins,
    this.recipeServings,
    this.recipeCuisine,
    this.recipeCourse,
    this.recipeDiet,
    this.recipeInstructions,
    this.recipeTranslatedInstructions,
    this.recipeReferenceUrl,
    this.isBookmark,
  });

  RecipeModel copyWith({
    int? recipeID,
    int? id,
    String? recipeName,
    String? translatedRecipeName,
    String? recipeIngredients,
    String? recipeTranslatedIngredients,
    int? recipePreparationTimeInMins,
    int? recipeCookingTimeInMins,
    int? recipeTotalTimeInMins,
    int? recipeServings,
    String? recipeCuisine,
    String? recipeCourse,
    String? recipeDiet,
    String? recipeInstructions,
    String? recipeTranslatedInstructions,
    String? recipeReferenceUrl,
    bool? isBookmark,
  }) =>
      RecipeModel(
        recipeID: recipeID ?? this.recipeID,
        id: id ?? this.id,
        recipeName: recipeName ?? this.recipeName,
        translatedRecipeName: translatedRecipeName ?? this.translatedRecipeName,
        recipeIngredients: recipeIngredients ?? this.recipeIngredients,
        recipeTranslatedIngredients:
            recipeTranslatedIngredients ?? this.recipeTranslatedIngredients,
        recipePreparationTimeInMins:
            recipePreparationTimeInMins ?? this.recipePreparationTimeInMins,
        recipeCookingTimeInMins:
            recipeCookingTimeInMins ?? this.recipeCookingTimeInMins,
        recipeTotalTimeInMins:
            recipeTotalTimeInMins ?? this.recipeTotalTimeInMins,
        recipeServings: recipeServings ?? this.recipeServings,
        recipeCuisine: recipeCuisine ?? this.recipeCuisine,
        recipeCourse: recipeCourse ?? this.recipeCourse,
        recipeDiet: recipeDiet ?? this.recipeDiet,
        recipeInstructions: recipeInstructions ?? this.recipeInstructions,
        recipeTranslatedInstructions:
            recipeTranslatedInstructions ?? this.recipeTranslatedInstructions,
        recipeReferenceUrl: recipeReferenceUrl ?? this.recipeReferenceUrl,
        isBookmark: isBookmark ?? this.isBookmark,
      );

  factory RecipeModel.fromJson(Map<String, dynamic> json) => RecipeModel(
        recipeID: json["recipe_id"] == null ? null : json["recipe_id"],
        id: json["id"],
        recipeName: json["recipe_name"],
        translatedRecipeName: json["translated_recipe_name"],
        recipeIngredients: json["recipe_ingredients"],
        recipeTranslatedIngredients: json["recipe_translated_ingredients"],
        recipePreparationTimeInMins: json["recipe_preparation_time_in_mins"],
        recipeCookingTimeInMins: json["recipe_cooking_time_in_mins"],
        recipeTotalTimeInMins: json["recipe_total_time_in_mins"],
        recipeServings: json["recipe_servings"],
        recipeCuisine: json["recipe_cuisine"],
        recipeCourse: json["recipe_course"],
        recipeDiet: json["recipe_diet"],
        recipeInstructions: json["recipe_instructions"],
        recipeTranslatedInstructions: json["recipe_translated_instructions"],
        recipeReferenceUrl: json["recipe_reference_url"],
        isBookmark:
            json["isBookmark"] == null ? false : json["isBookmark"] == 1,
      );

  Map<String, dynamic> toJson() => {
        "recipe_id": recipeID,
        "id": id,
        "recipe_name": recipeName,
        "translated_recipe_name": translatedRecipeName,
        "recipe_ingredients": recipeIngredients,
        "recipe_translated_ingredients": recipeTranslatedIngredients,
        "recipe_preparation_time_in_mins": recipePreparationTimeInMins,
        "recipe_cooking_time_in_mins": recipeCookingTimeInMins,
        "recipe_total_time_in_mins": recipeTotalTimeInMins,
        "recipe_servings": recipeServings,
        "recipe_cuisine": recipeCuisine,
        "recipe_course": recipeCourse,
        "recipe_diet": recipeDiet,
        "recipe_instructions": recipeInstructions,
        "recipe_translated_instructions": recipeTranslatedInstructions,
        "recipe_reference_url": recipeReferenceUrl,
        "isBookmark": isBookmark == true ? 1 : 0,
      }..removeWhere((key, value) => value == null);

  @override
  String toString() {
    return 'RecipeModel{recipe_id: $recipeID,id: $id, recipeName: $recipeName, translatedRecipeName: $translatedRecipeName, recipeIngredients: $recipeIngredients, recipeTranslatedIngredients: $recipeTranslatedIngredients, recipePreparationTimeInMins: $recipePreparationTimeInMins, recipeCookingTimeInMins: $recipeCookingTimeInMins, recipeTotalTimeInMins: $recipeTotalTimeInMins, recipeServings: $recipeServings, recipeCuisine: $recipeCuisine, recipeCourse: $recipeCourse, recipeDiet: $recipeDiet, recipeInstructions: $recipeInstructions, recipeTranslatedInstructions: $recipeTranslatedInstructions, recipeReferenceUrl: $recipeReferenceUrl}';
  }

  @override
  String getSuspensionTag() {
    return translatedRecipeName != null && translatedRecipeName!.isNotEmpty
        ? translatedRecipeName![0].toUpperCase()
        : '';
  }
}
