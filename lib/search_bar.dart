import 'package:flutter/material.dart';
import 'package:weather_app/cities_list.dart';
import 'cities_list.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController _controller;
  final Function searchCity;
  const SearchBar(this._controller, this.searchCity, {super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.all(10),
        suffixIcon: Align(
          widthFactor: 1,
          heightFactor: 1,
          child: Icon(Icons.search),
        ),
      ),
      onSubmitted: (value) {
        searchCity(value);
      },
    );
  }
}
