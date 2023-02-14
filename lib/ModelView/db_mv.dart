import 'package:flutter/cupertino.dart';
import 'package:mobile_mart/DB/db_helper.dart';
import 'package:mobile_mart/Models/prod_model.dart';

class DBMV {
  // DBProvider dbProvider = DBProvider();
  late Future<List<ProductsModel>> _products;
  Future<List<ProductsModel>> get products => _products;

  Future<List<ProductsModel>> getData() async {
    _products = DBProvider.db.getProductList();
    return _products;
  }
}
