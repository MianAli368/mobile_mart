import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LocationView extends StatefulWidget {
  const LocationView({super.key});

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  // Getting Current Address Code

  // Declaring required Variables.
  double? lat;

  double? long;

  String address = "";

  // ValueNotifier<String> address = ValueNotifier<String>("");

  bool isAddressSelected = false;

  // Following function to grant access and determines current position of the user.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.

      // Commented this line because app was not asking for locatin permission.
      // infact was showing below error in the Console.
      // return Future.error('Location services are at disabled.');

    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    EasyLoading.show(status: "Getting Address");
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  // Add following function to get lat, long and current address of user
  getLatLong() {
    Future<Position> data = _determinePosition();
    data.then((value) {
      print("value $value");
      // setState(() {
      lat = value.latitude;
      long = value.longitude;
      // });

      getAddress(value.latitude, value.longitude);
      // locationMV.setLocation();
    }).catchError((error) {
      print("Error $error");
    });
  }

// Following function based on Geocoding Package. This function is used to convert lat and long into Address.
  getAddress(lat, long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    // setState(() {
    // address = placemarks[0].street! + " " + placemarks[0].country!;

    address = placemarks[1].street! +
        ", " +
        placemarks[1].locality! +
        ", " +
        placemarks[1].administrativeArea! +
        ", " +
        placemarks[1].country!;

    // });

    for (int i = 0; i < placemarks.length; i++) {
      print("INDEX $i ${placemarks[i]}");
    }

    EasyLoading.dismiss();

    print("Address : $address");

    // LoginClass loginClass = LoginClass();
    // loginClass.setStateAddress(address);

    setState(() {
      print("Set State");
      // _billStreetAddressTextController.text = LoginClass.address!;
      isAddressSelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      onWillPop: () async {
        // Route Navigation Code
        EasyLoading.dismiss();
        return true;
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Address : ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Text(
                      address,
                      style: const TextStyle(
                          overflow: TextOverflow.visible,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                  onPressed: () {
                    getLatLong();
                  },
                  child: const Text("Get Address"))
            ],
          ),
        ),
      ),
    ));
  }
}
