import 'package:coozy_the_cafe/database/database.dart';
import 'package:coozy_the_cafe/model/category.dart';
import 'package:coozy_the_cafe/model/customer.dart';
import 'package:coozy_the_cafe/model/inventory_model/inventory_model.dart';
import 'package:coozy_the_cafe/model/menu_item.dart';
import 'package:coozy_the_cafe/model/order_model.dart';
import 'package:coozy_the_cafe/model/purchase_model/purchase_model.dart';
import 'package:coozy_the_cafe/model/recipe_model.dart';
import 'package:coozy_the_cafe/model/sub_category.dart';
import 'package:coozy_the_cafe/model/table_info_model.dart';
import 'package:coozy_the_cafe/utlis/components/constants.dart';
import 'package:flutter/services.dart';

class RestaurantRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

// Category CRUD operations

// Adds a new category to the database.
  Future<List<RecipeModel>?> recipeList() async {
    bool? isFirstTime = await Constants.isFirstTime("recipeList");

    if (isFirstTime == true) {
      final jsonContent = await rootBundle
          .loadString('assets/data/recipes_for_indian_food_dataset.json');
      List<RecipeModel> recipes = recipeModelFromJson(jsonContent);

      Constants.debugLog(
          RestaurantRepository, "recipeModel length: ${recipes.length}");
      await _databaseHelper.insertRecipes(
          recipes); // Insert translated recipes into the database

      Constants.debugLog(RestaurantRepository, "insertRecipes: Done");
      return recipes;
    } else {
      return await _databaseHelper.getRecipes();
    }
  }

  Future<List<RecipeModel>?> getBookmarkedRecipes() async {
    return await _databaseHelper.getBookmarkedRecipes();
  }

  Future<int?> addCategory(Category category) async {
    return await _databaseHelper.addCategory(category);
  }

  Future<int?> updateRecipe(RecipeModel recipeModel) async {
    return await _databaseHelper.updateRecipe(recipeModel);
  }

// Retrieves a list of all categories from the database.
  Future<List<Category>?> getCategories() async {
    return await _databaseHelper.getCategories();
  }

// Retrieves a list of all categories from the database.
  Future<Category?> getCategoryBasedOnName(String? categoryName) async {
    return await _databaseHelper.getCategoryBasedOnName(name: categoryName);
  }

  // Retrieves category base on Id from the database.
  Future<Category?> getCategoryBasedOnCategoryId({categoryId}) async {
    return await _databaseHelper.getCategoryBasedOnCategoryId(
        categoryId: categoryId);
  }

// Updates an existing category in the database.
  Future<int?> updateCategory(Category category) async {
    return await _databaseHelper.updateCategory(category);
  }

// Deletes a category with the specified ID from the database.
  Future<int?> deleteCategory(int? categoryId) async {
    return await _databaseHelper.deleteCategory(categoryId);
  }

// Deletes complete record category with its sub category with the specified category ID from the database.
  Future<int?> delete_complete_record_category(int? categoryId) async {
    try {
      // First delete all subcategories associated with the category
      int? deletedSubcategories = await _databaseHelper.deleteAllSubcategoryBasedOnCategoryId(categoryId: categoryId);

      // Then delete the main category
      int? deletedCategory = await _databaseHelper.deleteCategory(categoryId);

      // Return the result (you could return the sum of deleted rows if needed)
      return deletedCategory;
    } catch (e) {
      // Handle any errors or exceptions
      print("Error while deleting category and subcategories: $e");

      // Optionally, return null or any custom error code to indicate failure
      return null;
    }
  }

// Subcategory CRUD operations

// Creates a new subcategory in the database.
  Future<int> createSubcategory(SubCategory subcategory) async {
    return await _databaseHelper.createSubcategory(subcategory);
  }

// Retrieves a list of all subcategories from the database.
  Future<List<SubCategory>?> getSubcategories() async {
    return await _databaseHelper.getSubcategories();
  }

