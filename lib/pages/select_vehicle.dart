import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sakayna/animation/animation.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SelectVehicle extends StatefulWidget {
  const SelectVehicle({Key? key}) : super(key: key);

  @override
  _SelectVehicleState createState() => _SelectVehicleState();
}

class _SelectVehicleState extends State<SelectVehicle> {
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
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Swipe to select vehicle"),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var statusBar = MediaQuery.of(context).viewPadding.top;
    var size = MediaQuery.of(context).size;
    var _current = 0;

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
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back,
                            color: Colors.amber.shade300,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Back",
                            style: TextStyle(
                              color: Colors.amber.shade300,
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: size.width * 0.8,
                    height: size.height - statusBar,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            initialPage: 0,
                            height: 271.0,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: false,
                            onScrolled: (index) {
                              _current = index!.toInt();
                              setState(() {});
                            },
                          ),
                          items: data.map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 100,
                                      backgroundImage: AssetImage(i['image']!),
                                    ),
                                    // Image.asset("assets/jeep.png"),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      i['vehicle']!,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 21,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }).toList(),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        SizedBox(height: 15),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.pushNamed(context, "/showData");
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
                              child: Text(
                                "SELECT",
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
