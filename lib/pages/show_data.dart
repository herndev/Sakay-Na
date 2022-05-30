import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sakayna/animation/animation.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sakayna/services/query.dart';

var hq = Hquery();

class ShowData extends StatefulWidget {
  final origin;
  final destination;
  final vehicle;
  final route;
  const ShowData({this.route, this.vehicle, this.origin, this.destination, Key? key}) : super(key: key);

  @override
  _ShowDataState createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  var isLoading = false;
  var estimatedTime = "";
  var transportCost = "";

  @override
  void initState() {
    super.initState();
    getOutput();
  }

  @override
  Widget build(BuildContext context) {
    var statusBar = MediaQuery.of(context).viewPadding.top;
    var size = MediaQuery.of(context).size;

    return isLoading
        ? Container(
            child: Scaffold(
              backgroundColor: Colors.cyan.shade700,
              body: Center(
                child: SpinKitRing(
                  color: Colors.amber.shade300,
                  size: 50.0,
                ),
              ),
            ),
          )
        : Scaffold(
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
                              Card(
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "RESULTS",
                                        style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Colors.cyan.shade700),
                                      ),
                                      SizedBox(height: 15),
                                      Text(
                                        "Route: ",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 8),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0),
                                        child: Text(
                                          "Origin: ${widget.origin}",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0),
                                        child: Text(
                                          "Destination: ${widget.destination}",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      Text(
                                        "Vehicle: ${widget.vehicle}",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Estimated Arrival Time: $estimatedTime",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Transport Cost: $transportCost",
                                        style: TextStyle(fontWeight: FontWeight.bold),
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

  Future getOutput() async {
    setState(() => isLoading = true);
    var route = await hq.getDataByID("routes", widget.route);
    estimatedTime = route['estimated_time'];
    transportCost = route['transport_cost'];
    setState(() => isLoading = false);
  }
}
