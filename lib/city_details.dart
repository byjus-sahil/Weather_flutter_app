class CityDetails {
  var name;
  var Temperature;
  var weather;
  var Sunrise;
  var Sunset;
  var Precipitation;
  var Humidity;
  var Visibility;
  var Clouds;
  var Winds;
  var Pressure;
  var icon;
  var hour;
  var min;

  CityDetails(
      {required this.name,
      required this.Temperature,
      required this.weather,
      required this.Sunrise,
      required this.Sunset,
      required this.Precipitation,
      required this.Humidity,
      required this.Visibility,
      required this.Clouds,
      required this.Winds,
      required this.Pressure,
      required this.icon,
      required this.hour,
      required this.min});

  CityDetails.fromMap(Map<String, dynamic> item)
      : name = item["name"].toString(),
        Sunrise = item["Sunrise"].toString(),
        Temperature = item["Temperature"].toString(),
        Winds = item["Winds"].toString(),
        Visibility = item["Visibility"].toString(),
        Precipitation = item["Precipitation"].toString(),
        Pressure = item["Pressure"].toString(),
        weather = item["weather"].toString(),
        Sunset = item["Sunset"].toString(),
        Clouds = item["Clouds"].toString(),
        Humidity = item["Humidity"].toString(),
        icon = item["icon"].toString(),
        hour = item["hour"],
        min = item["min"];

  Map<String, String> toMap() {
    return {
      'name': name.toString(),
      'Temperature': Temperature.toString(),
      'Winds': Winds.toString(),
      'Precipitation': Precipitation.toString(),
      'Pressure': Pressure.toString(),
      'Clouds': Clouds.toString(),
      'icon': icon.toString(),
      'weather': weather.toString(),
      'Sunrise': Sunrise.toString(),
      'Sunset': Sunset.toString(),
      'Visibility': Visibility.toString(),
      'Humidity': Humidity.toString(),
      'hour': hour.toString(),
      'min': min.toString(),
    };
  }
}
