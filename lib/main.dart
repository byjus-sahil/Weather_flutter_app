import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'city_card.dart';
import 'search_bar.dart';
import 'icon_card.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:http/http.dart' as http;
import 'city_details.dart';
import 'show_animation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'suggestion_class.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final TextEditingController _typeAheadController = TextEditingController();

  var dataLoaded = false;
  int index = 0;
  var dataFetchedTime;
  var currTime;
  var locationPermission = false;
  var database;
//Check if connected to internet

  Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      return true;
    }

    return false;
  }

//Accessing location Functionality
  Future<Position> acessLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String url = "https://api.weatherbit.io/v2.0/current?lat=" +
        position.latitude.toString() +
        "&lon=" +
        position.longitude.toString() +
        "&key=e829727554344ae4b3e41e5278033f0c";

    var dt = DateTime.now();
    final response = await http.get(Uri.parse(url));

    if (response.body.isNotEmpty) {
      var cityData = json.decode(response.body);
      cityData = cityData["data"][0];

      CityDetails cityDetail = CityDetails(
          name: cityData["city_name"],
          Temperature: cityData["app_temp"],
          weather: cityData["weather"]["description"] == null
              ? "No Weather Data"
              : cityData["weather"]["description"],
          Sunrise: cityData["sunrise"],
          Sunset: cityData["sunset"],
          Precipitation: cityData["precip"] == null
              ? "data Not available"
              : cityData["precip"],
          Humidity: cityData["rh"],
          Visibility: cityData["vis"],
          Clouds: cityData["clouds"],
          Winds: cityData["wind_spd"],
          Pressure: cityData["pres"],
          icon: cityData["weather"]["icon"],
          hour: dt.hour,
          min: dt.minute);

      setState(() {
        citiesDetails.insert(0, cityDetail);
        dataLoaded = true;
      });
      insertCity(cityDetail);
      _pullRefresh();
    }

    return position;
  }

  //Database Initialization Function
  Future<Database> initialize_db() async {
    return database = await openDatabase(
      join(await getDatabasesPath(), 'cities_database7.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE cities(name TEXT PRIMARY KEY, icon TEXT,Precipitation TEXT,Temperature TEXT,Humidity TEXT,Sunrise TEXT,Sunset TEXT,Clouds TEXT,Winds TEXT,Pressure TEXT,Visibility TEXT,weather TEXT,hour INT,min INT)',
        );
      },
      version: 1,
    );
  }

