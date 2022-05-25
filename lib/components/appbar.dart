import 'package:flutter/material.dart';
import 'package:sakayna/services/authentication.dart';

import 'simpledialog.dart';

AppBar homeAppbar({required AuthService auth, required context, title: ""}) {
  return AppBar(
    // shadowColor: Colors.transparent,
    // elevation: 0,
    backgroundColor: Colors.cyan.shade700,
    title: title == ""
        ? Text(
            "Sakay Na",
            style: TextStyle(color: Colors.amber.shade300),
          )
        : title,
    actions: <Widget>[
      PopupMenuButton<String>(
        onSelected: (val) {
          switch (val) {
            case 'Logout':
              showAlertDialog(
                  context: context,
                  title: Text(
                    "Log out",
                    style: TextStyle(color: Colors.black),
                  ),
                  content: Wrap(
                    direction: Axis.vertical,
                    children: [
                      Divider(
                        height: 2,
                      ),
                      Text("Do you wish to proceed?"),
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          auth.setUserID(null);
                          Navigator.pop(context);
                          await auth.signOut();
                        },
                        child: Text("Yes")),
                    TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: Text("No")),
                  ]);
              break;
            case 'Profile':
              Navigator.pushNamed(context, "/profile");
              break;
          }
        },
        itemBuilder: (BuildContext context) {
          return {'Profile', 'Logout'}.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Row(
                children: [
                  Icon(
                    (choice == "Logout")
                        ? Icons.logout
                        : (choice == "Profile")
                            ? Icons.person
                            : Icons.description_outlined,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(choice),
                ],
              ),
            );
          }).toList();
        },
      ),
    ],
  );
}

AppBar adminAppbar({required AuthService auth, required context, title: ""}) {
  return AppBar(
    // shadowColor: Colors.transparent,
    // elevation: 0,
    backgroundColor: Colors.cyan.shade700,
    title: title == ""
        ? Text(
            "Admin Panel",
            style: TextStyle(color: Colors.amber.shade300),
          )
        : title,
    actions: <Widget>[
      PopupMenuButton<String>(
        onSelected: (val) {
          switch (val) {
            case 'Logout':
              showAlertDialog(
                  context: context,
                  title: Text(
                    "Log out",
                    style: TextStyle(color: Colors.black),
                  ),
                  content: Wrap(
                    direction: Axis.vertical,
                    children: [
                      Divider(
                        height: 2,
                      ),
                      Text("Do you wish to proceed?"),
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          auth.setUserID(null);
                          Navigator.pop(context);
                          await auth.signOut();
                        },
                        child: Text("Yes")),
                    TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: Text("No")),
                  ]);
              break;
            case 'Profile':
              Navigator.pushNamed(context, "/profile");
              break;
            case 'Locations':
              Navigator.pushNamed(context, "/locations");
              break;
            case 'Vehicles':
              Navigator.pushNamed(context, "/vehicles");
              break;
          }
        },
        itemBuilder: (BuildContext context) {
          return {'Profile', 'Locations', 'Vehicles', 'Logout'}.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Row(
                children: [
                  Icon(
                    (choice == "Logout")
                        ? Icons.logout
                        : (choice == "Profile")
                            ? Icons.person
                            : (choice == "Locations")
                                ? Icons.location_city
                                : Icons.pedal_bike,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(choice),
                ],
              ),
            );
          }).toList();
        },
      ),
    ],
  );
}

AppBar appbar({title: ""}) {
  return AppBar(
    backgroundColor: Colors.cyan.shade700,
    title: Text(
      title == "" ? "Sakay Na" : title,
      style: TextStyle(color: Colors.amber.shade300),
    ),
  );
}
