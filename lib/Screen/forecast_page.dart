import 'package:flutter/material.dart';
import '../Services/services.dart';
import 'package:intl/intl.dart';

class ForecastPage extends StatefulWidget {
  final String city;

  const ForecastPage({super.key, required this.city});

  @override
  State<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  final WeatherServices _weatherServices = WeatherServices();
  List<dynamic> forecastData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadForecast();
  }

  Future<void> _loadForecast() async {
    try {
      final forecast = await _weatherServices.fetch7DayForecast(widget.city);
      setState(() {
        forecastData = forecast['forecast']['forecastday'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('7-Day Forecast for ${widget.city}'),
        backgroundColor: const Color(0xFF676BD0),
      ),
      backgroundColor: const Color(0xFF676BD0),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: forecastData.length,
              itemBuilder: (context, index) {
                final day = forecastData[index];
                final date = DateTime.parse(day['date']);
                final condition = day['day']['condition']['text'];
                final maxTemp = day['day']['maxtemp_c'];
                final minTemp = day['day']['mintemp_c'];

                return Card(
                  color: Colors.white.withOpacity(0.1),
                  child: ListTile(
                    title: Text(
                      DateFormat('EEEE, MMM d').format(date),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      condition,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: Text(
                      '${maxTemp.round()}°C / ${minTemp.round()}°C',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
