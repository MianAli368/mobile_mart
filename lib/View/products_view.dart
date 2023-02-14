import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_mart/DB/db_helper.dart';
import 'package:mobile_mart/ModelView/db_mv.dart';
import 'package:mobile_mart/ModelView/location_mv.dart';
import 'package:mobile_mart/Models/prod_model.dart';
import 'package:mobile_mart/Services/products_service.dart';
import 'package:mobile_mart/View/db_view.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mobile_mart/View/location_view.dart';
import 'package:provider/provider.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  var products = ProductsService();

  var locationMV = LocationMV();

  @override
  var dbProvider = DBProvider;
  DBMV dbmv = DBMV();
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Products"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LocationView()));
                },
                icon: const Icon(Icons.location_on))
          ],
        ),
        body: StreamBuilder(
          stream: Connectivity().onConnectivityChanged,
          builder: ((context, streamSnapshot) {
            if (streamSnapshot.data == ConnectivityResult.none ||
                streamSnapshot.data == null) {
              return FutureBuilder(
                  future: dbmv.getData(),
                  builder: ((context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.data!.isEmpty) {
                      return const Center(child: Text("No Internet"));
                    } else if (snapshot.hasError) {
                      return const Text("Something went Wrong!");
                    } else {
                      var prod = snapshot.data!;

                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: ((context, index) {
                                  var prod = snapshot.data![index];

                                  return Card(
                                    elevation: 15,
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Card(
                                              elevation: 15,
                                              child: Image(
                                                  width: 100,
                                                  height: 100,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return const Center(
                                                        child: SizedBox(
                                                            width: 100,
                                                            height: 100,
                                                            child: Icon(
                                                                Icons.error)));
                                                  },
                                                  fit: BoxFit.contain,
                                                  image: NetworkImage(
                                                      "${prod.images2}")),

                                              //     CachedNetworkImage(
                                              //   height: 100,
                                              //   width: 100,
                                              //   imageUrl: "${prod.images2}",
                                              //   placeholder: (context, url) =>
                                              //       const Center(
                                              //           child:
                                              //               CircularProgressIndicator()),
                                              //   errorWidget:
                                              //       (context, url, error) =>
                                              //           const Icon(Icons.error),
                                              // ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * 0.62,
                                            height: height * 0.160,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    "${prod.title}",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "${prod.description}",
                                                    style: const TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Rating: ",
                                                        style: TextStyle(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                      Text(
                                                        "${prod.rating}",
                                                        style: const TextStyle(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    "Rs ${prod.price}",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ]),
                                  );
                                })),
                          ),
                        ],
                      );
                    }
                  }));
            } else {
              return FutureBuilder(
                  future: products.getProducts(),
                  builder: ((context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return const Text("Something went Wrong!");
                    } else {
                      var prod = snapshot.data!;
                      for (int i = 0; i < snapshot.data!.length; i++) {
                        DBProvider.db.createProduct(ProductsModel(
                            id: prod[i].id,
                            title: prod[i].title,
                            description: prod[i].description,
                            price: prod[i].price,
                            discountPercentage: prod[i].discountPercentage,
                            rating: prod[i].rating,
                            stock: prod[i].stock,
                            brand: prod[i].brand,
                            category: prod[i].category,
                            thumbnail: prod[i].thumbnail,
                            // images: prod[i].images![0]
                            images2: prod[i].images![0]
                            // images2: "adf"
                            ));
                      }

                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: ((context, index) {
                                  var prod = snapshot.data![index];

                                  return Card(
                                    elevation: 15,
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Card(
                                              elevation: 15,
                                              child: Image(
                                                  width: 100,
                                                  height: 100,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return const Center(
                                                        child:
                                                            Icon(Icons.error));
                                                  },
                                                  fit: BoxFit.contain,
                                                  image: NetworkImage(
                                                      "${prod.images![0]}")),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * 0.62,
                                            height: height * 0.160,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    "${prod.title}",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "${prod.description}",
                                                    style: const TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Rating: ",
                                                        style: TextStyle(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                      Text(
                                                        "${prod.rating}",
                                                        style: const TextStyle(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    "Rs ${prod.price}",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ]),
                                  );
                                })),
                          ),
                        ],
                      );
                    }
                  }));
            } //else closing bracket
          }),
        ),
      ),
    );
  }
}
