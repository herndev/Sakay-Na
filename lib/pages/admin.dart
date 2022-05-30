import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakayna/components/appbar.dart';
import 'package:sakayna/components/input.dart';
import 'package:sakayna/components/simpledialog.dart';
import 'package:sakayna/services/authentication.dart';
import 'package:sakayna/services/query.dart';

var hq = Hquery();

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  // var origins = ["cogon", "ustp"];
  // var origin = "cogon";
  // var destinations = ["cogon", "ustp"];
  // var destination = "ustp";
  var locations = [];
  var selectedLocation = "";
  var selectedLocation2 = "";
  var vehicles = [];
  var selectedVehicle = "";
  var estimatedTime = TextEditingController();
  var transportCost = TextEditingController();

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
      appBar: adminAppbar(
        auth: auth,
        context: context,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: hq.getSnap("routes"),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              var snap = snapshot.data!.docs;
              List<Widget> locationWidgets = [];

              for (var item in snap) {
                locationWidgets.add(
                  GestureDetector(
                    onTap: () {
                      showAlertDialog(context: context, title: Text("Select Action"), actions: [
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              hq.deleteByID("routes", item.id);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Route Deleted")));
                            },
                            child: Text("Delete"),
                            style: ElevatedButton.styleFrom(primary: Colors.red),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              estimatedTime.text = "";
                              transportCost.text = "";

                              await showAlertDialog(
                                  context: context,
                                  title: Text("New Route"),
                                  content: StreamBuilder<QuerySnapshot>(
                                    stream: hq.getSnap("locations"),
                                    builder: (_, locationsSnap) {
                                      if (locationsSnap.connectionState == ConnectionState.active) {
                                        return StreamBuilder<QuerySnapshot>(
                                          stream: hq.getSnap("vehicles"),
                                          builder: (_, vehiclesSnap) {
                                            if (vehiclesSnap.connectionState == ConnectionState.active) {
                                              var locsnap = locationsSnap.data!.docs;
                                              var vehsnap = vehiclesSnap.data!.docs;
                                              var vehicleData = {};

                                              // List<Widget> locationWidgets = [];
                                              locations = [];
                                              vehicles = [];
                                              for (var loc in locsnap) {
                                                locations.add(loc['location']);
                                              }
                                              for (var veh in vehsnap) {
                                                vehicles.add(veh['vehicle']);
                                                vehicleData[veh['vehicle']] = veh['image'];
                                              }

                                              if (locations.length == 0 || vehicles.length == 0) {
                                                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Create locations and vehicles first.")));
                                                Navigator.pop(context);
                                                return Wrap(
                                                  runSpacing: 8,
                                                  children: [],
                                                );
                                              }

                                              selectedLocation = item['origin'];
                                              selectedLocation2 = item['destination'];
                                              selectedVehicle = item['vehicle'];
                                              estimatedTime.text = item['estimated_time'];
                                              transportCost.text = item['transport_cost'];

                                              return Wrap(
                                                runSpacing: 8,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                          // color: Colors,
                                                          width: 1,
                                                        ),
                                                        borderRadius: BorderRadius.all(Radius.circular(8))),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          height: 8,
                                                        ),
                                                        Text(
                                                          "Origin",
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        DropdownButtonFormField(
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
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                          // color: Colors,
                                                          width: 1,
                                                        ),
                                                        borderRadius: BorderRadius.all(Radius.circular(8))),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          height: 8,
                                                        ),
                                                        Text(
                                                          "Destination",
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        DropdownButtonFormField(
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
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                          // color: Colors,
                                                          width: 1,
                                                        ),
                                                        borderRadius: BorderRadius.all(Radius.circular(8))),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          height: 8,
                                                        ),
                                                        Text(
                                                          "Vehicle",
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        DropdownButtonFormField(
                                                          value: selectedVehicle,
                                                          items: vehicles.map((type) {
                                                            return DropdownMenuItem(
                                                              value: type,
                                                              child: Text(type),
                                                            );
                                                          }).toList(),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              selectedVehicle = value.toString();
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  inputFieldNoIcon(controller: estimatedTime, validator: null, hint: "Estimated Arrival Time"),
                                                  inputFieldNoIcon(controller: transportCost, validator: null, hint: "Transport Cost "),
                                                  // Image.asset(vehicleData[selectedVehicle]),
                                                ],
                                              );
                                            } else {
                                              return Wrap();
                                            }
                                          },
                                        );
                                      } else {
                                        return Wrap();
                                      }
                                    },
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await hq.update("routes", item.id, {
                                          "origin": selectedLocation,
                                          "destination": selectedLocation2,
                                          "vehicle": selectedVehicle,
                                          "estimated_time": estimatedTime.text,
                                          "transport_cost": transportCost.text,
                                        });
                                        // location.text = "";
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Route succesfully updated.")));
                                      },
                                      child: Text("Update"),
                                    ),
                                  ]);
                            },
                            child: Text("Edit"),
                          ),
                        )
                      ]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                      child: Container(
                        width: size.width,
                        child: Card(
                          color: Colors.amber.shade100,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${item['origin']} => ${item['destination']}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    )),
                                SizedBox(
                                  height: 8,
                                ),
                                Text("Vehicle: ${item['vehicle']}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      // fontWeight: FontWeight.bold,
                                    )),
                                Text("Estimatetd Time: ${item['estimated_time']}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      // fontWeight: FontWeight.bold,
                                    )),
                                Text("Transport Cost: ${item['transport_cost']}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      // fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }

              return Column(
                children: locationWidgets,
              );
            } else {
              return Container();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan[700],
        foregroundColor: Colors.amber.shade300,
        onPressed: () async {
          estimatedTime.text = "";
          transportCost.text = "";

          await showAlertDialog(
              context: context,
              title: Text("New Route"),
              content: StreamBuilder<QuerySnapshot>(
                stream: hq.getSnap("locations"),
                builder: (_, locationsSnap) {
                  if (locationsSnap.connectionState == ConnectionState.active) {
                    return StreamBuilder<QuerySnapshot>(
                      stream: hq.getSnap("vehicles"),
                      builder: (_, vehiclesSnap) {
                        if (vehiclesSnap.connectionState == ConnectionState.active) {
                          var locsnap = locationsSnap.data!.docs;
                          var vehsnap = vehiclesSnap.data!.docs;
                          var vehicleData = {};

                          // List<Widget> locationWidgets = [];
                          locations = [];
                          vehicles = [];
                          for (var item in locsnap) {
                            locations.add(item['location']);
                          }
                          for (var item in vehsnap) {
                            vehicles.add(item['vehicle']);
                            vehicleData[item['vehicle']] = item['image'];
                          }

                          if (locations.length == 0 || vehicles.length == 0) {
                            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Create locations and vehicles first.")));
                            Navigator.pop(context);
                            return Wrap(
                              runSpacing: 8,
                              children: [],
                            );
                          }

                          selectedLocation = locations[0];
                          selectedLocation2 = locations[0];
                          selectedVehicle = vehicles[0];

                          return Wrap(
                            runSpacing: 8,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      // color: Colors,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(8))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "Origin",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    DropdownButtonFormField(
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
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      // color: Colors,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(8))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "Destination",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    DropdownButtonFormField(
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
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      // color: Colors,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(8))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "Vehicle",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    DropdownButtonFormField(
                                      value: selectedVehicle,
                                      items: vehicles.map((type) {
                                        return DropdownMenuItem(
                                          value: type,
                                          child: Text(type),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedVehicle = value.toString();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              inputFieldNoIcon(controller: estimatedTime, validator: null, hint: "Estimated Arrival Time"),
                              inputFieldNoIcon(controller: transportCost, validator: null, hint: "Transport Cost "),
                              // Image.asset(vehicleData[selectedVehicle]),
                            ],
                          );
                        } else {
                          return Wrap();
                        }
                      },
                    );
                  } else {
                    return Wrap();
                  }
                },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    await hq.push("routes", {
                      "origin": selectedLocation,
                      "destination": selectedLocation2,
                      "vehicle": selectedVehicle,
                      "estimated_time": estimatedTime.text,
                      "transport_cost": transportCost.text,
                    });
                    // location.text = "";
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("New route succesfully created.")));
                  },
                  child: Text("Create"),
                ),
              ]);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