// Function to insert City into Database
  Future<void> insertCity(CityDetails city) async {
    final db = await database;
    await db.insert(
      'cities',
      city.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Get all Cities from Database
  Future<List<CityDetails>> getCities() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cities');
    return List.generate(maps.length, (i) {
      return CityDetails(
        name: maps[i]['name'],
        Temperature: maps[i]['Temperature'],
        Winds: maps[i]['Winds'],
        Clouds: maps[i]['Clouds'],
        Sunrise: maps[i]['Sunrise'],
        Sunset: maps[i]['Sunset'],
        icon: maps[i]['icon'],
        Precipitation: maps[i]['Precipitation'],
        Pressure: maps[i]['Pressure'],
        Humidity: maps[i]['Humidity'],
        Visibility: maps[i]['Visibility'],
        weather: maps[i]['weather'],
        hour: maps[i]['hour'],
        min: maps[i]['min'],
      );
    });
  }

//List to store current Cities Data
  List<CityDetails> citiesDetails = [];

  void addCity(String city) {
    List<String> thisCity = [city];
    setState(() {
      dataLoaded = false;
    });
    getDetailsCity(thisCity).then((CityDetailss) => setState(() {
          dataLoaded = true;
          for (CityDetails cityy in CityDetailss) {
            citiesDetails.insert(0, cityy);
          }
          dataFetchedTime = DateTime.now();
        }));
  }

//Default Famous Cities
  var defaultCities = ["Mumbai", "Delhi", "Bangalore"];

//Get all details of current list of cities
  Future<List<CityDetails>> getDetailsCity(List<String> cities) async {
    String url1 = "https://api.weatherbit.io/v2.0/current?city=";
    String url2 = "&country=IN&key=e829727554344ae4b3e41e5278033f0c";
    var dt = DateTime.now();
    List<CityDetails> L1 = [];

    for (var city in cities) {
      final response = await http.get(Uri.parse(url1 + city + url2));
      if (response.body.isNotEmpty) {
        var cityData = json.decode(response.body);
        cityData = cityData["data"][0];

        CityDetails cityDetail = CityDetails(
            name: cityData["city_name"],
            Temperature: cityData["app_temp"],
            weather: cityData["weather"]["description"] == null
                ? "No Weather Data"
                : cityData["weather"]["description"],
            Sunrise: cityData["sunrise"],
            Sunset: cityData["sunset"],
            Precipitation: cityData["precip"] == null
                ? "data Not available"
                : cityData["precip"],
            Humidity: cityData["rh"],
            Visibility: cityData["vis"],
            Clouds: cityData["clouds"],
            Winds: cityData["wind_spd"],
            Pressure: cityData["pres"],
            icon: cityData["weather"]["icon"],
            hour: dt.hour,
            min: dt.minute);

        insertCity(cityDetail);
        L1.add(cityDetail);
      }
    }
    return L1.toSet().toList();
  }

//Get Data from Backend
  Future<List<CityDetails>> updateFromDB() async {
    List<CityDetails> Findit = await getCities();
    return Findit;
  }

  void doit() async {
    bool result = await InternetConnectionCheckerPlus().hasConnection;
    if (result == true) {
      var p = await acessLocation();
    } else {
      setState(() {
        dataLoaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    initialize_db().then((value) {
      updateFromDB().then((value) => setState(() {
            citiesDetails.addAll(value);

            if (value.length != 0) {
              int hr = value[0].hour;
              if (DateTime.now().hour - hr >= 2) {
                _pullRefresh();
              }
            }
          }));
      if (citiesDetails.length <= 3) {
        getDetailsCity(defaultCities).then((CityDetails) => setState(() {
              citiesDetails.addAll(CityDetails);
              dataFetchedTime = DateTime.now();
            }));
      }
      var p = doit();
//Load data from Database
    });
  }

//Refresh on Scroll functionality
  Future<void> _pullRefresh() async {
    setState(() {
      dataLoaded = false;
    });
    updateFromDB().then((value) {
      List<String> lisst = [];
      for (var k in value) {
        lisst.add(k.name);
        print(k.name);
      }
      getDetailsCity(lisst).then((CityDetails) => setState(() {
            for (var k in CityDetails) {
              print(k.name);
              insertCity(k);
            }
            citiesDetails = CityDetails;
            dataLoaded = true;
          }));
    });
  }

  void Retry() {
    _pullRefresh();
  }

  String suggestion = "";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text("Weather App"),
      ),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  decoration: InputDecoration(labelText: 'Search City'),
                  controller: this._typeAheadController,
                ),
                suggestionsCallback: (pattern) async {
                  return await getSuggestions(pattern);
                },
                transitionBuilder: (context, suggestionsBox, controller) {
                  return suggestionsBox;
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  this._typeAheadController.text = suggestion;
                  addCity(suggestion);
                }),
            Expanded(
                child: dataLoaded == true
                    ? ListView.builder(
                        itemCount: citiesDetails.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            color: Colors.white,
                            height: 100,
                            width: double.infinity,
                            margin: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                CityCard(citiesDetails[index]),
                                IconCard(
                                    citiesDetails[index].icon,
                                    citiesDetails[index].hour,
                                    citiesDetails[index].min),
                              ],
                            ),
                          );
                        },
                      )
                    : ShowAnimationFailedPage(Retry)),
          ]),
        ),
      ),
    ));
  }
}
