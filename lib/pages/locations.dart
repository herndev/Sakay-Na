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
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            overflow: Overflow.visible,
            children: [
              Container(
                width: size.width * 0.9,
                height: size.height - statusBar - appbarheight,
                child: StreamBuilder<QuerySnapshot>(
                    stream: hq.getSnap("categories"),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        var snap = snapshot.data!.docs;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [],
                        );
                      } else {
                        return Container();
                      }
                    }),
              ),
            ],
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber.shade300,
        foregroundColor: Colors.cyan[700],
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
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("New location succesfuully created.")));
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
