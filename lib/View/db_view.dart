import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mobile_mart/ModelView/db_mv.dart';

class DBScreen extends StatelessWidget {
  const DBScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var db = DBMV();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("DB Screen")),
        body: FutureBuilder(
            future: db.getData(),
            builder: ((context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const Text("Something went Wrong!");
              } else {
                // return const Text("Ali");

                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: ((context, index) {
                      var dbProd = snapshot.data![index];
                      return Card(
                        child: Column(
                          children: [
                            Text("${dbProd.title}"),
                            Text("${dbProd.images2}")
                          ],
                        ),
                      );
                    }));
              }
            })),
      ),
    );
  }
}