// Retrieves a single subcategory by ID.
  Future<List<SubCategory>?> getSubcategoryBaseCategoryId({int? id}) async {
    return await _databaseHelper.getSubcategoryBaseCategoryId(id!);
  }

// Updates an existing subcategory in the database.
  Future<int?> updateSubcategory(SubCategory subcategory) async {
    return await _databaseHelper.updateSubcategory(subcategory);
  }

// Deletes a subcategory with the specified ID from the database.
  Future<int?> deleteSubcategory(int id) async {
    return await _databaseHelper.deleteSubcategory(id);
  }

  // Deletes a subcategory with the specified ID from the database.
  Future<int?> deleteAllSubcategoryBasedOnCategoryId({int? categoryId}) async {
    return await _databaseHelper.deleteAllSubcategoryBasedOnCategoryId(
        categoryId: categoryId);
  }

  // Insert a subcategories in batch with the specified ID from the database.
  Future<dynamic> insertSubCategoriesForCategoryId(
      {required int? categoryId,
      required List<String?>? subCategoriesList}) async {
    // Create a list of SubCategory instances from the list of strings
    List<SubCategory> subCategories = subCategoriesList?.map((name) {
          return SubCategory(
            name: name,
            createdDate: DateTime.now().toUtc().toIso8601String(),
            categoryId: categoryId,
          );
        }).toList() ??
        [];

    return await _databaseHelper.insertSubCategoriesForCategoryId(
        categoryId: categoryId, subCategories: subCategories);
  }

  // TableInfo CRUD operations
  // Creates a new TableInfo in the database.
  Future<int?> addNewTableInfo(TableInfoModel tableInfoModel) async {
    return await _databaseHelper.addTableInfo(tableInfoModel);
  }

// Retrieves a list of all getTableInfo from the database.
  Future<List<TableInfoModel>?> getTableInfoList() async {
    return await _databaseHelper.getTableInfos();
  }

  // Retrieves a model TableInfo from the database.
  Future<TableInfoModel?> getTableInfo(int id) async {
    return await _databaseHelper.getTableInfo(id);
  }

// Updates an existing tableInfoModel item in the database.
  Future<int?> updateTableInfo(TableInfoModel tableInfoModel) async {
    return await _databaseHelper.updateTableInfo(tableInfoModel);
  }

// Delete a table info
  Future<int?> deleteTableInfo({TableInfoModel? tableInfoModelToDelete}) async {
    return await _databaseHelper.deleteTableInfo(tableInfoModelToDelete!);
  }

  Future<int?> getTableInfoRecordCount() async {
    return await _databaseHelper.getTableInfoRecordCount();
  }

// Menu Item CRUD operations

// Creates a new menu item in the database.
  Future<int?> createMenuItem(MenuItem menuItem) async {
    return await _databaseHelper.createMenuItem(menuItem);
  }

// Retrieves a list of all menu items from the database.
  Future<List<MenuItem>?> getMenuItems() async {
    return await _databaseHelper.getAllMenuItems();
  }

// Retrieves a list of all available menu items at present date from the database.
  Future<List<MenuItem>?> getAvailableMenuItems() async {
    return await _databaseHelper.getAvailableMenuItems();
  }

// Retrieves a single menu item by ID.
  Future<MenuItem?> getMenuItem(int id) async {
    return await _databaseHelper.getMenuItemById(id);
  }

// Updates an existing menu item in the database.
  Future<int?> updateMenuItem(MenuItem menuItem) async {
    return await _databaseHelper.updateMenuItem(menuItem);
  }

// Deletes a menu item with the specified ID from the database.
  Future<void> deleteMenuItem(int? id) async {
    return await _databaseHelper.deleteMenuItem(id);
  }

// Customer CRUD operations

// Creates a new customer in the database.
  Future<int> createCustomer(Customer customer) async {
    return await _databaseHelper.createCustomer(customer);
  }

// Retrieves a list of all customers from the database.
  Future<List<Customer>> getCustomers() async {
    return await _databaseHelper.getCustomers();
  }

