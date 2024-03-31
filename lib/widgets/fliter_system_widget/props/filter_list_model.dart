import 'package:coozy_cafe/widgets/fliter_system_widget/props/filter_item_model.dart';
import 'package:equatable/equatable.dart';

/// Filter option model
class FilterListModel extends Equatable {
  final String? title;
  final String filterKey;
  final List<FilterItemModel> filterOptions;
  final List<FilterItemModel> previousApplied;

  const FilterListModel({
    this.title,
    required this.filterKey,
    required this.filterOptions,
    required this.previousApplied,
  });

  FilterListModel copyWith({
    List<FilterItemModel>? filterOptions,
    List<FilterItemModel>? previousApplied,
    String? title,
    String? filterKey,
  }) {
    return FilterListModel(
      title: title ?? this.title,
      filterKey: filterKey ?? this.filterKey,
      filterOptions: filterOptions ?? this.filterOptions,
      previousApplied: previousApplied ?? this.previousApplied,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        title,
        filterKey,
        filterOptions,
        previousApplied,
      ];

  Map<String, dynamic> toMap() {
    return ({
      'title': title,
      'filter_key': filterKey,
      'previous_applied': previousApplied.map((e) => e.toMap()).toList(),
      'filter_options': filterOptions.map((e) => e.toMap()).toList(),
    });
  }
}
