import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakayna/components/appbar.dart';
import 'package:sakayna/services/authentication.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final auth = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: appbar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: size.width * 0.9,
            child: Column(
              children: [
                Text(
                  "Home",
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await auth.signOut();
                    },
                    child: Text("Logout"),
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
    ;
  }
}
