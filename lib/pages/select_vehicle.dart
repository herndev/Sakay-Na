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
              Container(
                width: size.width * 0.8,
                height: size.height - statusBar,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CarouselSlider(
  options: CarouselOptions(height: 400.0),
  items: [1,2,3,4,5].map((i) {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            color: Colors.amber
          ),
          child: Text('text $i', style: TextStyle(fontSize: 16.0),)
        );
      },
    );
  }).toList(),
)
                    CircleAvatar(
                      radius: 100,
                      backgroundImage: AssetImage("assets/tricycle.png"),
                    ),
                    // Image.asset("assets/jeep.png"),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Origin",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {},
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
        ),
      ),
    );
  }
}
