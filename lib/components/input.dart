import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:ihap/component/getInitialCountry.dart';

class PasswordField extends StatefulWidget {
  final controller;
  final validator;
  final hint;

  PasswordField({@required this.controller, @required this.validator, this.hint: 'Password'});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  var pwd = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: !pwd,
      controller: widget.controller,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.lock, color: Colors.black),
        suffixIcon: GestureDetector(
          child: Icon(pwd ? Icons.visibility_off : Icons.visibility, color: Colors.black),
          onTap: () {
            setState(() {
              pwd = !pwd;
            });
          },
        ),
        hintText: widget.hint,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 2.0),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2.0),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

Widget emailField({@required controller, @required validator, hint: ''}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    keyboardType: TextInputType.emailAddress,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      prefixIcon: Icon(
        Icons.email,
        color: Colors.black,
      ),
      hintText: hint == '' ? "Email" : hint,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 2.0),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 2.0),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}

Widget inputField(
    {@required controller,
    @required validator,
    @required icon,
    @required hint,
    type: TextInputType.text,
    onChange: "",
    inputFormatters: const <TextInputFormatter>[]}) {
  return TextFormField(
    inputFormatters: inputFormatters,
    onChanged: onChange == "" ? (text) {} : onChange,
    controller: controller,
    validator: validator,
    keyboardType: type,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      prefixIcon: icon,
      hintText: hint,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 2.0),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 2.0),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}

Widget inputFieldSingle({
  @required controller,
  @required validator,
  @required hint,
  type: TextInputType.text,
  onChange: "",
}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    keyboardType: type,
    onChanged: onChange == "" ? (val) {} : onChange,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hint,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 2.0),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 2.0),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}

Widget disabledField({@required controller, @required validator, @required icon, @required hint, type: TextInputType.text}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    keyboardType: type,
    enabled: false,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    decoration: InputDecoration(
      errorStyle: TextStyle(
        color: Colors.red,
      ),
      filled: true,
      fillColor: Colors.grey.shade200,
      prefixIcon: icon,
      hintStyle: TextStyle(color: Colors.grey),
      hintText: hint,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 2.0),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    //onTap: null,
  );
}

Widget textAreaField(
    {@required controller, @required hint, @required max, @required validator, onChange: "", inputFormatters: null, type: TextInputType.text}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    keyboardType: type,
    maxLines: max,
    onChanged: onChange != "" ? onChange : (val) {},
    inputFormatters: inputFormatters,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hint,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 2.0),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 2.0),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}

Widget inputFieldNoIcon({@required controller, @required validator, @required hint, type: TextInputType.text, onChange: ""}) {
  return TextFormField(
    onChanged: onChange == "" ? (text) {} : onChange,
    controller: controller,
    validator: validator,
    keyboardType: type,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hint,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 2.0),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 2.0),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
