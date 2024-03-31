import 'package:coozy_cafe/AppLocalization.dart';
import 'package:coozy_cafe/utlis/components/string_value.dart';
import 'package:coozy_cafe/utlis/utlis.dart';
import 'package:flutter/material.dart';

class EmptyCategoryFullListBody extends StatelessWidget {
  const EmptyCategoryFullListBody({this.onAddNewCategory, super.key});

  final VoidCallback? onAddNewCategory;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 0, top: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(MenuIcons.menu_placeholder,
                color: Theme.of(context).primaryColor, size: 110),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)?.translate(
                            StringValue.menu_category_empty_title_text) ??
                        "No Category been inserted",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: onAddNewCategory,
                  style: ElevatedButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                      right: 25,
                      left: 25,
                    ),
                    elevation: 5,
                  ),

                  child: Text(
                      AppLocalizations.of(context)?.translate(
                          StringValue.menu_category_add_new_category) ??
                      'Add new category'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
