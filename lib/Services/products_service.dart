import 'dart:convert';

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:mobile_mart/DB/db_helper.dart';

// import 'package:mobile_mart/Models/DB/db_helper.dart';
import 'package:mobile_mart/Models/prod_model.dart';
import 'package:http/http.dart' as http;

class ProductsService {
  List<ProductsModel>? productList;

  Future<List<ProductsModel>?> getProducts() async {
    var response = await http
        .get(Uri.parse("https://dummyjson.com/products/category/smartphones"));

    var decode = jsonDecode(response.body);

    try {
      if (response.statusCode == 200) {
        final list = decode["products"] as List<dynamic>;

        APICacheDBModel cacheDBModel =
            APICacheDBModel(key: "Products", syncData: response.body);

        await APICacheManager().addCacheData(cacheDBModel);

        productList = list.map((e) => ProductsModel.fromJson(e)).toList();

        return productList;
      } else {
        throw Exception();
      }
    } catch (e) {
      print(e.toString());
      throw Exception();
    }
  }
}
