import 'dart:async';

import 'dart:async';
import 'package:flutter/material.dart';

class ShowAnimationFailedPage extends StatefulWidget {
  ShowAnimationFailedPage({super.key});
  @override
  State<ShowAnimationFailedPage> createState() =>
      _ShowAnimationFailedPageState();
}

class _ShowAnimationFailedPageState extends State<ShowAnimationFailedPage> {
  var time = DateTime.now();

  var isFailed = false;

  var _isLoading = true;

  void showFailedScreen() {
    if (mounted)
      setState(() {
        _isLoading = false;
      });
  }

  // ignore: non_constant_identifier_names
  Timer scheduleTimeout([int milliseconds = 20000]) =>
      Timer(Duration(milliseconds: milliseconds), showFailedScreen);
  @override
  Widget build(BuildContext context) {
    scheduleTimeout(20000);

    return _isLoading
        ? Container(
            height: MediaQuery.of(context).size.height * .2,
            width: MediaQuery.of(context).size.height * .6,
            color: Colors.white,
            child: Image.asset(
              "media/loading2.gif",
              width: double.minPositive,
              height: double.minPositive,
            ),
          )
        : Center(
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Center(
                  child: Container(
                    child: Text(
                      "Oops Something went wrong!!! Try Reopening the App",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
