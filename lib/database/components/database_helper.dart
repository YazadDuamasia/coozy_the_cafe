import 'dart:io';

import 'package:coozy_the_cafe/model/attendance/attendance.dart';
import 'package:coozy_the_cafe/model/attendance/employee.dart';
import 'package:coozy_the_cafe/model/attendance/leave.dart';
import 'package:coozy_the_cafe/model/category.dart';
import 'package:coozy_the_cafe/model/customer.dart';
import 'package:coozy_the_cafe/model/daily_sales_report_entry.dart';
import 'package:coozy_the_cafe/model/inventory_model/inventory_model.dart';
import 'package:coozy_the_cafe/model/invoice.dart';
import 'package:coozy_the_cafe/model/menu_item.dart';
import 'package:coozy_the_cafe/model/menu_item_review.dart';
import 'package:coozy_the_cafe/model/order_item.dart';
import 'package:coozy_the_cafe/model/order_model.dart';
import 'package:coozy_the_cafe/model/purchase_model/purchase_model.dart';
import 'package:coozy_the_cafe/model/recipe_model.dart';
import 'package:coozy_the_cafe/model/sub_category.dart';
import 'package:coozy_the_cafe/model/table_info_model.dart';
import 'package:coozy_the_cafe/utlis/utlis.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  final String tableInfoTable = 'table_info';
  final String categoriesTable = 'categories';
  final String subcategoriesTable = 'subcategories';
  final String menuItemsTable = 'menu_items';
  final String menuItemVariationsTable = 'menu_item_variations';
  final String menuItemReviewsTable = 'menu_item_reviews';
  final String customersTable = 'customers';

  final String ordersTable = 'orders';
  final String orderItemsTable = 'order_items';
  final String invoicesTable = 'invoices';
  final String paymentModeTable = 'payment_modes';
  final String recipeModelTable = 'recipes';
  final String employeesTable = 'employees';
  final String attendanceTable = 'attendance';
  final String leavesTable = 'leaves';
  final String inventoryTable = 'inventory';
  final String purchaseTable = 'purchase';

  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'coozy_the_cafe.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create the 'categories' table
    await db.execute('''
    CREATE TABLE $categoriesTable(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      isActive INTEGER,
      createdDate TEXT
    )
  ''');

    // Create the 'subcategories' table
    await db.execute('''
    CREATE TABLE $subcategoriesTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      createdDate TEXT,
      categoryId INTEGER,
      isActive INTEGER,
      FOREIGN KEY(categoryId) REFERENCES $categoriesTable(id)
    )
  ''');

    // Create the '$menuItemsTable' table
    await db.execute('''
    CREATE TABLE $menuItemsTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      description TEXT NOT NULL,
      foodType TEXT NULL,
      creationDate TEXT NULL,
      modificationDate TEXT NULL,
      duration INTEGER,
      categoryId INTEGER,
      subcategoryId INTEGER,
      isTodayAvailable INTEGER,
      isSimpleVariation INTEGER,
      costPrice REAL,
      sellingPrice REAL,
      stockQuantity REAL,
      quantity TEXT,
      purchaseUnit TEXT
    )
  ''');

    // Create the 'menuItemVariationsTable' table
    await db.execute('''
    CREATE TABLE $menuItemVariationsTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      menuItemId INTEGER,
      quantity INTEGER,
      purchaseUnit TEXT,
      isTodayAvailable INTEGER,
      costPrice REAL,
      sellingPrice REAL,
      stockQuantity INTEGER,
      sortOrderIndex INTEGER,
      creationDate TEXT NULL,
      modificationDate TEXT NULL,
      FOREIGN KEY(menuItemId) REFERENCES $menuItemsTable(id)
    )
  ''');

    // Create the 'customers' table
    await db.execute('''
    CREATE TABLE $customersTable(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      phoneNumber TEXT,
      createdDate TEXT
    )
  ''');

    // Create the 'TableInfo' table
    await db.execute('''
    CREATE TABLE $tableInfoTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      colorValue TEXT,
      sortOrderIndex INTEGER,
      nosOfChairs INTEGER
    )
  ''');

    // Create the 'orders' table
    await db.execute('''
    CREATE TABLE $ordersTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      tableInfoId INTEGER,
      creationDate TEXT NULL,
      modificationDate TEXT NULL,
      isCanceled INTEGER,
      isDeleted INTEGER,
      status TEXT,
      paymentMethodName TEXT NULL,
      paymentMethodDetails TEXT NULL,
      deliveryAddress TEXT NULL,
      customerId INTEGER NULL,
      customerName TEXT,
      phoneNumber TEXT,
      FOREIGN KEY (tableInfoId) REFERENCES $tableInfoTable (id),
      FOREIGN KEY (customerId) REFERENCES $customersTable (id)
    )
  ''');

    // Create the 'orderItems' table
    await db.execute('''
    CREATE TABLE $orderItemsTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      orderId INTEGER,
      itemId INTEGER,
      quantity INTEGER,
      sellingPrice REAL,
      costPrice REAL,
      status TEXT,
      isMenuItem INTEGER,
      menuItemId INTEGER,
      selectedVariationId INTEGER,
      FOREIGN KEY (orderId) REFERENCES $ordersTable (id),
      FOREIGN KEY (itemId) REFERENCES $menuItemsTable (id),
      FOREIGN KEY (menuItemId) REFERENCES $menuItemsTable (id),
      FOREIGN KEY (selectedVariationId) REFERENCES $menuItemVariationsTable (id)
    )
  ''');

    // Create the 'MenuItemReviews' table for storing reviews
    await db.execute('''
    CREATE TABLE $menuItemReviewsTable (
      id INTEGER PRIMARY KEY,
      itemId INTEGER,
      customerId INTEGER,
      rating FLOAT,
      reviewText TEXT,
      reviewDate DATETIME
    )
  ''');

    // Create the 'paymentModeTable' table for storing payment Methods
    await db.execute('''
    CREATE TABLE $paymentModeTable ( 
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      paymentMethodName TEXT, 
      uniqueHashId TEXT UNIQUE 
    )
  ''');

    // Create the 'invoices' table
    await db.execute('''
    CREATE TABLE $invoicesTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      orderId INTEGER,  -- Reference to the ordersTable id
      invoiceHashId TEXT,
      taxPercentage REAL,
      discountType INTEGER,
      discountAmount REAL,
      totalCost REAL,
      taxCost REAL,
      taxableAmount REAL,
      netPaymentAmount REAL,
      createdDate TEXT,
      modifiedDate TEXT,
      customerId INTEGER,
      customerName TEXT,
      phoneNumber TEXT,
      paymentModeId INTEGER,
      paymentMethodName TEXT,
      recordAmountPaid REAL,
      paymentMethodDetails TEXT NULL,
      FOREIGN KEY (orderId) REFERENCES $ordersTable (id),
      FOREIGN KEY (customerId) REFERENCES $customersTable (id),
      FOREIGN KEY (paymentModeId) REFERENCES $paymentModeTable (id)
    )
  ''');

    // Create the 'recipeModelTable'
    await db.execute('''
    CREATE TABLE $recipeModelTable(
      recipe_id INTEGER PRIMARY KEY AUTOINCREMENT,
      id INTEGER,
      recipe_name TEXT,
      translated_recipe_name TEXT,
      recipe_ingredients TEXT,
      recipe_translated_ingredients TEXT,
      recipe_preparation_time_in_mins INTEGER,
      recipe_cooking_time_in_mins INTEGER,
      recipe_total_time_in_mins INTEGER,
      recipe_servings INTEGER,
      recipe_cuisine TEXT,
      recipe_course TEXT,
      recipe_diet TEXT,
      recipe_instructions TEXT,
      recipe_translated_instructions TEXT,
      recipe_reference_url TEXT,
      isBookmark INTEGER
    )
  ''');

    // Create the 'employeesTable'
    await db.execute('''
    CREATE TABLE $employeesTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      creationDate TEXT,
      modificationDate TEXT,
      phoneNumber TEXT,
      position TEXT,
      joiningDate TEXT,
      leavingDate TEXT,
      startWorkingTime TEXT,
      endWorkingTime TEXT,
      workingHours TEXT,
      isDeleted INTEGER
    )
  ''');

    // Create the 'attendanceTable'
    await db.execute('''
    CREATE TABLE $attendanceTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      employeeId INTEGER,
      currentStatus INTEGER,
      creationDate TEXT,
      modificationDate TEXT,
      checkIn TEXT,
      checkOut TEXT,
      employeeWorkingDurations TEXT,
      workingTimeDurations TEXT,
      isDeleted INTEGER,
      FOREIGN KEY (employeeId) REFERENCES $employeesTable (id)
    )
  ''');

    // Create the 'leavesTable'
    await db.execute('''
    CREATE TABLE $leavesTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      employeeId INTEGER,
      currentStatus INTEGER,
      creationDate TEXT,
      modificationDate TEXT,
      startDate TEXT,
      endDate TEXT,
      reason TEXT,
      isDeleted INTEGER,
      FOREIGN KEY (employeeId) REFERENCES $employeesTable (id)
    )
  ''');
    // 1 for enabled, 0 for disabled
    await db.execute('''
      CREATE TABLE $inventoryTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        hashId TEXT,
        name TEXT,
        shortDescription TEXT,
        purchaseUnit TEXT,
        currentStock REAL,
        isEnabled INTEGER DEFAULT 1,
        createdDate TEXT,
        modifiedDate TEXT
      )
    ''');

    await db.execute('''
    CREATE TABLE $purchaseTable(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      hashId TEXT,
      inventoryId INTEGER,
      name TEXT,
      purchaseUnit TEXT,
      purchaseQty REAL,
      purchaseDateTime TEXT,
      purchasePrice REAL,
      createdDate TEXT,
      modifiedDate TEXT,
      FOREIGN KEY (inventoryId) REFERENCES $inventoryTable(id)
    )
  ''');
  }

  Future<void> insertRecipes(List<RecipeModel> recipes) async {
    final db = await database;
    const batchSize = 100; // Adjust batch size as needed

    for (var i = 0; i < recipes.length; i += batchSize) {
      var batch = db!.batch();
      final chunk = recipes.sublist(
          i, i + batchSize > recipes.length ? recipes.length : i + batchSize);

      for (var recipe in chunk) {
        final data = recipe.toJson();
        // Constants.debugLog(DatabaseHelper, "insertRecipes:data:$data");
        batch.insert(recipeModelTable, data);
      }

      await batch.commit(noResult: true);
    }
  }

  Future<int?> updateRecipe(RecipeModel recipe) async {
    final db = await database;
    if (db == null) return null; // Handle null database scenario
    int? rowsAffected = await db.update(
      recipeModelTable,
      recipe.toJson(),
      where: 'recipe_id = ?',
      whereArgs: [recipe.id],
    );
    return rowsAffected;
  }

  Future<int?> deleteRecipe({int? id}) async {
    final db = await database;
    if (db == null) return null;

    return await db.transaction<int>((txn) async {
      return await txn.delete(
        recipeModelTable,
        where: 'recipe_id = ?',
        whereArgs: [id],
      );
    });
  }

  Future<List<RecipeModel>?> getRecipes() async {
    final db = await database;
    if (db == null) return null;

    final List<Map<String, dynamic>> maps = await db.query(recipeModelTable);
    return List.generate(maps.length, (i) {
      return RecipeModel(
        recipeID: maps[i]['recipe_id'],
        id: maps[i]['id'],
        recipeName: maps[i]['recipe_name'],
        translatedRecipeName: maps[i]['translated_recipe_name'],
        recipeIngredients: maps[i]['recipe_ingredients'],
        recipeTranslatedIngredients: maps[i]['recipe_translated_ingredients'],
        recipePreparationTimeInMins: maps[i]['recipe_preparation_time_in_mins'],
        recipeCookingTimeInMins: maps[i]['recipe_cooking_time_in_mins'],
        recipeTotalTimeInMins: maps[i]['recipe_total_time_in_mins'],
        recipeServings: maps[i]['recipe_servings'],
        recipeCuisine: maps[i]['recipe_cuisine'],
        recipeCourse: maps[i]['recipe_course'],
        recipeDiet: maps[i]['recipe_diet'],
        recipeInstructions: maps[i]['recipe_instructions'],
        recipeTranslatedInstructions: maps[i]['recipe_translated_instructions'],
        recipeReferenceUrl: maps[i]['recipe_reference_url'],
        isBookmark: maps[i]['isBookmark'] == 1, // Convert INTEGER to boolean
      );
    });
  }

  Future<List<RecipeModel>> getBookmarkedRecipes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(recipeModelTable,
        where: 'isBookmark = ?',
        whereArgs: [1]); // Filter where isBookmark column equals 1
    return List.generate(maps.length, (i) {
      return RecipeModel(
        recipeID: maps[i]['recipe_id'],
        id: maps[i]['id'],
        recipeName: maps[i]['recipe_name'],
        translatedRecipeName: maps[i]['translated_recipe_name'],
        recipeIngredients: maps[i]['recipe_ingredients'],
        recipeTranslatedIngredients: maps[i]['recipe_translated_ingredients'],
        recipePreparationTimeInMins: maps[i]['recipe_preparation_time_in_mins'],
        recipeCookingTimeInMins: maps[i]['recipe_cooking_time_in_mins'],
        recipeTotalTimeInMins: maps[i]['recipe_total_time_in_mins'],
        recipeServings: maps[i]['recipe_servings'],
        recipeCuisine: maps[i]['recipe_cuisine'],
        recipeCourse: maps[i]['recipe_course'],
        recipeDiet: maps[i]['recipe_diet'],
        recipeInstructions: maps[i]['recipe_instructions'],
        recipeTranslatedInstructions: maps[i]['recipe_translated_instructions'],
        recipeReferenceUrl: maps[i]['recipe_reference_url'],
        isBookmark: maps[i]['isBookmark'] == 1,
      );
    });
  }

  // Method to backup the database with the current date
  Future<void> backupDatabase() async {
    final database = await _instance.database;
    if (database == null) return;

    // Close the database before copying to ensure consistency
    await database.close();

    final String databasePath = await getDatabasesPath();

    final String originalPath = join(databasePath, 'restaurant.db');

    // Get the current date to append to the backup file name
    final String currentDate = DateFormat('yyyyMMdd').format(DateTime.now());

    final String backupFileName = 'restaurant_backup_$currentDate.db';
    final String backupPath = join(databasePath, backupFileName);

    // Copy the original database file to the backup location
    await File(originalPath).copy(backupPath);

    // Re-open the database after backup
    _database = await openDatabase(
      originalPath,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Method to restore the database from a backup file
  Future<void> restoreDatabase(String backupFilePath) async {
    final database = await _instance.database;
    if (database == null) return;

    // Close the database before restoring to ensure consistency
    await database.close();

    final String databasePath = await getDatabasesPath();
    final String originalPath = join(databasePath, 'restaurant.db');

    try {
      // Copy the contents of the backup file to the original database file
      await File(backupFilePath).copy(originalPath);
      print('Database restored successfully');

      // Re-open the database after restore
      _database = await openDatabase(
        originalPath,
        version: 1,
        onCreate: _onCreate,
      );
    } catch (e) {
      print('Error restoring database: $e');

      // Handle conflict or other errors
      // Example: Log the error, inform the user, or take appropriate action
      if (e is FileSystemException && e.osError?.errorCode == 13) {
        print(
            'Permission denied. Please make sure you have the necessary permissions.');
      } else {
        print('An unexpected error occurred during database restore.');
      }
    }
  }

  // Method to schedule daily backup
  void scheduleDailyBackup() {
    NotificationApi.init(initSchedluled: true);
    NotificationApi.requestNotificationPermission();
    NotificationApi.showScheduledNotificationDailyBase(
      time: DateTime.now().add(
        const Duration(seconds: 3),
      ),
      // time: DateUtil.stringToDate("12:00:00 pm", "HH:mm:ss aaa"),
    );
    backupDatabase();
  }

  // Category CRUD operations
  Future<int?> addCategory(Category category) async {
    final db = await database;
    Category? model = await getCategoryBasedOnName(name: category.name);
    if (model == null) {
      return await db?.insert(categoriesTable, category.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    return null;
  }

  Future<List<Category>?> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>>? maps = await db?.query(
      categoriesTable,
      orderBy: 'name ASC', // Order by the 'name' column in ascending order
    );

    if (maps == null) {
      return null;
    }

    return List.generate(maps.length, (i) {
      return Category.fromJson(maps[i]);
    });
  }

  Future<int?> updateCategory(Category category) async {
    Constants.debugLog(DatabaseHelper, "updateCategory:${category.toJson()}");
    final db = await database;
    try {
      int? rowsAffected = await db?.update(
        categoriesTable,
        category.toJson(),
        where: 'id = ?',
        whereArgs: [category.id],
      );
      return rowsAffected;
    } catch (e) {
      print('Error updating category: $e');
      return null; // Or handle the error as needed
    }
  }

  Future<Category?> getCategoryBasedOnName({String? name}) async {
    final db = await database;

    if (name != null && name.isNotEmpty) {
      final List<Map<String, dynamic>>? maps = await db?.query(
        categoriesTable,
        where: 'name = ?',
        whereArgs: [name],
        orderBy: 'name ASC',
        limit: 1, // Limit the result to one record
      );

      if (maps == null || maps.isEmpty) {
        return null;
      }

      // Return the first (and only) record as a single object
      return Category.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<Category?> getCategoryBasedOnCategoryId({categoryId}) async {
    final db = await database;

    if (categoryId != null) {
      final List<Map<String, dynamic>>? maps = await db?.query(
        categoriesTable,
        where: 'id = ?',
        whereArgs: [categoryId],
        limit: 1,
      );

      if (maps == null || maps.isEmpty) {
        return null;
      }

      // Return the first (and only) record as a single object
      return Category.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<int?> deleteCategory(int? categoryId) async {
    final db = await database;
    return await db?.delete(
      categoriesTable,
      where: 'id = ?',
      whereArgs: [categoryId],
    );
  }

  // Subcategory CRUD operations
  // Create a new subcategory
  Future<int> createSubcategory(SubCategory subcategory) async {
    final db = await database;
    return await db!.insert(subcategoriesTable, subcategory.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get a list of all subcategories
  Future<List<SubCategory>?> getSubcategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(
      subcategoriesTable,
      orderBy: 'name ASC',
    );
    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return SubCategory.fromJson(maps[i]);
      });
    } else {
      return null;
    }
  }

  // get Subcategory Base CategoryId
  Future<List<SubCategory>?> getSubcategoryBaseCategoryId(
      int categoryId) async {
    final db = await database;
    final List<Map<String, dynamic>?>? maps = await db?.query(
      subcategoriesTable,
      where: 'categoryId = ?',
      whereArgs: [categoryId],
      orderBy: 'name ASC',
    );

    if (maps != null && maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return SubCategory.fromJson(maps[i]!);
      });
    } else {
      return null;
    }
  }

  // Update a subcategory
  Future<int?> updateSubcategory(SubCategory subcategory) async {
    final db = await database;
    return await db!.update(
      subcategoriesTable,
      subcategory.toJson(),
      where: 'id = ?',
      whereArgs: [subcategory.id],
    );
  }

  // Delete a subcategory
  Future<int?> deleteSubcategory(int id) async {
    final db = await database;
    return await db!
        .delete(subcategoriesTable, where: 'id = ?', whereArgs: [id]);
  }

  // Delete all subcategories base on categoryId in batches
  Future<int?> deleteAllSubcategoryBasedOnCategoryId({int? categoryId}) async {
    final db = await database;
    // return await db!
    //     .delete(subcategoriesTable, where: 'id = ?', whereArgs: [id]);

    return await db!.transaction((txn) async {
      // Create a batch
      Batch batch = txn.batch();
      // Add delete operation to the batch
      batch.delete(
        subcategoriesTable,
        where: 'categoryId = ?',
        whereArgs: [categoryId],
      );
      // Commit the batch
      await batch.commit(noResult: true);
    });
  }

  // Insert a subcategories in batch with the specified ID from the database.
  Future<void> insertSubCategoriesForCategoryId({
    required int? categoryId,
    required List<SubCategory> subCategories,
  }) async {
    final db = await database;
    if (subCategories.isNotEmpty) {
      await db!.transaction((txn) async {
        Batch batch = txn.batch();
        for (SubCategory subCategory in subCategories) {
          batch.insert(subcategoriesTable, subCategory.toJson());
        }
        await batch.commit(noResult: true);
      });
    }
  }

  /*Menu Items CRUD operations*/
  // Create a new menu item
  Future<int?> createMenuItem(MenuItem menuItem) async {
    int isTodayAvailable = menuItem.isTodayAvailable != null
        ? menuItem.isTodayAvailable!
            ? 1
            : 0
        : 0;
    int isSimpleVariation =
        menuItem.isSimpleVariation == null || menuItem.isSimpleVariation == true
            ? 1
            : 0;

    try {
      final db = await database;

      // Insert the MenuItem into the menuItemsTable
      int menuItemId = await _insertMenuItem(
          db!, menuItem, isTodayAvailable, isSimpleVariation);

      // If the MenuItem has variations and isSimpleVariation is true, insert them into the menuItemVariationsTable
      if (menuItem.isSimpleVariation == true &&
          menuItem.variations != null &&
          menuItem.variations!.isNotEmpty) {
        await _insertVariations(db, menuItem.variations!, menuItemId);
      }

      return menuItemId;
    } catch (e) {
      print("Error creating menu item: $e");
      return null;
    }
  }

  Future<int> _insertMenuItem(Database db, MenuItem menuItem,
      int isTodayAvailable, int isSimpleVariation) async {
    return await db.insert(
      menuItemsTable,
      {
        'name': menuItem.name,
        'description': menuItem.description,
        'foodType': menuItem.foodType,
        'creationDate': menuItem.creationDate,
        'duration': menuItem.duration,
        'categoryId': menuItem.categoryId,
        'subcategoryId': menuItem.subcategoryId,
        'isTodayAvailable': isTodayAvailable,
        'isSimpleVariation': isSimpleVariation,
        'costPrice': menuItem.costPrice,
        'sellingPrice': menuItem.sellingPrice,
        'stockQuantity': menuItem.stockQuantity,
        'quantity': menuItem.quantity,
        'purchaseUnit': menuItem.purchaseUnit,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _insertVariations(
      Database db, List<MenuItemVariation>? variations, int menuItemId) async {
    await db.transaction((txn) async {
      // Create a batch
      Batch batch = txn.batch();

      for (int i = 0; i < variations!.length; i++) {
        // Set isTodayAvailable to 0 if not provided (false) or 1 if true
        int isTodayAvailableVariation = variations[i].isTodayAvailable != null
            ? variations[i].isTodayAvailable!
                ? 1
                : 0
            : 0;

        // Set menuItemId for the variation
        variations[i].menuItemId = menuItemId;

        // Insert the MenuItemVariation into the menuItemVariationsTable
        batch.insert(
          '$MenuItemVariation',
          {
            'menuItemId': variations[i].menuItemId,
            'quantity': variations[i].quantity,
            'purchaseUnit': variations[i].purchaseUnit,
            'isTodayAvailable': isTodayAvailableVariation,
            'costPrice': variations[i].costPrice,
            'sellingPrice': variations[i].sellingPrice,
            'stockQuantity': variations[i].stockQuantity,
            'sortOrderIndex': i,
            'creationDate': variations[i].creationDate,
          },
        );
      }

      // Commit the batch
      await batch.commit(noResult: true);
    });
  }

  // Updating exist menu item info
  Future<int?> updateMenuItem(MenuItem updatedMenuItem) async {
    int isTodayAvailable = updatedMenuItem.isTodayAvailable != null
        ? updatedMenuItem.isTodayAvailable!
            ? 1
            : 0
        : 0;

    try {
      final db = await database;

      // Update the MenuItem in the menuItemsTable
      int result =
          await _updateMenuItem(db!, updatedMenuItem, isTodayAvailable);

      // Handle variations
      if (!updatedMenuItem.isSimpleVariation!) {
        // Delete existing variations and insert new ones in batches
        await updateMenuItemVariations(
            db, updatedMenuItem.variations ?? [], updatedMenuItem.id!);
      }

      return result;
    } catch (e) {
      print("Error updating menu item: $e");
      return null;
    }
  }

  Future<int> _updateMenuItem(
      Database db, MenuItem updatedMenuItem, int isTodayAvailable) async {
    return await db.update(
      menuItemsTable,
      {
        'name': updatedMenuItem.name,
        'description': updatedMenuItem.description,
        'creationDate': updatedMenuItem.creationDate,
        'foodType': updatedMenuItem.foodType,
        'modificationDate': updatedMenuItem.modificationDate,
        'duration': updatedMenuItem.duration,
        'categoryId': updatedMenuItem.categoryId,
        'subcategoryId': updatedMenuItem.subcategoryId,
        'isTodayAvailable': isTodayAvailable,
        'isSimpleVariation': updatedMenuItem.isSimpleVariation == null ||
                updatedMenuItem.isSimpleVariation == true
            ? 1
            : 0,
        'costPrice': updatedMenuItem.costPrice,
        'sellingPrice': updatedMenuItem.sellingPrice,
        'stockQuantity': updatedMenuItem.stockQuantity,
        'quantity': updatedMenuItem.quantity,
        'purchaseUnit': updatedMenuItem.purchaseUnit,
      },
      where: 'id = ?',
      whereArgs: [updatedMenuItem.id],
    );
  }

  Future<void> updateMenuItemVariations(
      Database db, List<MenuItemVariation> variations, int menuItemId) async {
    await db.transaction((txn) async {
      // Delete existing variations
      await txn.delete(
        menuItemVariationsTable,
        where: 'menuItemId = ?',
        whereArgs: [menuItemId],
      );

      // Insert new variations if available
      if (variations.isNotEmpty) {
        Batch batch = txn.batch();
        for (MenuItemVariation variation in variations) {
          int isTodayAvailableVariation = variation.isTodayAvailable != null
              ? variation.isTodayAvailable!
                  ? 1
                  : 0
              : 0;

          batch.insert(
            menuItemVariationsTable,
            {
              'menuItemId': menuItemId,
              'quantity': variation.quantity,
              'purchaseUnit': variation.purchaseUnit,
              'isTodayAvailable': isTodayAvailableVariation,
              'costPrice': variation.costPrice,
              'sellingPrice': variation.sellingPrice,
              'stockQuantity': variation.stockQuantity,
              'creationDate': variation.creationDate,
              'modificationDate': variation.modificationDate,
            },
          );
        }
        await batch.commit(noResult: true);
      }
    });
  }

  Future<MenuItem> _createMenuItemFromMap(
      Database db, Map<String, Object?> map) async {
    if (map['isSimpleVariation'] == 1) {
      // Create a MenuItem object without variations
      return MenuItem(
        id: map['id'] as int?,
        name: map['name'] as String?,
        description: map['description'] as String?,
        creationDate: map['creationDate'] as String?,
        modificationDate: map['modificationDate'] as String?,
        duration: map['duration'] as int?,
        categoryId: map['categoryId'] as int?,
        subcategoryId: map['subcategoryId'] as int?,
        isTodayAvailable: map['isTodayAvailable'] == 1,
        isSimpleVariation: map['isSimpleVariation'] == 1,
        costPrice: map['costPrice'] as double?,
        sellingPrice: map['sellingPrice'] as double?,
        stockQuantity: map['stockQuantity'] as double?,
        quantity: map['quantity'] as String?,
        purchaseUnit: map['purchaseUnit'] as String?,
      );
    } else {
      // Fetch variations for the current menu item
      List<Map<String, dynamic>> variationsMaps = await db.query(
        menuItemVariationsTable,
        orderBy: 'sortOrderIndex ASC',
        where: 'menuItemId = ?',
        whereArgs: [map['id']],
      );

      // Convert the List<Map> to a List<MenuItemVariation>
      List<MenuItemVariation> variations = [];
      for (var j = 0; j < variationsMaps.length; j++) {
        final variation = MenuItemVariation(
            id: variationsMaps[j]['id'] as int?,
            menuItemId: variationsMaps[j]['menuItemId'] as int?,
            isTodayAvailable: variationsMaps[j]['isTodayAvailable'] == 1,
            quantity: variationsMaps[j]['quantity'] as int?,
            purchaseUnit: variationsMaps[j]['purchaseUnit'] as String?,
            costPrice: variationsMaps[j]['costPrice'] as double?,
            sellingPrice: variationsMaps[j]['sellingPrice'] as double?,
            stockQuantity: variationsMaps[j]['stockQuantity'] as int?,
            sortOrderIndex: variationsMaps[j]['sortOrderIndex'] as int?,
            creationDate: variationsMaps[j]['creationDate'] as String?,
            modificationDate: variationsMaps[j]['modificationDate'] as String?);
        variations.add(variation);
      }

      // Create a MenuItem object with variations
      return MenuItem(
        id: map['id'] as int?,
        name: map['name'] as String?,
        foodType: map['foodType'] as String?,
        description: map['description'] as String?,
        creationDate: map['creationDate'] as String?,
        modificationDate: map['modificationDate'] as String?,
        duration: map['duration'] as int?,
        categoryId: map['categoryId'] as int?,
        subcategoryId: map['subcategoryId'] as int?,
        isTodayAvailable: map['isTodayAvailable'] == 1,
        isSimpleVariation: map['isSimpleVariation'] == 1,
        costPrice: map['costPrice'] as double?,
        sellingPrice: map['sellingPrice'] as double?,
        stockQuantity: map['stockQuantity'] as double?,
        quantity: map['quantity'] as String?,
        purchaseUnit: map['purchaseUnit'] as String?,
        variations: variations,
      );
    }
  }

  // Get a single menu item by ID
  Future<MenuItem?> getMenuItemById(int id) async {
    final db = await database;

    // Perform a query to retrieve the menu item with the given ID
    final List<Map<String, Object?>> maps = await db!.query(
      menuItemsTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    // If the result is empty, return null
    if (maps.isEmpty) {
      return null;
    }

    // Convert the Map to a MenuItem
    final MenuItem menuItem = await _createMenuItemFromMap(db, maps[0]);

    // If it's a simple variation, return the MenuItem without variations
    if (menuItem.isSimpleVariation == true) {
      return menuItem;
    }

    // Fetch variations for the current menu item
    final List<Map<String, Object?>> variationsMaps = await db.query(
      menuItemVariationsTable,
      where: 'menuItemId = ?',
      whereArgs: [id],
    );

    // Convert the List<Map> to a List<MenuItemVariation>
    final List<MenuItemVariation> variations = variationsMaps
        .map((variationMap) => MenuItemVariation.fromJson(variationMap))
        .toList();

    // Attach variations to the MenuItem and return
    return menuItem.copyWith(variations: variations);
  }

  // Get a list of all menu items
  Future<List<MenuItem>> getAllMenuItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(menuItemsTable);

    // Convert the List<Map<String, dynamic>> to a List<MenuItem>
    return Future.wait(maps.map((map) async {
      int menuItemId = map['id'];
      List<Map<String, dynamic>> variationsMap = await db.query(
          menuItemVariationsTable,
          orderBy: 'sortOrderIndex ASC',
          where: 'menuItemId = ?',
          whereArgs: [menuItemId]);

      List<MenuItemVariation> variations = variationsMap
          .map((variationMap) => MenuItemVariation.fromJson(variationMap))
          .toList();

      return MenuItem(
        id: map['id'],
        name: map['name'],
        foodType: map['foodType'],
        description: map['description'],
        creationDate: map['creationDate'] ?? '',
        modificationDate: map['modificationDate'] ?? '',
        duration: map['duration'],
        categoryId: map['categoryId'],
        subcategoryId: map['subcategoryId'],
        isTodayAvailable: map['isTodayAvailable'] != null
            ? map['isTodayAvailable'] == 1
            : false,
        isSimpleVariation: map['isTodayAvailable'] != null
            ? map['isSimpleVariation'] == 1
            : true,
        costPrice: map['costPrice']?.toDouble(),
        sellingPrice: map['sellingPrice']?.toDouble(),
        stockQuantity: map['stockQuantity']?.toDouble(),
        quantity: map['quantity'],
        purchaseUnit: map['purchaseUnit'],
        variations: variations,
      );
    }).toList());
  }

  //Enable available of menu item available of that date
  Future<List<MenuItem>> getAvailableMenuItems() async {
    final db = await database;
    final maps = await db!.query(menuItemsTable);

    List<MenuItem> menuItems = [];
    for (var map in maps) {
      MenuItem menuItem = MenuItem.fromJson(map);

      // Check if isTodayAvailable is true and isSimpleVariation is false for the main item
      if (menuItem.isTodayAvailable == true &&
          menuItem.isSimpleVariation == false) {
        // Fetch variations for the current menu item
        List<MenuItemVariation> variations =
            await _getMenuItemVariations(menuItem.id!);

        // Check if at least one variation has isTodayAvailable as true
        if (variations.isEmpty ||
            variations.any((variation) => variation.isTodayAvailable == true)) {
          menuItem.variations = variations;
          menuItems.add(menuItem);
        }
      }
    }

    return menuItems;
  }

  Future<List<MenuItemVariation>> _getMenuItemVariations(
      int? menuItemId) async {
    final db = await database;
    final maps = await db!.query(
      menuItemVariationsTable,
      orderBy: 'sortOrderIndex ASC',
      where: 'menuItemId = ?',
      whereArgs: [menuItemId],
    );

    return List.generate(maps.length, (i) {
      return MenuItemVariation.fromJson(maps[i]);
    });
  }

  // Delete a menu item
  Future<void> deleteMenuItem(int? menuItemId) async {
    final db = await database;

    await db!.transaction((txn) async {
      // Delete variations first
      await txn.delete(menuItemVariationsTable,
          where: 'menuItemId = ?', whereArgs: [menuItemId!]);

      // Delete the menu item
      await txn
          .delete(menuItemsTable, where: 'id = ?', whereArgs: [menuItemId]);
    });
  }

  // Customer CRUD operations
  // Create a new customer
  Future<int> createCustomer(Customer customer) async {
    final db = await database;
    return await db!.insert(customersTable, customer.toJson());
  }

  // Get a list of all customers
  Future<List<Customer>> getCustomers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(
      customersTable,
    );
    return List.generate(maps.length, (i) {
      return Customer.fromJson(maps[i]);
    });
  }

// Get a single customer by ID
  Future<Customer?> getCustomer(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(
      customersTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Customer.fromJson(maps.first);
    } else {
      return null;
    }
  }

//search List
  Future<List<Customer>?> searchCustomers(String searchTerm) async {
    final db = await database;
    final List<Map<String, dynamic>>? maps = await db?.query(
      customersTable,
      where: 'name LIKE ? OR phoneNumber LIKE ?',
      whereArgs: ['%$searchTerm%', '%$searchTerm%'],
      orderBy: 'name ASC', // Order the results by name in ascending order
    );

    if (maps == null) {
      return null; // Return null if there's an error or no data
    }

    return List.generate(maps.length, (i) {
      return Customer.fromJson(maps[i]);
    });
  }

  Future<Customer?> searchCustomer(String searchTerm) async {
    final db = await database;
    final List<Map<String, dynamic>>? maps = await db?.query(
      customersTable,
      where: 'name LIKE ? OR phoneNumber LIKE ?',
      whereArgs: ['%$searchTerm%', '%$searchTerm%'],
      orderBy: 'name ASC', // Order the results by name in ascending order
    );

    if (maps == null || maps.isEmpty) {
      return null; // Return null if there's an error or no matching data
    }

    return Customer.fromJson(maps[0]); // Return the first matching customer
  }

  Future<bool> isCustomerExist(String searchTerm) async {
    final db = await database;
    final List<Map<String, dynamic>>? maps = await db?.query(
      customersTable,
      where: 'name LIKE ? OR phoneNumber LIKE ?',
      whereArgs: ['%$searchTerm%', '%$searchTerm%'],
    );

    return maps != null && maps.isNotEmpty;
  }

// Update a customer
  Future<int?> updateCustomer(Customer customer) async {
    final db = await database;
    return await db!.update(
      customersTable,
      customer.toJson(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

// Delete a customer
  Future<int?> deleteCustomer(int id) async {
    final db = await database;
    return await db!.delete(customersTable, where: 'id = ?', whereArgs: [id]);
  }

  // TableInfo CRUD operations
  // Create a new table info
  Future<int?> addTableInfo(TableInfoModel newTableInfo) async {
    final db = await database;

    // Use a subquery to get the maximum sortOrderIndex
    final List<
        Map<String,
            dynamic>> maxSortRecordIndexResult = await db!.rawQuery(
        'SELECT COALESCE(MAX(sortOrderIndex), -1) AS maxIndex FROM $tableInfoTable');

    int? maxSortRecordIndex =
        Sqflite.firstIntValue(maxSortRecordIndexResult) ?? -1;

    // Automatically generate sortOrderIndex based on the last position
    newTableInfo.sortOrderIndex = maxSortRecordIndex + 1;

    // Use the INSERT statement with a subquery to automatically set sortOrderIndex
    return await db.rawInsert('''
    INSERT INTO $tableInfoTable (name, sortOrderIndex, nosOfChairs, colorValue)
    VALUES (?, ?, ?, ?)
  ''', [
      newTableInfo.name,
      newTableInfo.sortOrderIndex,
      newTableInfo.nosOfChairs,
      newTableInfo.colorValue
    ]);
  }

// Get a list of all table infos
  Future<List<TableInfoModel>?> getTableInfos() async {
    final db = await database;
    final List<Map<String, dynamic>>? maps = await db?.query(
      tableInfoTable,
      orderBy:
          'sortOrderIndex ASC', // Order by sortOrderIndex in ascending order
    );

    if (maps == null) {
      return null;
    }

    return List.generate(maps.length, (i) {
      return TableInfoModel.fromJson(maps[i]);
    });
  }

// Get a single table info by ID
  Future<TableInfoModel?> getTableInfo(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(
      tableInfoTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TableInfoModel.fromJson(maps.first);
    } else {
      return null;
    }
  }

// Update a table info
  Future<int?> updateTableInfo(TableInfoModel tableInfo) async {
    final db = await database;
    return await db!.update(
      tableInfoTable,
      tableInfo.toJson(),
      where: 'id = ?',
      whereArgs: [tableInfo.id],
    );
  }

  Future<int?> getTableInfoRecordCount() async {
    final db = await database;
    final List<Map<String, dynamic>> result =
        await db!.rawQuery('SELECT COUNT(*) AS count FROM $tableInfoTable');
    final int recordCount = Sqflite.firstIntValue(result) ?? 0;
    return recordCount;
  }

// Delete a table info
  Future<int?> deleteTableInfo(TableInfoModel model) async {
    final db = await database;

    // Start a transaction to ensure atomicity
    return db!.transaction((txn) async {
      int sortRecordIndexToDelete = model.sortOrderIndex ?? 0;

      // Step 1: Delete the item from the database
      int rowsAffected = await txn
          .delete(tableInfoTable, where: 'id = ?', whereArgs: [model.id]);

      // Step 2: Decrement the sortOrderIndex for items with a higher index
      await txn.rawUpdate(
        'UPDATE $tableInfoTable SET sortOrderIndex = sortOrderIndex - 1 WHERE sortOrderIndex > ?',
        [sortRecordIndexToDelete],
      );

      // Return the result of the transaction
      return rowsAffected;
    });
  }

  // Orders CRUD operations
// Create new order
  Future<int?> createNewOrder(OrderModel order) async {
    try {
      final db = await database;
      final orderId = await db!.insert(
        ordersTable,
        order.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Iterate through order items and insert into orderItemsTable
      for (final orderItem in order.orderItems) {
        await db.insert(
          orderItemsTable,
          {
            'orderId': orderId,
            'itemId': orderItem!.itemId,
            'quantity': orderItem.quantity,
            'status': orderItem.status,
            'isMenuItem':
                (orderItem.isMenuItem != null && orderItem.isMenuItem == true)
                    ? 1
                    : 0,
            'menuItemId': orderItem.menuItem?.id,
            'selectedVariationId': orderItem.selectedVariation?.id,
            'sellingPrice': orderItem.sellingPrice, // Add selling price
            'costPrice': orderItem.costPrice, // Add cost price
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      return orderId;

      return null;
    } catch (e) {
      print("Error creating order: $e");
      return null;
    }
  }

// Update Order
  Future<void> updateOrder(OrderModel order) async {
    try {
      final db = await database;

      // Update the order table
      await db!.update(
        ordersTable,
        order.toJson(),
        where: 'id = ?',
        whereArgs: [order.id],
      );

      // Delete existing order items for the order
      await db.delete(
        orderItemsTable,
        where: 'orderId = ?',
        whereArgs: [order.id],
      );

      // Insert the updated order items
      final batch = db.batch();
      for (final orderItem in order.orderItems) {
        batch.insert(
          orderItemsTable,
          {
            'orderId': order.id,
            'itemId': orderItem!.itemId,
            'quantity': orderItem.quantity,
            'status': orderItem.status,
            'isMenuItem':
                (orderItem.isMenuItem != null && orderItem.isMenuItem == true)
                    ? 1
                    : 0,
            'menuItemId': orderItem.menuItem?.id,
            'selectedVariationId': orderItem.selectedVariation?.id,
            'sellingPrice': orderItem.sellingPrice,
            'costPrice': orderItem.costPrice
          },
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      print("Error updating order: $e");
    }
  }

  // Read a Single Order by ID:
  Future<OrderModel?> getOrderInfo(int orderId) async {
    try {
      final db = await database;

      final List<Map<String, dynamic>> orderResult = await db!.query(
        ordersTable,
        where: 'id = ?',
        whereArgs: [orderId],
      );

      if (orderResult.isNotEmpty) {
        final Map<String, dynamic> orderData = orderResult.first;

        final List<Map<String, dynamic>> orderItemsResult = await db.query(
          orderItemsTable,
          where: 'orderId = ?',
          whereArgs: [orderId],
        );

        final List<OrderItem?> orderItems = orderItemsResult
            .map((orderItemData) => OrderItem.fromJson(orderItemData))
            .toList();

        orderData['orderItems'] = orderItems;

        final OrderModel orderModel = OrderModel.fromJson(orderData);
        return orderModel;
      }

      return null; // Return null if order with given ID is not found
    } catch (e) {
      print("Error fetching order info: $e");
      return null;
    }
  }

  // Delete temporally Order
  Future<int?> updateOrderIsDeleted(int orderId, bool isDeleted) async {
    final db = await database;

    // Get the current status of the order
    final currentStatus =
        isDeleted ? OrderStatus.deleted : OrderStatus.newOrder;

    // Update the isDeleted and status fields in ordersTable
    final currentDate = DateTime.now().toIso8601String();

    await db!.update(
      ordersTable,
      {
        'isDeleted': isDeleted ? 1 : 0,
        'status': currentStatus.name,
        if (!isDeleted) 'creationDate': currentDate,
        if (!isDeleted) 'modificationDate': currentDate,
      },
      where: 'id = ?',
      whereArgs: [orderId],
    );

    // Update the status of associated order items in orderItemsTable
    final orderItemsUpdateCount = await db.update(
      orderItemsTable,
      {
        'status': isDeleted
            ? OrderItemStatus.deleted.name
            : OrderItemStatus.newOrder.name
      },
      where: 'orderId = ?',
      whereArgs: [orderId],
    );

    return orderItemsUpdateCount;
  }

  // await updateOrderIsCanceled(orderId, true);
  Future<int?> updateOrderIsCanceled(int orderId, bool isCanceled) async {
    final db = await database;

    // Get the current status of the order
    final currentStatus = isCanceled
        ? OrderStatus.canceled.toString()
        : OrderStatus.newOrder.toString();

    // Get the current date and time
    final currentDate = DateTime.now().toIso8601String();

    // Update the isCanceled, status, and dates fields in ordersTable

    await db!.update(
      ordersTable,
      {
        'isCanceled': isCanceled ? 1 : 0,
        'status': currentStatus,
        if (isCanceled) 'modificationDate': currentDate,
      },
      where: 'id = ?',
      whereArgs: [orderId],
    );

    // Update the status of associated order items in orderItemsTable
    final orderItemsUpdateCount = await db.update(
      orderItemsTable,
      {
        'status':
            isCanceled ? OrderItemStatus.canceled : OrderItemStatus.newOrder,
      },
      where: 'orderId = ?',
      whereArgs: [orderId],
    );

    return orderItemsUpdateCount;
  }

  //get all order list
  Future<List<OrderModel>> getAllOrders() async {
    final db = await database;

    // Fetch all orders with their associated items, ordered by creationDate in descending order
    final ordersData = await db!.query(
      ordersTable,
      orderBy: 'creationDate DESC',
    );
    final orderItemsData = await db.query(orderItemsTable);

    // Create a map of order ID to a list of associated order items
    final Map<int, List<OrderItem>> orderItemsMap = {};
    for (final orderItemData in orderItemsData) {
      final orderItem = OrderItem.fromJson(orderItemData);
      final orderId = orderItem.orderId;

      if (!orderItemsMap.containsKey(orderId)) {
        orderItemsMap[orderId!] = [];
      }

      orderItemsMap[orderId]!.add(orderItem);
    }

    // Create a list of OrderModel objects with associated order items
    final List<OrderModel> orders = [];
    for (final orderData in ordersData) {
      final order = OrderModel.fromJson(orderData);

      final orderId = order.id;
      if (orderItemsMap.containsKey(orderId)) {
        order.orderItems = orderItemsMap[orderId]!;
      } else {
        order.orderItems = [];
      }

      orders.add(order);
    }

    return orders;
  }

  //to get all Active orders list expect deleted one
  Future<List<OrderModel>> getAllActiveOrders() async {
    final db = await database;

    // Fetch active orders (isDeleted == false) with their associated items, ordered by creationDate in descending order
    final ordersData = await db!.query(
      ordersTable,
      where: 'isDeleted = ?',
      whereArgs: [0], // 0 for false
      orderBy: 'creationDate DESC',
    );
    final orderItemsData = await db.query(orderItemsTable);

    // Create a map of order ID to a list of associated order items
    final Map<int, List<OrderItem>> orderItemsMap = {};
    for (final orderItemData in orderItemsData) {
      final orderItem = OrderItem.fromJson(orderItemData);
      final orderId = orderItem.orderId;

      if (!orderItemsMap.containsKey(orderId)) {
        orderItemsMap[orderId!] = [];
      }

      orderItemsMap[orderId]!.add(orderItem);
    }

    // Create a list of OrderModel objects with associated order items
    final List<OrderModel> activeOrders = [];
    for (final orderData in ordersData) {
      final order = OrderModel.fromJson(orderData);

      final orderId = order.id;
      if (orderItemsMap.containsKey(orderId)) {
        order.orderItems = orderItemsMap[orderId]!;
      } else {
        order.orderItems = [];
      }

      activeOrders.add(order);
    }

    return activeOrders;
  }

  //all order in progress status
  Future<List<OrderModel>?> getInProgressOrders() async {
    final db = await database;

    // Fetch orders with status inProgress, isCanceled false, and isDeleted false
    final ordersData = await db!.query(
      ordersTable,
      where: 'status = ? AND isCanceled = ? AND isDeleted = ?',
      whereArgs: [OrderStatus.inProgress.index, 0, 0],
      // inProgress, false, false
      orderBy: 'creationDate DESC',
    );

    // Fetch all order items
    final orderItemsData = await db.query(orderItemsTable);

    // Create a map of order ID to a list of associated order items
    final Map<int, List<OrderItem>> orderItemsMap = {};
    for (final orderItemData in orderItemsData) {
      final orderItem = OrderItem.fromJson(orderItemData);
      final orderId = orderItem.orderId;

      if (!orderItemsMap.containsKey(orderId)) {
        orderItemsMap[orderId!] = [];
      }

      orderItemsMap[orderId]!.add(orderItem);
    }

    // Create a list of OrderModel objects with associated order items
    final List<OrderModel> inProgressOrders = [];
    for (final orderData in ordersData) {
      final order = OrderModel.fromJson(orderData);

      final orderId = order.id;
      if (orderItemsMap.containsKey(orderId)) {
        order.orderItems = orderItemsMap[orderId]!;
      } else {
        order.orderItems = [];
      }

      inProgressOrders.add(order);
    }

    return inProgressOrders;
  }

  Future<List<OrderModel>> getNewOrders() async {
    final db = await database;

    // Fetch orders with status newOrder, isCanceled false, and isDeleted false
    final ordersData = await db!.query(
      ordersTable,
      where: 'status = ? AND isCanceled = ? AND isDeleted = ?',
      whereArgs: [OrderStatus.newOrder.index, 0, 0], // newOrder, false, false
      orderBy: 'creationDate DESC',
    );

    // Fetch all order items
    final orderItemsData = await db.query(orderItemsTable);

    // Create a map of order ID to a list of associated order items
    final Map<int, List<OrderItem>> orderItemsMap = {};
    for (final orderItemData in orderItemsData) {
      final orderItem = OrderItem.fromJson(orderItemData);
      final orderId = orderItem.orderId;

      if (!orderItemsMap.containsKey(orderId)) {
        orderItemsMap[orderId!] = [];
      }

      orderItemsMap[orderId]!.add(orderItem);
    }

    // Create a list of OrderModel objects with associated order items
    final List<OrderModel> newOrders = [];
    for (final orderData in ordersData) {
      final order = OrderModel.fromJson(orderData);

      final orderId = order.id;
      if (orderItemsMap.containsKey(orderId)) {
        order.orderItems = orderItemsMap[orderId]!;
      } else {
        order.orderItems = [];
      }

      newOrders.add(order);
    }

    return newOrders;
  }

  Future<List<OrderModel>?> getCurrentOrdersInfo() async {
    var inProgressOrders = await getInProgressOrders();
    var newOrders = await getNewOrders();
    List<OrderModel>? allOrdersList = [];

    if (inProgressOrders != null && inProgressOrders.isNotEmpty) {
      allOrdersList.addAll(inProgressOrders);
    }
    if (newOrders.isNotEmpty) {
      allOrdersList.addAll(newOrders);
    }
    return allOrdersList;
  }

  /*
  // Get a list of order items and their overall total quantity to cook based on order statuses
  Future<List<Map<String, dynamic>>> getOrderedItemsAndTableNumbersByStatusAndFilter(String status) async {
    final db = await database;

    final List<Map<String, dynamic>> results = await db!.rawQuery('''
    SELECT mi.name AS menuItemName, SUM(oi.quantity) AS itemQuantity, GROUP_CONCAT(ti.name, ', ') AS tableInfoNames
    FROM $orderItemsTable oi
    INNER JOIN $menuItemsTable mi ON oi.itemId = mi.id
    INNER JOIN $ordersTable o ON oi.orderId = o.id
    INNER JOIN $tableInfoTable ti ON o.tableInfoId = ti.id
    WHERE o.isCanceled = 0 AND o.isDeleted = 0
      AND o.status = ?
      AND oi.status IN ("newOrder", "inPreparation")
    GROUP BY mi.name
  ''', [status]);

    return results.map((result) {
      return {
        "orderItemName": result['menuItemName'],
        "itemQuantity": result['itemQuantity'],
        "tableInfoNames": result['tableInfoNames'].split(', '),
      };
    }).toList();
  }
*/
  // Get a list of order items and their overall total quantity to cook based on order statuses
  Future<List<Map<String, dynamic>>> getOrderedItemsForKitchen(
      String status) async {
    final db = await database;

    final List<Map<String, dynamic>> results = await db!.rawQuery('''
    SELECT
      mi.name AS menuItemName,
      SUM(oi.quantity) AS TotalOrderedQuantity,
      CASE
        WHEN oi.isMenuItem = 1 THEN mi.quantity
        ELSE miv.quantity
      END AS quantity,
      CASE
        WHEN oi.isMenuItem = 1 THEN mi.purchaseUnit
        ELSE miv.purchaseUnit
      END AS purchaseUnit,
      GROUP_CONCAT(ti.name, ', ') AS tableInfoNames
    FROM $orderItemsTable oi
    LEFT JOIN $menuItemsTable mi ON oi.menuItemId = mi.id AND oi.isMenuItem = 1
    LEFT JOIN $menuItemVariationsTable miv ON oi.selectedVariationId = miv.id AND oi.isMenuItem = 0
    LEFT JOIN $ordersTable o ON oi.orderId = o.id
    LEFT JOIN $tableInfoTable ti ON o.tableInfoId = ti.id
    WHERE o.isCanceled = 0 AND o.isDeleted = 0
      AND o.status = ?
      AND oi.status IN ("inPreparation", "newOrder")
    GROUP BY mi.name, mi.quantity, mi.purchaseUnit, miv.quantity, miv.purchaseUnit
    ORDER BY o.creationDate ASC;
  ''', [status]);

    return results.map((result) {
      return {
        "orderItemName": result['menuItemName'],
        "TotalOrderedQuantity": result['TotalOrderedQuantity'],
        "measureInfoQuantity": result['quantity'],
        "measureInfoPurchaseUnit": result['purchaseUnit'],
        "tableInfoNames": result['tableInfoNames'].split(', '),
      };
    }).toList();
  }

  // CRUD operations for PaymentMode

  Future<int?> insertPaymentMode(PaymentMode paymentMode) async {
    final db = await database;
    return await db!.insert(paymentModeTable, paymentMode.toJson());
  }

  Future<List<PaymentMode>?> getAllPaymentModes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(paymentModeTable);
    return List.generate(maps.length, (index) {
      return PaymentMode.fromJson(maps[index]);
    });
  }

  Future<int> updatePaymentMode(PaymentMode paymentMode) async {
    final db = await database;
    return await db!.update(paymentModeTable, paymentMode.toJson(),
        where: 'id = ?', whereArgs: [paymentMode.id]);
  }

  Future<int> deletePaymentMode(int id) async {
    final db = await database;
    return await db!.delete(paymentModeTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteBaseOnPaymentMethodNamePaymentMode(
      String? paymentMethodName) async {
    final db = await database;
    return await db!.delete(paymentModeTable,
        where: 'paymentMethodName = ?', whereArgs: [paymentMethodName]);
  }

  // CRUD operations for Invoice

  Future<int> insertInvoice(Invoice invoice) async {
    final db = await database;
    return await db!.insert(invoicesTable, invoice.toJson());
  }

  Future<int> updateInvoice(Invoice invoice) async {
    final db = await database;
    return await db!.update(invoicesTable, invoice.toJson(),
        where: 'id = ?', whereArgs: [invoice.id]);
  }

  Future<List<Invoice>> getAllInvoices() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(invoicesTable);
    return List.generate(maps.length, (index) {
      return Invoice.fromJson(maps[index]);
    });
  }

  Future<Invoice?> getInvoiceById(int invoiceId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(
      invoicesTable,
      where: 'id = ?',
      whereArgs: [invoiceId],
    );

    if (maps.isNotEmpty) {
      return Invoice.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<int?> updateInvoicePaymentAmount(
      int invoiceId, double recordAmountPaid) async {
    final db = await database;

    return await db!.update(
      invoicesTable,
      {
        'recordAmountPaid': recordAmountPaid,
      },
      where: 'id = ?',
      whereArgs: [invoiceId],
    );
  }

  Future<int> deleteInvoice(int id) async {
    final db = await database;
    return await db!.delete(invoicesTable, where: 'id = ?', whereArgs: [id]);
  }

// -----
// Report CRUD operations
  Future<List<Map<String, dynamic>?>?> analyzeMenuItemOrderCounts() async {
    final db = await database;

    // Query to get the menu item names, variation names, and their respective counts
    final List<Map<String, dynamic>> results = await db!.rawQuery('''
    SELECT
      mi.id AS menuItemId,
      mi.name AS menuItemName,
      CASE
        WHEN oi.isMenuItem = 1 THEN mi.quantity
        ELSE miv.quantity
      END AS measureInfoQuantity,
      CASE
        WHEN oi.isMenuItem = 1 THEN mi.purchaseUnit
        ELSE miv.purchaseUnit
      END AS measureInfoPurchaseUnit,
      CASE
        WHEN oi.isMenuItem = 1 THEN NULL
        ELSE miv.id
      END AS menuItemVariationId,
      COUNT(oi.itemId) AS totalCount
      SUM(CASE WHEN oi.isMenuItem = 1 THEN mi.sellingPrice ELSE miv.sellingPrice END) AS totalSellingPrice
    FROM $orderItemsTable oi
    LEFT JOIN $menuItemsTable mi ON oi.menuItemId = mi.id AND oi.isMenuItem = 1
    LEFT JOIN $menuItemVariationsTable miv ON oi.selectedVariationId = miv.id AND oi.isMenuItem = 0
    LEFT JOIN $ordersTable o ON oi.orderId = o.id
    WHERE o.isCanceled = 0 AND o.isDeleted = 0 AND oi.status = 'Delivered'
    GROUP BY mi.id, mi.name, mi.quantity, mi.purchaseUnit, miv.quantity, miv.purchaseUnit, miv.id
  ''');

    return results.map((result) {
      final bool isMenuItem = result['menuItemVariationId'] == null;

      return {
        "MenuItemId": result['menuItemId'],
        "menuItemName": result['menuItemName'],
        "measureInfoQuantity": result['measureInfoQuantity'],
        "measureInfoPurchaseUnit": result['measureInfoPurchaseUnit'],
        "menuItemVariationId": result['menuItemVariationId'],
        "totalCount": result['totalCount'],
        "totalRevenue": result['totalSellingPrice'],
        "IsMenuItem": isMenuItem,
      };
    }).toList();
  }

// What is the total number of orders placed for the menu item list during that time period/frame?
// Query to get the menu item names and their respective counts within the date range
  Future<Map<String, int>?> analyzeMenuItemOrderCountsBaseOnDuration(
      DateTime startDate, DateTime endDate) async {
    final db = await database;

    // Query to get the menu item names and their respective counts within the date range
    final List<Map<String, dynamic>> results = await db!.rawQuery('''
    SELECT mi.name AS menuItemName, COUNT(oi.itemId) AS itemCount
    FROM $orderItemsTable oi
    INNER JOIN $menuItemsTable mi ON oi.itemId = mi.id
    WHERE oi.creationDate >= ? AND oi.creationDate <= ? AND $ordersTable.status = 'Completed'
    GROUP BY oi.itemId
  ''', [startDate.toIso8601String(), endDate.toIso8601String()]);

    final Map<String, int> itemCounts = {};

    for (final result in results) {
      final String menuItemName = result['menuItemName'];
      final int count = result['itemCount'];
      itemCounts[menuItemName] = count;
    }

    return itemCounts;
  }

// What is the total number of orders placed for a specific menu item during that time period/frame?
  Future<double?> analyzeMenuItemSalesForItem(
      {DateTime? startDate,
      DateTime? endDate,
      int? itemId,
      bool? isMenuItem}) async {
    final db = await database;

    // Query to get the count of sales (orders) for a specific menu item or its specific variations within the date range
    final List<Map<String, dynamic>> results = await db!.rawQuery('''
    SELECT COUNT(DISTINCT orderId) AS ordersCount
    FROM $orderItemsTable
    WHERE (itemId = ? OR selectedVariationId = ?) 
    AND isMenuItem = ?
    AND creationDate >= ? AND creationDate <= ? 
    AND $ordersTable.status = 'Completed'
  ''', [
      itemId,
      itemId,
      isMenuItem! ? 1 : 0,
      startDate!.toIso8601String(),
      endDate!.toIso8601String()
    ]);

    if (results.isNotEmpty) {
      return results.first['ordersCount'] as double;
    } else {
      return 0.0; // You can adjust the default value based on the desired type
    }
  }

  Future<dynamic> analyzeDailySalesForItem(
      {DateTime? date, int? itemId, bool? isMenuItem}) async {
    final startDate = DateTime(date!.year, date.month, date.day);
    final endDate = startDate.add(const Duration(days: 1));
    return await analyzeMenuItemSalesForItem(
        startDate: startDate,
        endDate: endDate,
        itemId: itemId,
        isMenuItem: isMenuItem);
  }

  Future<Map<DateTime, dynamic>?> analyzeWeeklySalesForItem(
      DateTime date, int itemId, bool isMenuItem) async {
    final startDate = date.subtract(Duration(days: date.weekday - 1));
    final endDate = startDate.add(const Duration(days: 7));
    final salesByDay = <DateTime, dynamic>{};
    for (var day = startDate;
        day.isBefore(endDate);
        day = day.add(const Duration(days: 1))) {
      final sales = await analyzeDailySalesForItem(
          date: day, itemId: itemId, isMenuItem: isMenuItem);
      if (sales != null) {
        salesByDay[day] = sales;
      }
    }
    return salesByDay;
  }

  Future<Map<DateTime, dynamic>?> analyzeMonthlySalesForItem(
      {DateTime? date, int? itemId, bool? isMenuItem}) async {
    final year = date?.year;
    final month = date?.month;
    final startDate = DateTime(year!, month!, 1);
    final endDate = DateTime(year, month + 1, 1);
    final salesByDay = <DateTime, dynamic>{};
    for (var day = startDate;
        day.isBefore(endDate);
        day = day.add(const Duration(days: 1))) {
      if (day.month == month) {
        final sales = await analyzeDailySalesForItem(
            date: day, itemId: itemId!, isMenuItem: isMenuItem!);
        if (sales != null) {
          salesByDay[day] = sales;
        }
      }
    }
    return salesByDay;
  }

// generate Sales Report base on Daily wise
  Future<List<DailySalesReportEntry>?> generateDailySalesReport(
      {DateTime? fromDate, DateTime? toDate}) async {
    final db = await database;

    // Query to get the total sales and cost for each day within the date range for completed orders
    final List<Map<String, dynamic>> results = await db!.rawQuery('''
    SELECT SUBSTR(o.creationDate, 1, 10) AS salesDay, 
           SUM(oi.sellingPrice * oi.quantity) AS dailyTotal,
           SUM(oi.costPrice * oi.quantity) AS dailyCost
    FROM $ordersTable o
    JOIN $orderItemsTable oi ON o.id = oi.orderId
    WHERE o.creationDate >= ? AND o.creationDate <= ? AND o.status = 'Completed'
    GROUP BY salesDay
  ''', [fromDate!.toIso8601String(), toDate!.toIso8601String()]);

    final List<DailySalesReportEntry> dailySalesReport = [];

    for (final result in results) {
      String? salesDay = result['salesDay'];
      double? dailyTotal = result['dailyTotal'];
      double? dailyCost = result['dailyCost'];

      double? dailyProfit = (dailyTotal ?? 0.0) - (dailyCost ?? 0.0);
      double? profitPercentage = (dailyCost != null && dailyCost != 0)
          ? (dailyProfit / dailyCost) * 100
          : null;

      dailySalesReport.add(DailySalesReportEntry(
        date: salesDay,
        dailyTotal: dailyTotal,
        dailyCost: dailyCost,
        dailyProfit: dailyProfit,
        profitPercentage: profitPercentage,
      ));
    }

    return dailySalesReport;
  }

// generate Sales Report base on Monthly wise
  Future<List<DailySalesReportEntry>?> generateMonthlySalesReport(
      {DateTime? fromDate, DateTime? toDate}) async {
    final db = await database;

    // Query to get the total sales and cost for each month within the date range for completed orders
    final List<Map<String, dynamic>> results = await db!.rawQuery('''
    SELECT SUBSTR(o.creationDate, 1, 7) AS salesMonth, 
           SUM(oi.sellingPrice * oi.quantity) AS monthlyTotal,
           SUM(oi.costPrice * oi.quantity) AS monthlyCost
    FROM $ordersTable o
    JOIN $orderItemsTable oi ON o.id = oi.orderId
    WHERE o.creationDate >= ? AND o.creationDate <= ? AND o.status = 'Completed'
    GROUP BY salesMonth
  ''', [fromDate!.toIso8601String(), toDate!.toIso8601String()]);

    final List<DailySalesReportEntry> monthlySalesReport = [];

    for (final result in results) {
      String? salesMonth = result['salesMonth'];
      double? monthlyTotal = result['monthlyTotal'];
      double? monthlyCost = result['monthlyCost'];

      double? monthlyProfit = (monthlyTotal ?? 0.0) - (monthlyCost ?? 0.0);
      double? profitPercentage = (monthlyCost != null && monthlyCost != 0)
          ? (monthlyProfit / monthlyCost) * 100
          : null;

      monthlySalesReport.add(DailySalesReportEntry(
        date: salesMonth,
        dailyTotal: monthlyTotal,
        dailyCost: monthlyCost,
        dailyProfit: monthlyProfit,
        profitPercentage: profitPercentage,
      ));
    }

    return monthlySalesReport;
  }

// Query to get the total quantity sold and total amount for a specific menu item for each day within the date range
  Future<List<MenuItemSalesReport>> generateDailySalesReportForMenuItem(
    int itemId,
    bool isMenuItem,
    DateTime fromDate,
    DateTime toDate,
  ) async {
    final db = await database;

    // Query to get the total quantity sold and total amount for a specific menu item or its variations for each day within the date range
    final List<Map<String, dynamic>> results = await db!.rawQuery('''
    SELECT SUBSTR(o.creationDate, 1, 10) AS salesDay, 
           SUM(oi.quantity) AS quantitySold, 
           SUM(oi.sellingPrice * oi.quantity) AS totalAmount,
           SUM(oi.costPrice * oi.quantity) AS totalCost
    FROM $ordersTable o
    JOIN $orderItemsTable oi ON o.id = oi.orderId
    WHERE (oi.itemId = ? OR oi.selectedVariationId = ?) 
      AND oi.isMenuItem = ?
      AND o.creationDate >= ? 
      AND o.creationDate <= ? 
      AND o.status = 'Completed'
    GROUP BY salesDay
  ''', [
      itemId,
      itemId,
      isMenuItem ? 1 : 0,
      fromDate.toIso8601String(),
      toDate.toIso8601String()
    ]);

    final List<MenuItemSalesReport> dailySalesReport = [];

    for (final result in results) {
      String? salesMonth = result['salesDay'];
      int? quantitySold = result['quantitySold'];
      double? totalAmount = result['totalAmount'];
      double? totalCost = result['totalCost'];

      double? totalProfit = (totalAmount ?? 0) - (totalCost ?? 0);
      double? profitPercentage;
      try {
        profitPercentage = (totalProfit / totalAmount!) * 100;
      } catch (e) {
        profitPercentage = null;
        Constants.debugLog(DatabaseHelper,
            "generateDailySalesReportForMenuItem:profitPercentage:error:$e");
      }

      dailySalesReport.add(MenuItemSalesReport(
        salesDay: salesMonth,
        quantitySold: double.tryParse("$quantitySold"),
        totalAmount: totalAmount,
        totalCost: totalCost,
        totalProfit: totalProfit,
        profitPercentage: profitPercentage,
      ));
    }

    return dailySalesReport;
  }

  Future<List<MenuItemSalesReport>> generateMonthlySalesReportForMenuItem({
    required int? itemId,
    required DateTime? fromDate,
    required DateTime? toDate,
    bool isMenuItem = true, // Default isMenuItem to true
  }) async {
    final db = await database;

    // Determine the appropriate table to join based on isMenuItem
    String joinTable = isMenuItem ? menuItemsTable : menuItemVariationsTable;

    // Query to get the total quantity sold, total amount, and total cost for a specific menu item for each month within the date range
    final List<Map<String, dynamic>> results = await db!.rawQuery('''
    SELECT
      SUBSTR(o.creationDate, 1, 7) AS salesMonth,
      SUM(oi.quantity) AS quantitySold,
      SUM(oi.sellingPrice * oi.quantity) AS totalAmount,
      SUM(oi.costPrice * oi.quantity) AS totalCost
    FROM
      $ordersTable o
    JOIN
      $orderItemsTable oi ON o.id = oi.orderId
    JOIN
      $joinTable mi ON oi.itemId = mi.id
    WHERE
      oi.itemId = ? AND o.creationDate >= ? AND o.creationDate <= ? AND o.status = 'Completed'
    GROUP BY
      salesMonth
  ''', [itemId, fromDate!.toIso8601String(), toDate!.toIso8601String()]);

    final List<MenuItemSalesReport> monthlySalesReport = [];

    for (final result in results) {
      String? salesMonth = result['salesMonth'];
      double? quantitySold = result['quantitySold'];
      double? totalAmount = result['totalAmount'];
      double? totalCost = result['totalCost'];
      double? totalProfit = (totalAmount ?? 0) - (totalCost ?? 0);
      double? profitPercentage;
      try {
        profitPercentage = (totalProfit / totalAmount!) * 100;
      } catch (e) {
        profitPercentage = null;
        Constants.debugLog(DatabaseHelper,
            "generateDailySalesReportForMenuItem:profitPercentage:error:$e");
      }

      monthlySalesReport.add(MenuItemSalesReport(
        salesDay: salesMonth,
        quantitySold: quantitySold,
        totalAmount: totalAmount,
        totalCost: totalCost,
        totalProfit: totalProfit,
        profitPercentage: profitPercentage,
      ));
    }

    return monthlySalesReport;
  }

  Future<List<MenuItemReview>> getReviewsForMenuItem(int itemId) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      'MenuItemReviews',
      where: 'itemId = ?',
      whereArgs: [itemId],
    );
    return List.generate(results.length, (index) {
      return MenuItemReview.fromJson(results[index]);
    });
  }

  Future<double> calculateAverageRatingForMenuItem(int itemId) async {
    final reviews = await getReviewsForMenuItem(itemId);
    if (reviews.isEmpty) {
      return 0.0; // No reviews yet.
    }
    final totalRating = reviews.fold(
        0, (sum, review) => sum + (review.rating == null ? 0 : review.rating!));
    return totalRating / reviews.length;
  }

  // Employee CRUD operations
  Future<List<Employee>> getEmployees() async {
    final db = await database;
    var res = await db!.query(
      '$employeesTable',
      where: 'isDeleted = ?',
      whereArgs: [0], // 0 for false
      orderBy: 'id DESC',
    );
    return res.isNotEmpty ? res.map((c) => Employee.fromMap(c)).toList() : [];
  }

  Future<int> addEmployee(Employee employee) async {
    final db = await database;
    return await db!.insert('$employeesTable', employee.toMap());
  }

  Future<int> updateEmployee(Employee employee) async {
    final db = await database;
    return await db!.update('$employeesTable', employee.toMap(),
        where: 'id = ?', whereArgs: [employee.id]);
  }

  Future<int> deleteEmployee(int id) async {
    final db = await database;
    return await db!.update(
      '$employeesTable',
      {
        'isDeleted': 1,
        'modificationDate':
            DateUtil.dateToString(DateTime.now(), DateUtil.DATE_FORMAT15)
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Attendance CRUD operations
  Future<List<Attendance>?> getAttendance() async {
    final db = await database;
    var res = await db!.query(
      '$attendanceTable',
      where: 'isDeleted = ?',
      whereArgs: [0], // 0 for false
      orderBy: 'id DESC',
    );
    return res.isNotEmpty ? res.map((c) => Attendance.fromMap(c)).toList() : [];
  }

  Future<int> addAttendance(Attendance attendance) async {
    final db = await database;
    return await db!.insert('$attendanceTable', attendance.toMap());
  }

  Future<int> updateAttendance(Attendance attendance) async {
    final db = await database;
    return await db!.update('$attendanceTable', attendance.toMap(),
        where: 'id = ?', whereArgs: [attendance.id]);
  }

  Future<int> deleteAttendance(int id) async {
    final db = await database;
    return await db!.update(
      '$attendanceTable',
      {
        'isDeleted': 1,
        'modificationDate':
            DateUtil.dateToString(DateTime.now(), DateUtil.DATE_FORMAT15)
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Leave CRUD operations
  Future<List<Leave>?> getLeaves() async {
    final db = await database;
    var res = await db!.query(
      '$leavesTable',
      where: 'isDeleted = ?',
      whereArgs: [0], // 0 for false
      orderBy: 'id DESC',
    );
    return res.isNotEmpty ? res.map((c) => Leave.fromMap(c)).toList() : [];
  }

  Future<int> addLeave(Leave leave) async {
    final db = await database;
    return await db!.insert('$leavesTable', leave.toMap());
  }

  Future<int> updateLeave(Leave leave) async {
    final db = await database;
    return await db!.update('$leavesTable', leave.toMap(),
        where: 'id = ?', whereArgs: [leave.id]);
  }

  Future<void> updateLeavesBatch(List<Leave> leaves) async {
    final db = await database;
    final batch = db!.batch();

    for (Leave leave in leaves) {
      batch.update(
        '$leavesTable',
        leave.toMap(),
        where: 'id = ?',
        whereArgs: [leave.id],
      );
    }

    await batch.commit(noResult: true);
  }

  Future<int> deleteLeave(int id) async {
    final db = await database;
    return await db!.update(
      '$leavesTable',
      {
        'isDeleted': 1,
        'modificationDate':
            DateUtil.dateToString(DateTime.now(), DateUtil.DATE_FORMAT15)
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CRUD for InventoryModel
  Future<int?> insertInventory(InventoryModel inventory) async {
    final db = await database;
    if (db == null) return null;
    return await db.transaction<int>((txn) async {
      return await txn.insert(inventoryTable, inventory.toJson());
    });
  }

  Future<int?> updateInventory(InventoryModel inventory) async {
    final db = await database;
    if (db == null) return null; // Handle null database scenario

    return await db.transaction<int>((txn) async {
      return await txn.update(
        inventoryTable,
        inventory.toJson(),
        where: 'id = ?',
        whereArgs: [inventory.id],
      );
    });
  }

  Future<int?> deleteInventory(int id) async {
    final db = await database;
    if (db == null) return null; // Handle null database scenario

    return await db.transaction<int>((txn) async {
      return await txn.delete(
        inventoryTable,
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }

  Future<List<InventoryModel>?> getAllEnableInventory() async {
    final db = await database;
    if (db == null) return null;
    var res = await db.query(
      '$inventoryTable',
      where: 'isEnabled = ?',
      whereArgs: [1], // 1 for enable
      orderBy: 'id DESC',
    );
    if (res == null || res.isEmpty) {
      return null;
    }

    return List.generate(res.length, (i) {
      return InventoryModel.fromJson(res[i]);
    });
  }

  Future<List<InventoryModel>?> getAllInventory() async {
    final db = await database;
    if (db == null) return null;

    final List<Map<String, dynamic>?>? maps = await db.query(inventoryTable);
    if (maps == null || maps.isEmpty) {
      return null;
    }

    return List.generate(maps.length, (i) {
      return InventoryModel.fromJson(maps[i]!);
    });
  }

// CRUD for PurchaseModel
  Future<int?> insertPurchase(PurchaseModel purchase) async {
    final db = await database;
    if (db == null) return null; // Handle null database scenario

    return await db.transaction<int>((txn) async {
      return await txn.insert(purchaseTable, purchase.toJson());
    });
  }

  Future<int?> updatePurchase(PurchaseModel purchase) async {
    final db = await database;
    if (db == null) return null; // Handle null database scenario

    return await db.transaction<int>((txn) async {
      return await txn.update(
        purchaseTable,
        purchase.toJson(),
        where: 'id = ?',
        whereArgs: [purchase.id],
      );
    });
  }

  Future<int?> deletePurchase(int id) async {
    final db = await database;
    if (db == null) return null; // Handle null database scenario

    return await db.transaction<int>((txn) async {
      return await txn.delete(
        purchaseTable,
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }

  Future<List<PurchaseModel>?> getAllPurchases() async {
    final db = await database;
    if (db == null) return null; // Handle null database scenario

    final List<Map<String, dynamic>>? maps = await db.query(purchaseTable);
    if (maps == null || maps.isEmpty) {
      return null;
    }

    return List.generate(maps.length, (i) {
      return PurchaseModel.fromJson(maps[i]);
    });
  }

// Get daily expenditure cost
  Future<double?> getDailyExpenditureCost(String currentDate) async {
    final db = await database;
    if (db == null) return 0.0; // Return 0.0 if database is null

    final List<Map<String, dynamic>?>? result = await db.query(
      purchaseTable,
      where: 'purchaseDateTime LIKE ?',
      whereArgs: ['$currentDate%'],
    );

    if (result == null || result.isEmpty) return 0.0;

    double? res = result.fold(
        0.0, (sum, item) => (sum ?? 0.0) + (item!['purchasePrice'] ?? 0.0));
    return res ?? 0.0;
  }

// Get monthly expenditure cost
  Future<double?> getMonthlyExpenditureCost(String month) async {
    final db = await database;
    if (db == null) return 0.0; // Return 0.0 if database is null

    final List<Map<String, dynamic>>? result = await db.query(
      purchaseTable,
      where: 'purchaseDateTime LIKE ?',
      whereArgs: ['$month%'],
    );

    if (result == null || result.isEmpty) return 0.0;

    double? res = result.fold(
      0.0,
      (sum, item) =>
          (sum ?? 0.0) +
          (item['purchasePrice'] ?? 0.0), // Handle null values in purchasePrice
    );

    return res ?? 0.0;
  }
}
