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
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    "No Category been inserted",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: onAddNewCategory,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                      right: 25,
                      left: 25,
                    ),
                    elevation: 5,
                  ),
                  child: const Text('Add new category'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
