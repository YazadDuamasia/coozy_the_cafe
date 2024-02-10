import 'dart:convert';

import 'package:coozy_cafe/model/category.dart';
import 'package:coozy_cafe/model/sub_category.dart';

//-------------------------------------------------------------------------------------------------------------------//

CommonScreenArgument addCommonScreenArgumentFromMap(String str) =>
    CommonScreenArgument.fromMap(json.decode(str));

String addCommonScreenArgumentToMap(CommonScreenArgument data) =>
    json.encode(data.toMap());

class CommonScreenArgument {
  CommonScreenArgument({
    required this.memberId,
  });

  var memberId;

  factory CommonScreenArgument.fromMap(Map<String, dynamic> json) =>
      CommonScreenArgument(
        memberId: json["memberId"],
      );

  Map<String, dynamic> toMap() => {
        "memberId": memberId,
      };

  static String addCommonArgument({memberId}) {
    Map<String, dynamic> map = {
      'memberId': memberId,
    };
    return json.encode(map);
  }
}

//-------------------------------------------------------------------------------------------------------------------//

UpdateMenuCategoryScreenArgument updateMenuCategoryScreenArgumentFromMap(String str) => UpdateMenuCategoryScreenArgument.fromMap(json.decode(str));

String updateMenuCategoryScreenArgumentToMap(UpdateMenuCategoryScreenArgument data) => json.encode(data.toMap());

class UpdateMenuCategoryScreenArgument {
  final Category? category;
  final List<SubCategory>? subCategoryList;

  UpdateMenuCategoryScreenArgument({
    required this.category,
    required this.subCategoryList,
  });

  factory UpdateMenuCategoryScreenArgument.fromMap(Map<String, dynamic> json) =>
      UpdateMenuCategoryScreenArgument(
        category: json['category'] != null
            ? Category.fromJson(json['category'])
            : null,
        subCategoryList:
            _convertDynamicListToSubCategoryList(json['subCategoryList']),
      );

  Map<String, dynamic> toMap() => {
        'category': category?.toJson(),
        'subCategoryList':
            _convertSubCategoryListToDynamicList(subCategoryList),
      };

  static String updateMenuCategoryScreenArgument(
      {Category? category, List<SubCategory>? subCategoryList}) {
    Map<String, dynamic> map = {
      'category': category==null?null:category.toJson(),
      'subCategoryList': _convertSubCategoryListToDynamicList(subCategoryList),
    };
    return json.encode(map);
  }

  // Private static methods visible only within the UpdateMenuCategoryScreenArgument class
  static List<SubCategory>? _convertDynamicListToSubCategoryList(
      List<dynamic>? dynamicList) {
    if (dynamicList == null) {
      return null;
    }
    return dynamicList.map((dynamicItem) {
      return SubCategory.fromJson(dynamicItem as Map<String, dynamic>);
    }).toList();
  }

  static List<dynamic>? _convertSubCategoryListToDynamicList(
      List<SubCategory>? subcategories) {
    if (subcategories == null) {
      return null;
    }
    return subcategories.map((subCategory) => subCategory?.toJson()).toList();
  }
}
