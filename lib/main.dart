import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakayna/pages/admin.dart';
import 'package:sakayna/pages/auth/profile.dart';
import 'package:sakayna/pages/locations.dart';
import 'package:sakayna/pages/select_vehicle.dart';
import 'package:sakayna/pages/show_data.dart';
import 'package:sakayna/pages/splash.dart';
import 'package:sakayna/pages/vehicles.dart';

import 'model/user.dart';
import 'pages/home.dart';
import 'pages/auth/login.dart';
import 'pages/auth/register.dart';
import 'services/authentication.dart';

void main() async {
  // Add these 2 lines
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIOverlays([
  //   SystemUiOverlay.bottom, //This line is used for showing the bottom bar
  // ]);

  runApp(MultiProvider(
    providers: [
      Provider<AuthService>(
        create: (_) => AuthService(),
      ),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash', // splash
      routes: {
        "/": (_) => AuthWrapper(),
        "/splash": (_) => SplashScreen(),
        "/home": (_) => Home(),
        "/login": (_) => Login(),
        "/register": (_) => Register(),
        "/selectVehicle": (_) => SelectVehicle(),
        "/showData": (_) => ShowData(),
        "/locations": (_) => Locations(),
        "/vehicles": (_) => Vehicles(),
        "/profile": (_) => Profile(),
      },
      theme: ThemeData(
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          // Deprecated
          brightness: Brightness.dark,
          iconTheme: IconThemeData(color: Colors.amber.shade300), // 1
        ),
      ),
    ),
  ));
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<UserData?>(
      stream: authService.user,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          //final UserData? user = snapshot.data;
          final UserData user = snapshot.data ?? UserData("", null);
          // ignore: unnecessary_null_comparison
          return ((user == null) || (user != null && user.email == null))
              ? Login()
              : user.email == "admin@admin.com"
                  ? Admin()
                  : Home();
        } else {
          return Scaffold(
            body: Center(
              child: Text("Something went wrong"),
            ),
          );
        }
      },
    );
  }
}
