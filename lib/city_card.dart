import 'package:flutter/material.dart';
import 'city_details.dart';
import "city_full_details.dart";

class CityCard extends StatelessWidget {
  final CityDetails city;

  const CityCard(this.city, {super.key});
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CityFullDetails(city),
        ));
      },
      child: Container(
          color: Color.fromARGB(255, 254, 255, 255),
          child: Align(
            alignment: Alignment(-.50, .5),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  city.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  city.weather != null ? city.weather : "",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  city.Temperature.toString() + "°C",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                )
              ],
            ),
          )),
    ));
  }
}
