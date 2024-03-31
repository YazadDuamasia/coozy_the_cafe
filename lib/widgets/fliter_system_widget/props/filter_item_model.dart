import 'package:equatable/equatable.dart';

class FilterItemModel extends Equatable {
  final String filterTitle;
  var filterKey;

  // Initialize the Filter Item Model with Title and Key as required parameters
   FilterItemModel({
    required this.filterTitle,
    required this.filterKey,
  });

  @override
  List<Object?> get props => [
        filterTitle,
        filterKey,
      ];

  // Convert the Filter Item Model into a Map format with the corresponding data in it.
  Map<String, dynamic> toMap() {
    return ({
      'filter_title': filterTitle,
      'filter_key': filterKey,
    });
  }
}
