import 'package:coozy_cafe/model/menu_item.dart';
import 'package:coozy_cafe/repositories/components/restaurant_repository.dart';
import 'package:flutter/material.dart';

class MenuFullListScreen extends StatefulWidget {
  const MenuFullListScreen({super.key});

  @override
  _MenuFullListScreenState createState() => _MenuFullListScreenState();
}

class _MenuFullListScreenState extends State<MenuFullListScreen>
    with TickerProviderStateMixin {
  List<MenuItem>? list = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text(
              "Menu List",
            ),
            leadingWidth: 35,
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: () async {},
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                tooltip: "Add new menu item",
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              primary: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loadData() async {
    list = await RestaurantRepository().getMenuItems();
  }

  Future<void> _refreshData() async {
    // Put your data fetching logic here.
    // You can make an API call or update your data source.
    loadData();
    await Future.delayed(
        const Duration(seconds: 1)); // Simulate a delay for demonstration.
    setState(() {});
  }
}
