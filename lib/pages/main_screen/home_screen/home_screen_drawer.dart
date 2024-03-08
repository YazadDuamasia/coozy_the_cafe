import 'package:coozy_cafe/AppLocalization.dart';
import 'package:coozy_cafe/utlis/utlis.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomeScreenDrawer extends StatelessWidget {
  const HomeScreenDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Center(
              child: Text(
                Constants.appName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              // Handle drawer item click for home
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.table_restaurant),
            title: Text(
              AppLocalizations.of(context)
                      ?.translate(StringValue.table_info_app_bar_title) ??
                  "Table Info",
            ),
            onTap: () {
              Navigator.pop(context);
              navigationRoutes.navigateToTableInfoScreen();
            },
          ),
          ListTile(
            leading: const Icon(Icons.restaurant_menu),
            title: const Text('Menu'),
            onTap: () {
              Navigator.pop(context);
              navigationRoutes.navigateToMenuFullListScreen();
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Menu category'),
            onTap: () {
              Navigator.pop(context);
              navigationRoutes.navigateToMenuCategoryFullListScreen();
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Menu subcategory'),
            onTap: () {
              Navigator.pop(context);
              navigationRoutes.navigateToMenuAllSubCategoryFullListScreen();
            },
          ),
          ListTile(
            leading: Icon(
              MdiIcons.orderBoolDescending,
            ),
            title: const Text('Order List'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Handle drawer item click for settings
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
