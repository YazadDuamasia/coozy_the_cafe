import 'package:coozy_cafe/bloc/category_form_bloc/category_form_bloc.dart';
import 'package:coozy_cafe/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryFormScreen extends StatefulWidget {
  const CategoryFormScreen({Key? key}) : super(key: key);

  @override
  _CategoryFormScreenState createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final CategoryFormBloc _bloc = CategoryFormBloc();

  TextEditingController? _categoryNameController =
      TextEditingController(text: "");
  FocusNode? _categoryNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _categoryNameController = TextEditingController(text: "");
    _categoryNameFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          "Add New Category",
        ),
        leadingWidth: 35,
        centerTitle: false,
      ),
      body: BlocConsumer<CategoryFormBloc, CategoryFormState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is InitialCategoryFormState) {
            return Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: _categoryNameController,
                          focusNode: _categoryNameFocusNode,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            labelText: 'Category Name',
                            hintText: 'Enter category name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Category name is required';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            Future.microtask(() => FocusScope.of(context)
                                .requestFocus(new FocusNode()));
                          },
                        ),
                      ),
                    ],
                  ),

                  // Dynamic ListView.builder
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.selectedSubcategories.length +
                        state.newSubcategoryControllers.length,
                    itemBuilder: (context, index) {
                      if (index < state.selectedSubcategories.length) {
                        return ListTile(
                          title: DropdownButtonFormField<String?>(
                            value: state.selectedSubcategories[index],
                            items: [
                              const DropdownMenuItem<String>(
                                value: null,
                                child: Text('Select Subcategory'),
                              ),
                              const DropdownMenuItem<String>(
                                value: 'CreateNew',
                                child: Text('Create new Subcategory'),
                              ),
                              for (var subcategory in state.subcategoryList)
                                DropdownMenuItem<String>(
                                  value: subcategory?.name ?? "",
                                  child: Text(subcategory?.name ?? ""),
                                ),
                            ],
                            onChanged: (value) {
                              context.read<CategoryFormBloc>().add(
                                  UpdateSelectedSubcategoryEvent(index, value));
                              // setState(() {
                              //   selectedSubcategories![index] = value;
                              // });
                            },
                          ),
                          leading: IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () async {
                              context
                                  .read<CategoryFormBloc>()
                                  .add(RemoveSubcategoryEvent(index));
                              // setState(() {
                              //   selectedSubcategories!.removeAt(index);
                              //   newSubcategoryControllers.remove(index);
                              //   newSubcategoryErrors.remove(index);
                              // });
                            },
                          ),
                          subtitle: Visibility(
                            visible: state.selectedSubcategories[index] ==
                                'CreateNew',
                            child: TextFormField(
                              controller:
                                  state.newSubcategoryControllers[index],
                              decoration: const InputDecoration(
                                labelText: 'New Subcategory Name',
                              ),
                            ),
                          ),
                        );
                      } else {
                        final newIndex =
                            index - state.selectedSubcategories.length;
                        return ListTile(
                          title: DropdownButtonFormField<String?>(
                            value: state.selectedSubcategories[newIndex],
                            items: [
                              const DropdownMenuItem<String>(
                                value: null,
                                child: Text('Select Subcategory'),
                              ),
                              for (var subcategory in state.subcategoryList)
                                DropdownMenuItem<String>(
                                  value: subcategory?.name ?? "",
                                  child: Text(subcategory?.name ?? ""),
                                ),
                            ],
                            onChanged: (value) {
                              context.read<CategoryFormBloc>().add(
                                  UpdateSelectedSubcategoryEvent(index, value));
                              // setState(() {
                              //   selectedSubcategories![newIndex] = value;
                              // });
                            },
                          ),
                          leading: IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () async {
                              context
                                  .read<CategoryFormBloc>()
                                  .add(RemoveSubcategoryEvent(index));
                              // setState(() {
                              //   selectedSubcategories!.removeAt(newIndex);
                              //   newSubcategoryControllers.remove(newIndex);
                              //   newSubcategoryErrors.remove(newIndex);
                              // });
                            },
                          ),
                          subtitle: Visibility(
                            visible: state.selectedSubcategories[newIndex] ==
                                'CreateNew',
                            child: TextFormField(
                              controller:
                                  state.newSubcategoryControllers[newIndex],
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                labelText: 'New Subcategory Name',
                              ),
                              onFieldSubmitted: (value) {
                                Future.microtask(() => FocusScope.of(context)
                                    .requestFocus(new FocusNode()));
                              },
                            ),
                          ),
                        );
                      }
                    },
                  ),

                  // Add Subcategory Button
                  ElevatedButton(
                    onPressed: () async {
                      context
                          .read<CategoryFormBloc>()
                          .add(AddNewSubcategoryEvent());
                    },
                    child: const Text("Add Subcategory"),
                  ),

                  // Submit Button
                  ElevatedButton(
                    onPressed: () async {
                      context
                          .read<CategoryFormBloc>()
                          .add(SubmitFormEvent(context, _formKey));
                    },
                    child: const Text("Submit"),
                  ),
                ],
              ),
            );
          }
          return const LoadingPage();
        },
      ),
    );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
