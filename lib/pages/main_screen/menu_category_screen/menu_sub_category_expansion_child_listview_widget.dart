import 'dart:math';

import 'package:coozy_cafe/AppLocalization.dart';
import 'package:coozy_cafe/model/sub_category.dart';
import 'package:coozy_cafe/utlis/components/string_value.dart';
import 'package:coozy_cafe/widgets/post_time_text_widget/post_time_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MenuSubCategoryExpansionChildListViewWidget extends StatefulWidget {
  final List<SubCategory>? subCategoryList;
  final int? itemsToShow;

  const MenuSubCategoryExpansionChildListViewWidget(
      {super.key, this.subCategoryList, this.itemsToShow});

  @override
  _MenuSubCategoryExpansionChildListViewWidgetState createState() =>
      _MenuSubCategoryExpansionChildListViewWidgetState();
}

class _MenuSubCategoryExpansionChildListViewWidgetState
    extends State<MenuSubCategoryExpansionChildListViewWidget> {
  int? itemsToShow = 0;

  @override
  void initState() {
    setState(() {
      itemsToShow = widget.itemsToShow;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: UniqueKey(),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              SubCategory subCategory = widget.subCategoryList![index];
              return ListTile(
                leading: Icon(MdiIcons.subdirectoryArrowRight,
                    color: Theme.of(context).primaryColor),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(child: Text(subCategory.name ?? "")),
                  ],
                ),
                subtitle: PostTimeTextWidget(
                  key: UniqueKey(),
                  creationDate: subCategory.createdDate ?? "",
                  localizedCode:
                      AppLocalizations.getCurrentLanguageCode(context),
                ),
              );
            },
            childCount: min(itemsToShow ?? 0, widget.subCategoryList!.length),
          ),
        ),
        if (widget.subCategoryList!.length > (itemsToShow ?? 0))
          SliverToBoxAdapter(
            child: Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  setState(
                    () {
                      // Increase the itemsToShow to load the next set of items
                      itemsToShow =
                          (itemsToShow ?? 0) + (widget.itemsToShow ?? 0);
                    },
                  );
                },
                child: Text(AppLocalizations.of(context)
                        ?.translate(StringValue.common_load_more) ??
                    "Load More"),
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
