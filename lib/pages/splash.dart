import 'package:flutter/material.dart';
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
    Future.delayed(Duration(seconds: 3), () {
      goto();
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/eihap_background.jpg"), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: FadeAnimation(
              1.8,
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: Axis.vertical,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Literata',
                          fontSize: size.width * 0.2,
                        ),
                        children: [
                          TextSpan(text: "eih", style: TextStyle(color: hc.yellow, fontWeight: FontWeight.bold, letterSpacing: 2)),
                          TextSpan(text: "a", style: TextStyle(color: hc.brown, fontWeight: FontWeight.bold, letterSpacing: 2)),
                          TextSpan(text: "p", style: TextStyle(color: hc.yellow, fontWeight: FontWeight.bold, letterSpacing: 2)),
                        ]),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(style: TextStyle(fontFamily: 'Literata'), children: [
                      TextSpan(text: "Powered By", style: TextStyle(color: hc.brown, fontSize: 10, letterSpacing: 2)),
                      TextSpan(text: "\nSAKANAKIN", style: TextStyle(color: hc.brown, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 2)),
                    ]),
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
    Navigator.pop(context);
    // Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
  }
}
