import 'package:crud_flutter/tools/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

late BuildContext loadingContext;

// Successfully alert
Future<void> successOrWarningOrErrorAlert(BuildContext context, int code,
    String message, VoidCallback? continueCallBack) async {
  String title = 'Alert';
  Color titleColor = Colors.black;
  Color controlButtonColor = Colors.black;
  IconData icon = Icons.lock;
  Color iconColor = Colors.black;

  if (code == Constants.code_success) {
    title = 'Success';
    titleColor = Colors.green.shade700;
    controlButtonColor = Colors.blue;
    icon = Icons.check;
    iconColor = Colors.green.shade600;
  } else if (code == Constants.code_warning) {
    title = 'Warning';
    titleColor = Color(0xFFB69B10);
    controlButtonColor = Colors.black38;
    icon = Icons.warning;
    iconColor = Color(0xFFB69B10);
  } else if (code == Constants.code_error) {
    title = 'Error';
    titleColor = Colors.red.shade700;
    controlButtonColor = Colors.black38;
    icon = Icons.error;
    iconColor = Colors.red;
  }

  showDialog(
      context: context,
      builder: (localContext) {
        return AlertDialog(
            title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(icon, color: iconColor),
                  Text(title, style: TextStyle(color: titleColor)),
                ]),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Text(message)],
            ),
            actions: [
              TextButton(
                child: Text("Accept"),
                style: TextButton.styleFrom(
                  foregroundColor: controlButtonColor,
                ),
                onPressed: () {
                  Navigator.pop(localContext);
                  if (continueCallBack != null) continueCallBack();
                },
              ),
            ],
            actionsAlignment: MainAxisAlignment.center);
      });
}

// Confirm alert
Future<bool> confirmAlert(BuildContext context, String message) async {
  bool answer = await showDialog(
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
                Navigator.pop(localContext, true);
              },
            ),
            TextButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.pop(localContext, false);
                }),
          ],
        );
      });
  return answer;
}

// Loading alert
showLoadingAlert(BuildContext context, String? message) {
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
                    child: Text(message != null && message.isNotEmpty
                        ? message
                        : "Loading...")),
              ],
            ),
          ),
        );
      });
}

hideLoadingAlert() {
  Navigator.pop(loadingContext);
}

// Selecta an image
Future<ImageSource?> pickImageAlert(BuildContext context) async {
  ImageSource? answer = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Center(child: Text('Select an option')),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    iconSize: 36.0,
                    onPressed: () {
                      Navigator.pop(context, ImageSource.camera);
                    },
                    icon: Icon(Icons.add_a_photo)),
                IconButton(
                    iconSize: 36.0,
                    onPressed: () {
                      Navigator.pop(context, ImageSource.gallery);
                    },
                    icon: Icon(Icons.folder))
              ],
            ),
            actions: [
              TextButton(
                  child: Text("Cancel"),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.pop(context, null);
                  }),
            ],
          ));
  return answer;
}
