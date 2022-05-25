import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sakayna/animation/animation.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ShowData extends StatefulWidget {
  const ShowData({Key? key}) : super(key: key);

  @override
  _ShowDataState createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  var data = [
    {
      "image": "assets/tricycle.png",
      "vehicle": "Tricycle",
    },
    {
      "image": "assets/jeep.png",
      "vehicle": "R1 Jeep",
    },
    {
      "image": "assets/sikad.png",
      "vehicle": "Padyak",
    },
  ];

  @override
  Widget build(BuildContext context) {
    var statusBar = MediaQuery.of(context).viewPadding.top;
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.cyan.shade700,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.amber.shade300,
                      ),
                    ),
                  ),
                  Container(
                    width: size.width * 0.8,
                    height: size.height - statusBar,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          child: Container(
                            padding: EdgeInsets.all(15),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "RESULTS",
                                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  "Route: ",
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Vehicle: ",
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Estimated arrival time: ",
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Cost: ",
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
                              child: Text(
                                "BACK TO HOME",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(primary: Colors.amber.shade300),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
