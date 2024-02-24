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
  var categoryId;

  UpdateMenuCategoryScreenArgument({
    required this.categoryId,

  });

  factory UpdateMenuCategoryScreenArgument.fromMap(Map<String, dynamic> json) =>
      UpdateMenuCategoryScreenArgument(
        categoryId: json['categoryId'] != null?json['categoryId']:null
      );

  Map<String, dynamic> toMap() => {
        'categoryId': categoryId??null,

      };

  static String updateMenuCategoryScreenArgument(
      {categoryId}) {
    Map<String, dynamic> map = {
      'categoryId': categoryId,
    };
    return json.encode(map);
  }
}
