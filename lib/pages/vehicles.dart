import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakayna/components/appbar.dart';
import 'package:sakayna/components/input.dart';
import 'package:sakayna/components/simpledialog.dart';
import 'package:sakayna/services/authentication.dart';
import 'package:sakayna/services/query.dart';

var hq = Hquery();

class Vehicles extends StatefulWidget {
  const Vehicles({Key? key}) : super(key: key);

  @override
  State<Vehicles> createState() => _VehiclesState();
}

class _VehiclesState extends State<Vehicles> {
  var vehicle = TextEditingController();
  var typeSelection = [
    "assets/jeep.png",
    "assets/tricycle.png",
    "assets/sikad.png",
    "assets/taxi.png",
    "assets/motor.png",
  ];
  var typeSelected = "assets/jeep.png";

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
      appBar: appbar(title: "Vehicles"),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
              stream: hq.getSnap("vehicles"),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  var snap = snapshot.data!.docs;
                  List<Widget> vehicleWidgets = [];

                  for (var item in snap) {
                    vehicleWidgets.add(
                      GestureDetector(
                        onTap: () {
                          showAlertDialog(context: context, title: Text("Select Action"), actions: [
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  hq.deleteByID("vehicles", item.id);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Vehicle Deleted")));
                                },
                                child: Text("Delete"),
                                style: ElevatedButton.styleFrom(primary: Colors.red),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  vehicle.text = item['vehicle'];
                                  typeSelected = item['image'];

                                  showAlertDialog(
                                      context: context,
                                      title: Text("Edit Category"),
                                      content: Wrap(
                                        runSpacing: 8,
                                        children: [
                                          textAreaField(controller: vehicle, hint: "Vehicle", max: 1, validator: null),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  // color: Colors,
                                                  width: 1,
                                                ),
                                                borderRadius: BorderRadius.all(Radius.circular(8))),
                                            child: DropdownButtonFormField(
                                              value: typeSelected,
                                              items: typeSelection.map((type) {
                                                return DropdownMenuItem(
                                                  value: type,
                                                  child: Image.asset(type),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  typeSelected = value.toString();
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                          child: Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            hq.update(
                                              "vehicles",
                                              item.id,
                                              {
                                                "vehicle": vehicle.text,
                                                "image": typeSelected,
                                              },
                                            );
                                            vehicle.text = "";
                                            typeSelected = typeSelection[0];
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Vehicle Updated")));
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
                                    Text("${item['vehicle']}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
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
                    children: vehicleWidgets,
                  );
                } else {
                  return Container();
                }
              })),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan[700],
        foregroundColor: Colors.amber.shade300,
        onPressed: () async {
          vehicle.text = "";
          typeSelected = typeSelection[0];
          await showAlertDialog(
              context: context,
              title: Text("New Vehicle"),
              content: Wrap(
                runSpacing: 8,
                children: [
                  textAreaField(controller: vehicle, hint: "Vehicle", max: 1, validator: null),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                          // color: Colors,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: DropdownButtonFormField(
                      value: typeSelected,
                      items: typeSelection.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Image.asset(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          typeSelected = value.toString();
                        });
                      },
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    hq.push("vehicles", {
                      "vehicle": vehicle.text,
                      "image": typeSelected,
                    });

                    vehicle.text = "";
                    typeSelected = typeSelection[0];
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("New vehicle succesfully created.")));
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
