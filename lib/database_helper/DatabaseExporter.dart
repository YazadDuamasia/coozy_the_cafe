import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class DatabaseExporter {
  static Future<void> exportToExcel() async {
    // Step 1: Retrieve table names from SQLite database
    List<String> tableNames = await getTableNamesFromDatabase();

    // Step 2: Create Excel workbook
    Workbook workbook = Workbook();

    // Step 3: Export each table to a separate sheet
    for (String tableName in tableNames) {
      List<Map<String, dynamic>> data = await fetchDataFromTable(tableName);
      exportTableToSheet(workbook, tableName, data);
    }

    // Step 4: Save Excel file
    await saveExcelFile(workbook);
  }

  static Future<List<String>> getTableNamesFromDatabase() async {
    final Database database = await openDatabase('path_to_your_database.db');
    List<Map<String, dynamic>> result = await database.rawQuery('SELECT name FROM sqlite_master WHERE type="table"');
    await database.close();
    return result.map((map) => map['name'].toString()).toList();
  }

  static Future<List<Map<String, dynamic>>> fetchDataFromTable(String tableName) async {
    final Database database = await openDatabase('path_to_your_database.db');
    List<Map<String, dynamic>> result = await database.rawQuery('SELECT * FROM $tableName');
    await database.close();
    return result;
  }

  static void exportTableToSheet(Workbook workbook, String sheetName, List<Map<String, dynamic>> data) {
    Worksheet sheet = workbook.worksheets.addWithName(sheetName);

    // Add headers
    for (int col = 0; col < data.first.keys.length; col++) {
      sheet.getRangeByIndex(1, col + 1).setText(data.first.keys.elementAt(col));
    }

    // Add data rows
    for (int row = 0; row < data.length; row++) {
      for (int col = 0; col < data[row].keys.length; col++) {
        sheet.getRangeByIndex(row + 2, col + 1).setText(data[row].values.elementAt(col).toString());
      }
    }
  }

  static Future<void> saveExcelFile(Workbook workbook) async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String filePath = '${appDocumentsDirectory.path}/exported_data.xlsx';

    final File file = File(filePath);
    file.writeAsBytesSync(workbook.saveAsStream());
    workbook.dispose(); // Don't forget to dispose of the engine to free resources.
  }
}