import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakayna/components/appbar.dart';
import 'package:sakayna/pages/select_vehicle.dart';
import 'package:sakayna/services/authentication.dart';
import 'package:sakayna/services/query.dart';

var hq = Hquery();

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // var origins = ["cogon", "ustp"];
  // var origin = "cogon";
  // var destinations = ["cogon", "ustp"];
  // var destination = "ustp";
  var locations = [];
  var selectedLocation = "";
  var selectedLocation2 = "";

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: Text('Demo'),
    );
    double appbarheight = appBar.preferredSize.height;
    var statusBar = MediaQuery.of(context).viewPadding.top;
    var size = MediaQuery.of(context).size;
    final auth = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: homeAppbar(auth: auth, context: context),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            overflow: Overflow.visible,
            children: [
              Positioned(
                left: 50,
                bottom: -150,
                child: Image.asset(
                  "assets/blob-amber.png",
                ),
              ),
              Positioned(
                right: 50,
                top: -150,
                child: Image.asset(
                  "assets/blob-amber.png",
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: hq.getSnap("locations"),
                builder: (_, locationsSnap) {
                  if (locationsSnap.connectionState == ConnectionState.active) {
                    var locsnap = locationsSnap.data!.docs;

                    // List<Widget> locationWidgets = [];
                    locations = [];
                    for (var item in locsnap) {
                      locations.add(item['location']);
                    }

                    if (locations.length == 0) {
                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Create locations and vehicles first.")));
                      Navigator.pop(context);
                      return Container();
                    }

                    if (selectedLocation == "") {
                      selectedLocation = locations[0];
                    }
                    if (selectedLocation2 == "") {
                      selectedLocation2 = locations[1];
                    }

                    return Container(
                      width: size.width * 0.9,
                      height: size.height - statusBar - appbarheight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "ORIGIN",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.amber.shade300,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(8))),
                            child: DropdownButtonFormField(
                              decoration: InputDecoration.collapsed(hintText: ''),
                              value: selectedLocation,
                              items: locations.map((type) {
                                return DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedLocation = value.toString();
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "DESTINATION",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.amber.shade300,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(8))),
                            child: DropdownButtonFormField(
                              decoration: InputDecoration.collapsed(hintText: ''),
                              value: selectedLocation2,
                              items: locations.map((type) {
                                return DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedLocation2 = value.toString();
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                var route = MaterialPageRoute(
                                    builder: (_) => SelectVehicle(
                                          origin: selectedLocation,
                                          destination: selectedLocation2,
                                        ));
                                Navigator.push(context, route);
                                // Navigator.pushNamed(context, "/selectVehicle");
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
                                child: Text("SELECT VEHICLE"),
                              ),
                              style: ElevatedButton.styleFrom(primary: Colors.cyan.shade700),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ],
      )),
    );
  }
}
