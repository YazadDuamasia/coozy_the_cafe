import 'package:coozy_cafe/database_helper/DatabaseHelper.dart';
import 'package:coozy_cafe/model/category.dart';
import 'package:coozy_cafe/model/customer.dart';
import 'package:coozy_cafe/model/menu_item.dart';
import 'package:coozy_cafe/model/order_model.dart';
import 'package:coozy_cafe/model/sub_category.dart';
import 'package:coozy_cafe/model/table_info_model.dart';

class RestaurantRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

// Category CRUD operations

// Adds a new category to the database.
  Future<int?> addCategory(Category category) async {
    return await _databaseHelper.addCategory(category);
  }

// Retrieves a list of all categories from the database.
  Future<List<Category>?> getCategories() async {
    return await _databaseHelper.getCategories();
  }

// Updates an existing category in the database.
  Future<int?> updateCategory(Category category) async {
    return await _databaseHelper.updateCategory(category);
  }

// Deletes a category with the specified ID from the database.
  Future<int?> deleteCategory(int categoryId) async {
    return await _databaseHelper.deleteCategory(categoryId);
  }

// Subcategory CRUD operations

// Creates a new subcategory in the database.
  Future<int> createSubcategory(Subcategory subcategory) async {
    return await _databaseHelper.createSubcategory(subcategory);
  }

// Retrieves a list of all subcategories from the database.
  Future<List<Subcategory>> getSubcategories() async {
    return await _databaseHelper.getSubcategories();
  }

// Retrieves a single subcategory by ID.
  Future<Subcategory?> getSubcategory(int id) async {
    return await _databaseHelper.getSubcategory(id);
  }

// Updates an existing subcategory in the database.
  Future<int?> updateSubcategory(Subcategory subcategory) async {
    return await _databaseHelper.updateSubcategory(subcategory);
  }

// Deletes a subcategory with the specified ID from the database.
  Future<int?> deleteSubcategory(int id) async {
    return await _databaseHelper.deleteSubcategory(id);
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
  Future<int?> deleteTableInfo(int id) async {
    return await _databaseHelper.deleteTableInfo(id);
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
  Future<void> deleteMenuItem(int id) async {
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
}
