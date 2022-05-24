import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sakayna/animation/animation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      goto();
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var size = MediaQuery.of(context).size;

    return Container(
      // decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/eihap_background.jpg"), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: FadeAnimation(
              1.8,
              Column(
                // crossAxisAlignment: WrapCrossAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitDualRing(color: Colors.cyan.shade700),
                  // SpinKitPouringHourglass(color: Colors.cyan.shade700),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Sakay Na",
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> goto() async {
    // Navigator.pop(context);
    Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
  }
}
