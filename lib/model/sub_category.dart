import 'package:coozy_the_cafe/widgets/widgets.dart';

class SubCategory extends ISuspensionBean {
  int? id;
  String? name;
  String? createdDate;
  int? categoryId;
  int? isActive;

  SubCategory(
      {this.id, this.name, this.createdDate, this.categoryId, this.isActive});

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'],
      name: json['name'],
      createdDate: json['createdDate'],
      categoryId: json['categoryId'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdDate': createdDate,
      'categoryId': categoryId,
      'isActive': isActive ?? 1
    }..removeWhere((key, value) => value == null);
  }

  SubCategory copyWith({
    int? id,
    String? name,
    String? createdDate,
    int? categoryId,
    int? isActive,
  }) {
    return SubCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      createdDate: createdDate ?? this.createdDate,
      categoryId: categoryId ?? this.categoryId,
      isActive: isActive ?? this.isActive ?? 1,
    );
  }

  static List<String?>? getSubCategoryNames(List<SubCategory?>? subcategories) {
    if (subcategories == null) {
      return null;
    } else {
      return subcategories
          .map((subcategory) => subcategory?.name ?? "")
          .toList();
    }
  }

  // Convert dynamic list to List<SubCategory>
  static List<SubCategory>? convertDynamicListToSubCategoryList(
      List<dynamic>? dynamicList) {
    if (dynamicList == null) {
      return null;
    }

    return dynamicList.map((dynamicItem) {
      return SubCategory.fromJson(dynamicItem as Map<String, dynamic>);
    }).toList();
  }

  @override
  String getSuspensionTag() {
    return name != null && name!.isNotEmpty ? name![0].toUpperCase() : '';
  }

  @override
  String toString() {
    return 'SubCategory{id: $id, name: $name, createdDate: $createdDate, categoryId: $categoryId, isActive: $isActive}';
  }
}
