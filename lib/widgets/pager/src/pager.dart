import 'package:flutter/material.dart';

class Pager extends StatefulWidget {
  Pager({
    Key? key,
    required this.totalPages,
    required this.onPageChanged,
    this.showItemsPerPage = false,
    this.currentItemsPerPage,
    required this.onItemsPerPageChanged,
    this.pagesView = 3,
    this.currentPage = 1,
    this.numberButtonSelectedColor = Colors.blue,
    this.numberTextSelectedColor = Colors.white,
    this.numberTextUnselectedColor = Colors.black,
    this.pageChangeIconColor = Colors.grey,
    this.itemsPerPageText,
    this.itemsPerPageTextStyle,
    this.dropDownMenuItemTextStyle,
    this.itemsPerPageAlignment = Alignment.center,
    required this.itemsPerPageList,
  })  : assert(currentPage > 0 && totalPages > 0 && pagesView > 0,
            "Fatal Error: Make sure the currentPage, totalPages and pagesView fields are greater than zero."),
        super(key: key) {
    if (showItemsPerPage) {
      assert(
          currentItemsPerPage != null &&
              onItemsPerPageChanged != null &&
              itemsPerPageList != null &&
              itemsPerPageList!.isNotEmpty,
          "Fatal error: OnItemsPerPageChanged must be implemented or itemsPerPageList is null or empty.");
    }
    this.itemsPerPageList = itemsPerPageList ?? [];
  }

  int pagesView;
  final int totalPages;
  final Function(int) onPageChanged;
  final bool showItemsPerPage;
  final int? currentItemsPerPage;
  List<int>? itemsPerPageList;
  final Function(int?) onItemsPerPageChanged;
  int currentPage;
  final Color numberButtonSelectedColor;
  final Color numberTextUnselectedColor;
  final Color numberTextSelectedColor;
  final Color pageChangeIconColor;
  final String? itemsPerPageText;
  final TextStyle? itemsPerPageTextStyle;
  final TextStyle? dropDownMenuItemTextStyle;
  final Alignment itemsPerPageAlignment;

  @override
  State<Pager> createState() => _PagerState();
}

class _PagerState extends State<Pager> {
  @override
  Widget build(BuildContext context) {
    pagesViewValidation();
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  tooltip: "First Page",
                  onPressed: widget.currentPage > 1
                      ? () {
                          setState(() {
                            widget.currentPage = 1;
                            widget.onPageChanged(widget.currentPage);
                          });
                        }
                      : null,
                  splashRadius: 25,
                  icon: Icon(
                    Icons.first_page,
                    color: widget.pageChangeIconColor,
                  ),
                ),
                IconButton(
                  tooltip: "Previous",
                  onPressed: widget.currentPage > 1
                      ? () {
                          setState(() {
                            widget.currentPage = widget.currentPage > 1
                                ? widget.currentPage - 1
                                : 1;
                            widget.onPageChanged(widget.currentPage);
                          });
                        }
                      : null,
                  splashRadius: 25,
                  icon: Icon(
                    Icons.chevron_left,
                    color: widget.pageChangeIconColor,
                  ),
                ),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = getPageStart(getPageEnd());
                          i < getPageEnd();
                          i++)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              widget.currentPage = i;
                              widget.onPageChanged(widget.currentPage);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor: widget.currentPage == i
                                  ? widget.numberButtonSelectedColor
                                  : null),
                          child: Text(
                            "$i",
                            style: TextStyle(
                              color: widget.currentPage == i
                                  ? widget.numberTextSelectedColor
                                  : widget.numberTextUnselectedColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: "Next Page",
                  onPressed: widget.currentPage < widget.totalPages
                      ? () {
                          setState(() {
                            widget.currentPage =
                                widget.currentPage < widget.totalPages
                                    ? widget.currentPage + 1
                                    : widget.totalPages;
                            widget.onPageChanged(widget.currentPage);
                          });
                        }
                      : null,
                  splashRadius: 25,
                  icon: Icon(
                    Icons.chevron_right,
                    color: widget.pageChangeIconColor,
                  ),
                ),
                IconButton(
                  tooltip: "Last Page",
                  onPressed: widget.currentPage < widget.totalPages
                      ? () {
                          setState(() {
                            widget.currentPage = widget.totalPages;
                            widget.onPageChanged(widget.currentPage);
                          });
                        }
                      : null,
                  splashRadius: 25,
                  icon: Icon(
                    Icons.last_page,
                    color: widget.pageChangeIconColor,
                  ),
                ),
              ],
            ),
          ),
          if (widget.showItemsPerPage)
            Align(
              alignment: widget.itemsPerPageAlignment,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: ItemsPerPage(
                  currentItemsPerPage: widget.currentItemsPerPage!,
                  itemsPerPage: widget.itemsPerPageList ?? null,
                  onChanged: widget.onItemsPerPageChanged!,
                  itemsPerPageText: widget.itemsPerPageText,
                  itemsPerPageTextStyle: widget.itemsPerPageTextStyle,
                  dropDownMenuItemTextStyle: widget.dropDownMenuItemTextStyle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  int getPageEnd() {
    return widget.currentPage + widget.pagesView > widget.totalPages
        ? widget.totalPages + 1
        : widget.currentPage + widget.pagesView;
  }

  int getPageStart(int pageEnd) {
    return pageEnd == widget.totalPages + 1
        ? pageEnd - widget.pagesView
        : widget.currentPage;
  }

  void pagesViewValidation() {
    if (widget.totalPages < widget.pagesView) {
      widget.pagesView = widget.totalPages;
    }
  }
}

class ItemsPerPage extends StatelessWidget {
  ItemsPerPage({
    Key? key,
    required this.currentItemsPerPage,
    required this.itemsPerPage,
    required this.onChanged,
    this.itemsPerPageText,
    this.itemsPerPageTextStyle,
    this.dropDownMenuItemTextStyle,
  }) : super(key: key);

  final int currentItemsPerPage;
  final List<int>? itemsPerPage;
  final void Function(int?) onChanged; // Updated type to accept nullable int
  final String? itemsPerPageText;
  final TextStyle? itemsPerPageTextStyle;
  final TextStyle? dropDownMenuItemTextStyle;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: currentItemsPerPage,
      onChanged: onChanged,
      items: itemsPerPage?.map((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(
            itemsPerPageText != null ? '$itemsPerPageText $value' : '$value',
            style: dropDownMenuItemTextStyle,
          ),
        );
      }).toList(),
      style: itemsPerPageTextStyle,
    );
  }
}
