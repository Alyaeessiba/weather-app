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

  IconData _getWeatherIcon(String condition) {
    condition = condition.toLowerCase();
    if (condition.contains('sun') || condition.contains('clear')) {
      return Icons.wb_sunny;
    } else if (condition.contains('rain')) {
      return Icons.grain;
    } else if (condition.contains('cloud')) {
      return Icons.cloud;
    } else if (condition.contains('snow')) {
      return Icons.ac_unit;
    } else if (condition.contains('thunder') || condition.contains('storm')) {
      return Icons.flash_on;
    } else if (condition.contains('wind')) {
      return Icons.air;
    } else if (condition.contains('fog') || condition.contains('mist')) {
      return Icons.cloud_queue;
    } else {
      return Icons.wb_cloudy;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.city} 7-Day Forecast'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
            ],
          ),
        ),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.secondary,
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: forecastData.length,
                itemBuilder: (context, index) {
                  final day = forecastData[index];
                  final date = DateTime.parse(day['date']);
                  final condition = day['day']['condition']['text'];
                  final maxTemp = day['day']['maxtemp_c'];
                  final minTemp = day['day']['mintemp_c'];
                  final humidity = day['day']['avghumidity'];
                  final windSpeed = day['day']['maxwind_kph'];
                  final rainChance = day['day']['daily_chance_of_rain'];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ExpansionTile(
                      childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      title: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getWeatherIcon(condition),
                              color: Theme.of(context).colorScheme.primary,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('EEEE, MMM d').format(date),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  condition,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${maxTemp.round()}°C',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                              Text(
                                '${minTemp.round()}°C',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      children: [
                        const Divider(),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildDetailColumn(
                              context,
                              Icons.water_drop,
                              'Humidity',
                              '$humidity%',
                            ),
                            _buildDetailColumn(
                              context,
                              Icons.air,
                              'Wind',
                              '$windSpeed km/h',
                            ),
                            _buildDetailColumn(
                              context,
                              Icons.umbrella,
                              'Rain',
                              '$rainChance%',
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildDetailColumn(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