// Retrieves a single customer by ID.
  Future<Customer?> getCustomer(int id) async {
    return await _databaseHelper.getCustomer(id);
  }

// Searches for customers based on a search term.
  Future<List<Customer>?> searchCustomers(String searchTerm) async {
    return await _databaseHelper.searchCustomers(searchTerm);
  }

// Searches for a single customer based on a search term.
  Future<Customer?> searchCustomer(String searchTerm) async {
    return await _databaseHelper.searchCustomer(searchTerm);
  }

// Checks if a customer with a given name or phone number exists.
  Future<bool> isCustomerExist(String searchTerm) async {
    return await _databaseHelper.isCustomerExist(searchTerm);
  }

// Updates an existing customer in the database.
  Future<int?> updateCustomer(Customer customer) async {
    return await _databaseHelper.updateCustomer(customer);
  }

// Order CRUD operations

// Creates a new order in the database.
  Future<int?> createOrder(OrderModel order) async {
    return await _databaseHelper.createNewOrder(order);
  }

// Retrieves information about a single order by its ID.
  Future<OrderModel?> getOrderInfo(int id) async {
    return await _databaseHelper.getOrderInfo(id);
  }

// Updates an existing order in the database.
  Future<void> updateOrder(OrderModel order) async {
    return await _databaseHelper.updateOrder(order);
  }

// Updates the "isDeleted" status of an order.
  Future<int?> updateOrderIsDeleted(int orderId, bool isDeleted) async {
    return await _databaseHelper.updateOrderIsDeleted(orderId, isDeleted);
  }

// Updates the "isCanceled" status of an order.
  Future<int?> updateOrderIsCanceled(int orderId, bool isCanceled) async {
    return await _databaseHelper.updateOrderIsCanceled(orderId, isCanceled);
  }

// Retrieves a list of all orders in the database.
  Future<List<OrderModel?>?> getAllActiveOrders() async {
    return await _databaseHelper.getAllActiveOrders();
  }

// // Retrieves a list of orders by customer ID.
//   Future<List<OrderModel>?> getOrdersByCustomer(int customerId) async {
//     return await _databaseHelper.getOrdersByCustomer(customerId);
//   }

// // Deletes an order by its ID.
//   Future<int?> deleteOrder(int orderId) async {
//     return await _databaseHelper.deleteOrder(orderId);
//   }

  Future<int?> insertInventory(InventoryModel inventory) async {
    return await _databaseHelper.insertInventory(inventory);
  }

  Future<int?> updateInventory(InventoryModel inventory) async {
    return await _databaseHelper.updateInventory(inventory);
  }

  Future<int?> deleteInventory({int? inventoryID}) async {
    return await _databaseHelper.deleteInventory(inventoryID!);
  }

  Future<List<InventoryModel>?> getAllEnableInventory() async {
    return await _databaseHelper.getAllEnableInventory();
  }

  Future<List<InventoryModel>?> getAllInventory() async {
    return await _databaseHelper.getAllInventory();
  }

  Future<int?> insertPurchase(PurchaseModel purchase) async {
    return await _databaseHelper.insertPurchase(purchase);
  }

  Future<int?> updatePurchase(PurchaseModel purchase) async {
    return await _databaseHelper.updatePurchase(purchase);
  }

  Future<int?> deletePurchase({int? purchaseID}) async {
    return await _databaseHelper.deletePurchase(purchaseID!);
  }

  Future<List<PurchaseModel>?> getAllPurchases() async {
    return await _databaseHelper.getAllPurchases();
  }

  Future<double?> getDailyExpenditureCost({String? currentDate}) async {
    return await _databaseHelper.getDailyExpenditureCost(currentDate!);
  }

  Future<double?> getMonthlyExpenditureCost({String? currentDateMonth}) async {
    return await _databaseHelper.getMonthlyExpenditureCost(currentDateMonth!);
  }
}
