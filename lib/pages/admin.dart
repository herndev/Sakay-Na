import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakayna/components/appbar.dart';
import 'package:sakayna/services/authentication.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  var origins = ["cogon", "ustp"];
  var origin = "cogon";
  var destinations = ["cogon", "ustp"];
  var destination = "ustp";

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
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            overflow: Overflow.visible,
            children: [
              // Positioned(
              //   left: 50,
              //   bottom: -150,
              //   child: Image.asset(
              //     "assets/blob-amber.png",
              //   ),
              // ),
              // Positioned(
              //   right: 50,
              //   top: -150,
              //   child: Image.asset(
              //     "assets/blob-amber.png",
              //   ),
              // ),
              Container(
                width: size.width * 0.9,
                height: size.height - statusBar - appbarheight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(height: 15),
                    // Container(
                    //   width: double.infinity,
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       Navigator.pushNamed(context, "/selectVehicle");
                    //     },
                    //     child: Padding(
                    //       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
                    //       child: Text("SELECT VEHICLE"),
                    //     ),
                    //     style: ElevatedButton.styleFrom(primary: Colors.cyan.shade700),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
