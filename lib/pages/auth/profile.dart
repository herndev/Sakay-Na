import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sakayna/components/input.dart';
import 'package:sakayna/components/simpledialog.dart';
import 'package:sakayna/services/authentication.dart';
import 'package:sakayna/services/emailChecker.dart';
import 'package:sakayna/services/query.dart';

var hq = Hquery();

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var email = TextEditingController();
  var password = TextEditingController();
  var username = TextEditingController();
  var repassword = TextEditingController();
  var _form = GlobalKey<FormState>();
  var isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.dispose();
    password.dispose();
    repassword.dispose();
    username.dispose();
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
                                  "UPDATE PROFILE",
                                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                inputField(
                                    controller: username,
                                    validator: (e) {
                                      if (e == "") {
                                        return "Field can't be empty";
                                      } else {
                                        return null;
                                      }
                                    },
                                    icon: Icon(Icons.person, color: Colors.amber.shade300),
                                    hint: "Username"),
                                SizedBox(
                                  height: 15,
                                ),
                                emailField(
                                  controller: email,
                                  validator: (e) {
                                    if (!isEmail(e) || e == "") {
                                      return "Please provide valid email";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                PasswordField(
                                    controller: password,
                                    validator: (e) {
                                      if (e.length < 6) {
                                        return "Password must be at least 6 characters";
                                      } else {
                                        return null;
                                      }
                                    }),
                                SizedBox(
                                  height: 15,
                                ),
                                PasswordField(
                                  controller: repassword,
                                  validator: (e) {
                                    if (e != password.text) {
                                      return "Password didn't match";
                                    } else {
                                      return null;
                                    }
                                  },
                                  hint: "Retype-password",
                                ),
                                SizedBox(
                                  height: 8,
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

                                        var res = await auth.signUpWithEmailAndPassword(email: _email, password: password.text);
                                        var errorMessage = auth.errorMessage;

                                        if (res == null) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(errorMessage == "email-already-in-use"
                                                  ? "Email is already taken, try another email."
                                                  : "Something went wrong"),
                                            ),
                                          );
                                        } else {
                                          await hq.push("users", {
                                            "username": username.text,
                                            "email": _email,
                                            "uid": res.uid,
                                          });
                                          showAlertDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            title: Text("Sakay Na"),
                                            content: Text("You have successfully registered."),
                                            actions: [
                                              TextButton(
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Ok"),
                                              ),
                                            ],
                                          );
                                        }
                                      }
                                      setState(() {
                                        isLoading = false;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
                                      child: Text("UPDATE"),
                                    ),
                                    style: ElevatedButton.styleFrom(primary: Colors.cyan.shade700),
                                  ),
                                ),
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
}
