import 'package:flutter/material.dart';

class CityDetailsCard extends StatelessWidget {
  final heading;
  final detail;
  CityDetailsCard(this.heading, this.detail, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: SizedBox(
          width: 300,
          height: 200,
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Center(
                    child: Text(
                  heading,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )),
                Center(
                  child: Text(detail,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 20)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
