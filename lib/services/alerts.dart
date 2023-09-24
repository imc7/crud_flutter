import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

late BuildContext dialogContext;

showLoadingAlert(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext localContext) {
        dialogContext = localContext;
        return AlertDialog(
          content: Container(
            width: 80,
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Container(
                    margin: EdgeInsets.only(
                      left: 0,
                      top: 20,
                      right: 0,
                      bottom: 0,
                    ),
                    child: Text("Loading...")),
              ],
            ),
          ),
        );
      });
}

hideLoadingAlert() {
  Navigator.pop(dialogContext);
}
