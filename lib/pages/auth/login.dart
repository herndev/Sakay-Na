import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sakayna/components/input.dart';
import 'package:sakayna/services/authentication.dart';
import 'package:sakayna/services/emailChecker.dart';
import 'package:sakayna/services/query.dart';
import 'package:shared_preferences/shared_preferences.dart';

var hq = Hquery();

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var email = TextEditingController();
  var password = TextEditingController();
  var _form = GlobalKey<FormState>();
  var rememberme = false;
  var isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setPreviousCreds();
  }

  @override
  Widget build(BuildContext context) {
    var statusBar = MediaQuery.of(context).viewPadding.top;
    var size = MediaQuery.of(context).size;
    final auth = Provider.of<AuthService>(context);

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
            // appBar: AppBar(
            //   title: Text("Sakay Na"),
            // ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: size.width * 0.8,
                      height: size.height - statusBar,
                      child: Stack(
                        overflow: Overflow.visible,
                        children: [
                          Positioned(
                            right: 50,
                            top: -150,
                            child: Image.asset(
                              "assets/blob-cyan.png",
                            ),
                          ),
                          Positioned(
                            left: 50,
                            bottom: -150,
                            child: Image.asset(
                              "assets/blob-amber.png",
                            ),
                          ),
                          Form(
                            key: _form,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "LOGIN",
                                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                inputField(
                                    controller: email,
                                    validator: (e) {
                                      if (e == "") {
                                        return "Field can't be empty";
                                      } else {
                                        return null;
                                      }
                                    },
                                    icon: Icon(Icons.person, color: Colors.amber.shade300),
                                    hint: "Email / Username"),
                                SizedBox(
                                  height: 15,
                                ),
                                PasswordField(
                                    controller: password,
                                    validator: (e) {
                                      if (e == "") {
                                        return "Field can't be empty";
                                      } else {
                                        return null;
                                      }
                                    }),
                                SizedBox(
                                  height: 15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      rememberme = !rememberme;
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 24.0,
                                        width: 24.0,
                                        child: Checkbox(
                                            value: rememberme,
                                            onChanged: (e) {
                                              setState(() {
                                                rememberme = e!;
                                              });
                                            }),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text("Remember me")
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      if (_form.currentState!.validate()) {
                                        _form.currentState!.save();
                                        var _email = email.text;

                                        // Check if rememberme
                                        var pref = await SharedPreferences.getInstance();
                                        if (rememberme) {
                                          await pref.setString("email", _email);
                                          await pref.setString("password", password.text);
                                        } else {
                                          await pref.remove("email");
                                          await pref.remove("password");
                                        }

                                        // Check if use username or email
                                        if (!isEmail(email.text)) {
                                          // Sigin anonymously to get email by username
                                          // ignore: unused_local_variable
                                          var user = await auth.signInAnon();
                                          //user.delete();
                                          var result;
                                          try {
                                            var userdata = await hq.getDataByData(
                                              "users",
                                              "username",
                                              email.text.toLowerCase(),
                                            );
                                            result = userdata;
                                          } catch (e) {
                                            result = null;
                                          }

                                          if (result != null) {
                                            _email = result['email'];
                                            await auth.signOut();
                                          }
                                          //user.delete();
                                        }

                                        var res = await auth.signInWithEmailAndPassword(email: _email, password: password.text);

                                        var errorMessage = auth.errorMessage;
                                        var alert = "";

                                        if (res == null) {
                                          // if (errorMessage == "user-not-found") {
                                          alert = "Wrong Username or Password ";
                                          // } else {
                                          // alert = "Something went wrong";
                                          // }

                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(alert),
                                            ),
                                          );
                                        }
                                      }
                                      setState(() {
                                        isLoading = false;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
                                      child: Text("Sign-In"),
                                    ),
                                    style: ElevatedButton.styleFrom(primary: Colors.cyan.shade700),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Don't have an account?"),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context, "/register");
                                      },
                                      child: Text(
                                        "Create",
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.cyan.shade700),
                                      ),
                                    ),
                                  ],
                                )
                                // RichText(
                                //   text: TextSpan(
                                //     text: "Don't have an account? ",
                                //     children: [
                                //       TextSpan(text: "Register"),
                                //     ],
                                //     style: TextStyle(
                                //       color: Colors.black,
                                //     ),
                                //   ),
                                // ),
                              ],
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

  Future setPreviousCreds() async {
    var pref = await SharedPreferences.getInstance();
    email.text = pref.getString("email") ?? "";
    password.text = pref.getString("password") ?? "";
  }
}
