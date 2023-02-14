import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:mobile_mart/Models/prod_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database?> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await initDB();

    return _database;
  }

  // Create the database and the Products table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // String path = Join(documentsDirectory.path, 'employee_manager.db');

    String path = join(documentsDirectory.path, 'Products.db');

    // String path = StrokeJoin()

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Products('
          // 'id INTEGER PRIMARY KEY,'
          'id INTEGER,'
          'images TEXT,'
          'title TEXT,'
          'description TEXT,'
          'price INTEGER, '
          'discountPercentage FLOAT, '
          'rating FLOAT, '
          'stock INTEGER, '
          'brand TEXT, '
          'category TEXT, '
          'thumbnail TEXT, '
          'images_2 TEXT '
          // 'images TEXT'
          ')');
    });
  }

  // Insert employee on database
  createProduct(ProductsModel product) async {
    await deleteAllEmployees();
    final db = await database;
    final res = await db!.insert('Products', product.toJson());

    return res;
  }

  // Delete all employees
  Future<int> deleteAllEmployees() async {
    final db = await database;
    final res = await db!.rawDelete('DELETE FROM Products');

    return res;
  }

  Future<List<ProductsModel>> getProductList() async {
    var databaseClient = await database;
    final List<Map<String, Object?>> queryResult =
        await databaseClient!.query('Products');
    return queryResult.map((e) => ProductsModel.fromJson(e)).toList();
  }

  //   Future<List<ProductsModel>> getAllEmployees() async {
  //   final db = await database;
  //   final res = await db.rawQuery("SELECT * FROM EMPLOYEE");

  //   List<ProductsModel> list =
  //       res.isNotEmpty ? res.map((c) => Employee.fromJson(c)).toList() : [];

  //   return list;
  // }
}




// class DBHelper{

//     static Database? _database;

//   Future<Database?> get database async {
//     if (_database != null) {
//       return _database!;
//     }

//     // This return is written by Me. Sir didn't written it.
//     return _database = await initDatabase();
//   }


//   initDatabase() async {
//     io.Directory documentDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentDirectory.path, 'cart.db');
//     var database = await openDatabase(
//       path,
//       version: 35,
//       onCreate: _onCreate,
//     );
//     return database;
//   }


//     _onCreate(Database database, int version) async {
//     await database.execute("CREATE TABLE cart ("
//         // "id INTEGER PRIMARY KEY, "
//         "id INTEGER, "
//         "customer_id INTEGER, "
//         "model_no VARCHAR , "
//         "name VARCHAR, "
//         "new_price VARCHAR, "
//         "new_sale_price VARCHAR, "
//         "updated_new_sale_price VARCHAR, "
//         "order_quantity INTEGER, "
//         "description VARCHAR, "
//         "slug VARCHAR, "
//         "brand VARCHAR, "
//         "product_image VARCHAR, "
//         "details VARCHAR, "
//         "subcategory_id INTEGER, "
//         "make VARCHAR, "
//         "condition_type VARCHAR, "
//         "shipping_charges VARCHAR, "
//         "import_charges VARCHAR, "
//         "tax_charges VARCHAR, "
//         "other_charges VARCHAR, "
//         "shipping_days INTEGER, "
//         "located_in VARCHAR, "
//         "brand_id INTEGER, "
//         "brand_logo VARCHAR, "
//         "vendor_id INTEGER )");
//   }


//     Future<ProductsModel> insert(ProductsModel products) async {
//     var databaseClient = await database;
//     await databaseClient!.insert('cart', products.toJson());
//     return products;
//   }
// }
