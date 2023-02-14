import 'dart:convert';

ProductsModelClass productsModelClassFromJson(String str) =>
    ProductsModelClass.fromJson(json.decode(str));

String productsModelClassToJson(ProductsModelClass data) =>
    json.encode(data.toJson());

class ProductsModelClass {
  ProductsModelClass({
    this.productsModel,
    this.total,
    this.skip,
    this.limit,
  });

  List<ProductsModel>? productsModel;
  int? total;
  int? skip;
  int? limit;

  factory ProductsModelClass.fromJson(Map<String, dynamic> json) =>
      ProductsModelClass(
        productsModel: json["ProductsModel"] == null
            ? []
            : List<ProductsModel>.from(
                json["ProductsModel"]!.map((x) => ProductsModel.fromJson(x))),
        total: json["total"],
        skip: json["skip"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
        "ProductsModel": productsModel == null
            ? []
            : List<dynamic>.from(productsModel!.map((x) => x.toJson())),
        "total": total,
        "skip": skip,
        "limit": limit,
      };
}

class ProductsModel {
  ProductsModel(
      {this.id,
      this.title,
      this.description,
      this.price,
      this.discountPercentage,
      this.rating,
      this.stock,
      this.brand,
      this.category,
      this.thumbnail,
      this.images,
      this.images2});

  int? id;
  String? title;
  String? description;
  int? price;
  double? discountPercentage;
  double? rating;
  int? stock;
  String? brand;
  String? category;
  String? thumbnail;
  String? images2;
  List<String>? images;

  factory ProductsModel.fromJson(Map<String, dynamic> json) => ProductsModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        price: json["price"],
        discountPercentage: json["discountPercentage"]?.toDouble(),
        rating: json["rating"]?.toDouble(),
        stock: json["stock"],
        brand: json["brand"],
        category: json["category"],
        thumbnail: json["thumbnail"],
        images2: json["images_2"],
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "price": price,
        "discountPercentage": discountPercentage,
        "rating": rating,
        "stock": stock,
        "brand": brand,
        "category": category,
        "thumbnail": thumbnail,
        "images_2": images2,
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
      };
}
