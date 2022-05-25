import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakayna/components/appbar.dart';
import 'package:sakayna/components/input.dart';
import 'package:sakayna/components/simpledialog.dart';
import 'package:sakayna/services/authentication.dart';
import 'package:sakayna/services/query.dart';

var hq = Hquery();

class Locations extends StatefulWidget {
  const Locations({Key? key}) : super(key: key);

  @override
  State<Locations> createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  var location = TextEditingController();

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
      appBar: appbar(title: "Locations"),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
              stream: hq.getSnap("locations"),
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
                                  hq.deleteByID("locations", item.id);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Location Deleted")));
                                },
                                child: Text("Delete"),
                                style: ElevatedButton.styleFrom(primary: Colors.red),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  location.text = item['location'];
                                  showAlertDialog(
                                      context: context,
                                      title: Text("Edit Category"),
                                      content: textAreaField(controller: location, hint: "Location", max: 1, validator: null),
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
                                              "locations",
                                              item.id,
                                              {
                                                "location": location.text,
                                              },
                                            );
                                            location.text = "";
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Location Updated")));
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
                                    Text("${item['location']}",
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
                    children: locationWidgets,
                  );
                } else {
                  return Container();
                }
              })),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan[700],
        foregroundColor: Colors.amber.shade300,
        onPressed: () async {
          location.text = "";
          await showAlertDialog(
              context: context,
              title: Text("New Location"),
              content: textAreaField(controller: location, hint: "Location", max: 1, validator: null),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    hq.push("locations", {
                      "location": location.text,
                    });
                    location.text = "";
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("New location succesfully created.")));
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
