import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'city_detail_card.dart';
import 'city_details.dart';

class CityFullDetails extends StatelessWidget {
  final CityDetails city;
  const CityFullDetails(this.city, {super.key});

  @override
  Widget build(BuildContext context) {
    String s = city.Temperature.toString() + "°C  |  " + (city.weather);

    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text(city.name),
        centerTitle: true,
        bottom: PreferredSize(
            child: Text(
              s,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            ),
            preferredSize: Size.zero),
      ),
      body: Container(
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                      child: CityDetailsCard(
                          "Sunrise", city.Sunrise.toString() + "  (GMT)")),
                  Expanded(
                      child: CityDetailsCard(
                          "Precipitation", city.Precipitation.toString())),
                  Expanded(
                      child: CityDetailsCard(
                          "Visibility", city.Visibility.toString())),
                  Expanded(
                      child: CityDetailsCard(
                          "Winds", city.Winds.toString() + "m/s")),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                      child: CityDetailsCard(
                          "Sunset", city.Sunset.toString() + "  (GMT)")),
                  Expanded(
                      child: CityDetailsCard(
                          "Humidity", city.Humidity.toString() + "%")),
                  Expanded(
                      child: CityDetailsCard(
                          "Clouds", city.Clouds.toString() + "%")),
                  Expanded(
                      child: CityDetailsCard(
                          "Pressure", city.Pressure.toString() + "mb")),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
