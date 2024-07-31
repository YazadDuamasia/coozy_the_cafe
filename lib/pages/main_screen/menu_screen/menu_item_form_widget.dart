import 'package:coozy_the_cafe/model/category.dart';
import 'package:coozy_the_cafe/model/menu_item.dart';
import 'package:coozy_the_cafe/model/sub_category.dart';
import 'package:coozy_the_cafe/repositories/components/restaurant_repository.dart';
import 'package:coozy_the_cafe/utlis/utlis.dart';
import 'package:flutter/material.dart';

class MenuItemForm extends StatefulWidget {
  final MenuItem? menuItem;
  final void Function(MenuItem) onSubmit;

  const MenuItemForm({super.key, this.menuItem, required this.onSubmit});

  @override
  _MenuItemFormState createState() => _MenuItemFormState();
}

class _MenuItemFormState extends State<MenuItemForm> {
  final _formKey = GlobalKey<FormState>();
  final RestaurantRepository _repository = RestaurantRepository();
  List<Category> categories = [];
  List<SubCategory> subcategories = [];
  int? selectedCategoryId;
  int? selectedSubcategoryId;
  String? name;

  String? description;
  Duration? duration;
  bool isAvailable = false;

  @override
  void initState() {
    super.initState();
    if (widget.menuItem != null) {
      name = widget.menuItem!.name;
      description = widget.menuItem!.description;
      selectedCategoryId = widget.menuItem!.categoryId;
      selectedSubcategoryId = widget.menuItem!.subcategoryId;
      isAvailable = widget.menuItem!.isTodayAvailable!;
    }
    _fetchCategories();
    _fetchSubcategories();
  }

  void _fetchCategories() async {
    final categoryList = await _repository.getCategories();
    if (categoryList != null) {
      setState(() {
        categories = categoryList;
      });
    }
  }

  void _fetchSubcategories() async {
    final subcategoryList = await _repository.getSubcategories();
    if (subcategoryList != null) {
      setState(() {
        subcategories = subcategoryList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          DropdownButtonFormField<int>(
            value: selectedCategoryId,
            items: categories.map((category) {
              return DropdownMenuItem<int>(
                value: category.id,
                child: Text(category.name!),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCategoryId = value;
              });
            },
            hint: const Text('Select Category'),
            validator: (value) {
              if (value == null) {
                return 'Please select a category';
              }
              return null;
            },
          ),
          DropdownButtonFormField<int>(
            value: selectedSubcategoryId,
            items: subcategories
                .where((subcategory) =>
                    subcategory.categoryId == selectedCategoryId)
                .map((subcategory) {
              return DropdownMenuItem<int>(
                value: subcategory.id,
                child: Text(subcategory.name!),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedSubcategoryId = value;
              });
            },
            hint: const Text('Select Subcategory'),
          ),
          TextFormField(
            initialValue: name,
            decoration: const InputDecoration(
              labelText: 'Name',
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
            onSaved: (value) {
              name = value;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Description',
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
            maxLines: 3,
            onSaved: (value) {
              description = value;
            },
          ),
          // TextFormField(
          //   initialValue: price != null ? price?.toStringAsFixed(2) : '',
          //   decoration: const InputDecoration(labelText: 'Price'),
          //   keyboardType: TextInputType.number,
          //   validator: (value) {
          //     if (value == null || value.isEmpty) {
          //       return 'Please enter a price';
          //     }
          //     return null;
          //   },
          //   onSaved: (value) {
          //     price = double.tryParse(value!);
          //   },
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {},
                      child: AbsorbPointer(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 15),
                          child: TextFormField(
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: "Duration",
                              hintText: "cooking duration",
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Duration is required.";
                              } else {
                                return null;
                              }
                            },
                            onFieldSubmitted: (String value) {
                              FocusScope.of(context).requestFocus();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SwitchListTile.adaptive(
            title: const Text('Available'),
            value: isAvailable,
            thumbIcon:
            WidgetStateProperty.resolveWith<Icon>(
                  (Set<WidgetState> states) {
                if (states.containsAll([
                  WidgetState.disabled,
                  WidgetState.selected
                ])) {
                  return const Icon(Icons.check,
                      color: Colors.red);
                }

                if (states.contains(
                    WidgetState.disabled)) {
                  return const Icon(
                    Icons.close,
                  );
                }

                if (states.contains(
                    WidgetState.selected)) {
                  return const Icon(Icons.check,
                      color: Colors.green);
                }

                return const Icon(
                  Icons.close,
                );
              },
            ),
            onChanged: (value) {
              setState(() {
                isAvailable = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                MenuItem menuItem;
                if (widget.menuItem != null) {
                  menuItem = MenuItem(
                    name: name,
                    description: description,
                    categoryId: selectedCategoryId,
                    subcategoryId: selectedSubcategoryId,
                    isTodayAvailable: isAvailable,
                    id: widget.menuItem!.id,
                    duration: duration?.inSeconds ?? 0,
                    creationDate: widget.menuItem?.creationDate ?? "",
                    modificationDate: DateUtil.dateToString(DateTime.now(), DateUtil.DATE_FORMAT15),
                  );
                } else {
                  menuItem = MenuItem(
                    name: name,
                    description: description,
                    categoryId: selectedCategoryId,
                    subcategoryId: selectedSubcategoryId,
                    isTodayAvailable: isAvailable,
                    duration: duration?.inSeconds ?? 0,
                    creationDate: DateUtil.dateToString(
                        DateTime.now(), DateUtil.DATE_FORMAT15),
                  );
                }
                widget.onSubmit(menuItem);
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
