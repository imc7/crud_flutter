import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

late BuildContext loadingContext;

// Confirm alert
Future<void> confirmAlert(
    BuildContext context, String message, VoidCallback continueCallBack) async {
  showDialog(
      context: context,
      builder: (localContext) {
        return AlertDialog(
          title: const Center(child: Text('Confirm')),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Text(message)],
          ),
          actions: [
            TextButton(
              child: Text("Yes"),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(localContext);
                continueCallBack();
              },
            ),
            TextButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.pop(localContext);
                }),
          ],
        );
      });
}

// Loading alert
showLoadingAlert(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext localContext) {
        loadingContext = localContext;
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
  Navigator.pop(loadingContext);
}
