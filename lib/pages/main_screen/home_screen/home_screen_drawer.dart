import 'package:coozy_the_cafe/AppLocalization.dart';
import 'package:coozy_the_cafe/utlis/utlis.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomeScreenDrawer extends StatefulWidget {
  const HomeScreenDrawer({super.key});

  @override
  State<HomeScreenDrawer> createState() => _HomeScreenDrawerState();
}

class _HomeScreenDrawerState extends State<HomeScreenDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
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
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.home,
                  title: 'Home',
                  index: 0,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.table_restaurant,
                  title: AppLocalizations.of(context)
                          ?.translate(StringValue.table_info_app_bar_title) ??
                      "Table Info",
                  index: 1,
                  onTap: () {
                    Navigator.pop(context);
                    navigationRoutes.navigateToTableInfoScreen();
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.restaurant_menu,
                  title: 'Menu Items',
                  index: 2,
                  onTap: () {
                    Navigator.pop(context);
                    navigationRoutes.navigateToMenuItemFullListScreen();
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.category,
                  title: 'Menu Category',
                  index: 3,
                  onTap: () {
                    Navigator.pop(context);
                    navigationRoutes.navigateToMenuCategoryFullListScreen();
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.category,
                  title: 'Menu Subcategory',
                  index: 4,
                  onTap: () {
                    Navigator.pop(context);
                    navigationRoutes
                        .navigateToMenuAllSubCategoryFullListScreen();
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: MdiIcons.orderBoolDescending,
                  title: 'Order List',
                  index: 5,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: MenuIcons.recipe_cooking_book,
                  title: 'Recipes',
                  index: 6,
                  onTap: () {
                    Navigator.pop(context);
                    navigationRoutes.navigateToRecipesScreen();
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: LineIcons.paperHandAlt,
                  title: 'Staff Attendance',
                  index: 7,
                  onTap: () {
                    Navigator.pop(context);
                    navigationRoutes.navigateToEmployeeAttendanceScreen();
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.settings,
                  title: 'Settings',
                  index: 8,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: MdiIcons.certificate,
                  title: 'License',
                  index: 9,
                  onTap: () {
                    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
                      String appName = packageInfo.appName;
                      String packageName = packageInfo.packageName;
                      String version = packageInfo.version;
                      String buildNumber = packageInfo.buildNumber;

                      navigationRoutes.showLicensePage(
                          applicationName: appName,
                          applicationIcon: FlutterLogo(),
                          applicationVersion: version,
                          useRootNavigator: true);
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build a drawer item with underline
  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required int index,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: TextStyle(
          decoration: TextDecoration.none,
        ),
      ),
      onTap: onTap,
    );
  }
}
