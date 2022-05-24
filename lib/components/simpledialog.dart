import 'package:flutter/material.dart';

showAlertDialog(
    {@required context,
    @required title,
    content: const SizedBox(),
    barrierDismissible: true,
    actions: ''}) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: title,
    content: content,
    actions: actions == ''
        ? [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Ok"))
          ]
        : actions,
  );
  // show the dialog
  showDialog(
    barrierDismissible: barrierDismissible,
    context: context,
    builder: (BuildContext context) {
      return new WillPopScope(
          onWillPop: () async => barrierDismissible, child: alert);
    },
  );
}

Future<bool> confirmationDialog(
    {required context,
    @required title,
    content: const SizedBox(),
    actions: ''}) async {
  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => new WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        title: title,
        content: content,
        actions: actions == ''
            ? [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text("Proceed"),
                ),
              ]
            : actions,
      ),
    ),
  );
}

showBackDialog({@required context, barrierDismissible: true, actions: ''}) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Go back"),
    content: Text("Progress will be discard."),
    actions: actions == ''
        ? [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text("Proceed"))
          ]
        : actions,
  );
  // show the dialog
  showDialog(
    barrierDismissible: barrierDismissible,
    context: context,
    builder: (BuildContext context) {
      return new WillPopScope(onWillPop: () async => false, child: alert);
    },
  );
}
