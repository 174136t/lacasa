import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppRoutes {
  static void push(BuildContext context, Widget page) {
    Navigator.of(context).push(
      new MaterialPageRoute(builder: (context) => page),
    );
  }

  static void pushEaseOutSine(BuildContext context, Widget page) {
    Navigator.of(context).push(PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 700),
        transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secanimation, Widget child) {
          animation =
              CurvedAnimation(parent: animation, curve: Curves.easeOutSine);
          return ScaleTransition(
            alignment: Alignment.center,
            scale: animation,
            child: child,
          );
        },
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secanimation) {
          return page;
        }));
  }

  static void toast(BuildContext context, String title) {
    Fluttertoast.showToast(
        msg: title,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  static void replace(BuildContext context, Widget page) {
    Navigator.of(context).pushReplacement(
      new MaterialPageRoute(builder: (context) => page),
    );
  }

  static void popUntil(BuildContext context, Widget page, int remove) {
    int count = 0;
    Navigator.popUntil(context, (route) {
      return count++ == remove;
    });
    Navigator.of(context).pushReplacement(
      new MaterialPageRoute(builder: (context) => page),
    );
  }

  static void makeFirst(BuildContext context, Widget page) {
    Navigator.of(context).popUntil((predicate) => predicate.isFirst);
    Navigator.of(context).pushReplacement(
      new MaterialPageRoute(builder: (context) => page),
    );
  }

  static void pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void dismissAlert(context) {
    Navigator.of(context).pop();
  }
}
