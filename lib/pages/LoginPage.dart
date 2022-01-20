import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:permission_handler/permission_handler.dart';

import 'contacts_page.dart';

class LoginPage extends StatefulWidget {
  static String id = "login_page";

  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String country;
  late String countryCode;
  bool isLoading = false;

  bool isGranted = true;

  Future<bool> getPermission() async {
    Map<Permission, PermissionStatus> statuses = {};
    var status = await Permission.locationWhenInUse.status;

    if (!status.isGranted && !status.isPermanentlyDenied) {
      statuses = await [
        Permission.locationWhenInUse,
        Permission.contacts,
        Permission.camera,
      ].request();
    }

    statuses.forEach((permission, permissionStatus) {
      if (!permissionStatus.isGranted) {
        isGranted = false;
      }
    });

    return isGranted;
  }

  Future<void> getCountryCodeName() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> address =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placeMark = address.first;
    setState(() {
      countryCode = placeMark.isoCountryCode!;
      country = placeMark.country!;
      isLoading = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getPermission().then((value) {
      if (value) {
        getCountryCodeName();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? Container(
                padding: const EdgeInsets.only(top: 15),
                width: double.infinity,
                alignment: Alignment.center,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.87,
                        child: Card(
                          child: TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                                hintText: country,
                                hintStyle: TextStyle(color: Colors.black),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide())),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: IntlPhoneField(
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                                labelText: "Phone Number",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide())),
                            initialCountryCode: countryCode,
                            onCountryChanged: (state) {
                              setState(() {
                                country = state.name;
                              });
                            },
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: MaterialButton(
                          color: Colors.blue,
                          onPressed: () {
                            Navigator.pushNamed(context, ContactsPage.id);
                          },
                          child: const Text(
                            "Submit",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ]),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
