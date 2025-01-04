import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/weather_model.dart';

class WeatherServices {
  
  fetchWeather() async {
    final response = await http.get(
      Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?lat=34.01325&lon=6.83255&appid=1c0ba4fdef74f1e845b79eb8623cd32e"),
    );
    // now we can cange latitude and longitude and let's see how it perfrom.
    try {
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        return WeatherData.fromJson(json);
      } else {
        throw Exception('Failed to load Weather data');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}