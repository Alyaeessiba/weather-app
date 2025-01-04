import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Services/services.dart';
import 'forecast_page.dart';
import '../widgets/hourly_forecast.dart';
import '../widgets/sun_position.dart';
import 'favorite_locations_page.dart';
import '../widgets/weather_alert.dart';
import '../widgets/weather_stats.dart';
import '../widgets/wind_moon_info.dart';
import 'settings_page.dart';

class WeatherHome extends StatefulWidget {
  final VoidCallback onThemeToggle;

  const WeatherHome({
    super.key,
    required this.onThemeToggle,
  });

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  final WeatherServices _weatherServices = WeatherServices();
  final TextEditingController _searchController = TextEditingController();
  List<String> filteredCities = [];
  Map<String, dynamic>? weatherData;
  bool isLoading = true;
  String currentCity = 'London';
  List<String> favoriteLocations = ['London'];
  bool useCelsius = true;
  bool showAlerts = true;

  // List of major cities
  final List<String> cities = [
    'London', 'New York', 'Paris', 'Tokyo', 'Dubai',
    'Singapore', 'Hong Kong', 'Sydney', 'Toronto', 'Berlin',
    'Madrid', 'Rome', 'Moscow', 'Beijing', 'Seoul',
    'Mumbai', 'Cairo', 'Rio de Janeiro', 'Cape Town', 'Istanbul',
    'Amsterdam', 'Vienna', 'Stockholm', 'Oslo', 'Copenhagen',
    'Helsinki', 'Prague', 'Budapest', 'Warsaw', 'Athens',
    'Barcelona', 'Lisbon', 'Dublin', 'Edinburgh', 'Brussels',
    'Zurich', 'Geneva', 'Milan', 'Venice', 'Munich',
    'Hamburg', 'Frankfurt', 'Vancouver', 'Montreal', 'Melbourne',
    'Auckland', 'Wellington', 'Jakarta', 'Bangkok', 'Manila'
  ];

  void _filterCities(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCities = [];
      } else {
        filteredCities = cities
            .where((city) => city.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
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
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    setState(() => isLoading = true);
    try {
      final data = await _weatherServices.fetchCurrentWeather(currentCity);
      setState(() {
        weatherData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _showSearchDialog() async {
    String? result = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Search City'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Enter city name',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _filterCities(value);
                  });
                },
              ),
              const SizedBox(height: 8),
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.3,
                ),
                child: filteredCities.isEmpty
                    ? const Center(
                        child: Text('No cities found'),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredCities.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const Icon(Icons.location_city),
                            title: Text(filteredCities[index]),
                            onTap: () {
                              Navigator.pop(context, filteredCities[index]);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_searchController.text.isNotEmpty) {
                  Navigator.pop(context, _searchController.text);
                }
              },
              child: const Text('Search'),
            ),
          ],
        ),
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        currentCity = result;
        _searchController.clear();
        filteredCities = [];
        _loadWeather();
      });
    }
  }

  String _getTemperature(double temp) {
    return useCelsius ? '${temp.round()}°C' : '${(temp * 9 / 5 + 32).round()}°F';
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEEE d, MMMM yyyy').format(DateTime.now());
    String formattedTime = DateFormat('hh:mm a').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weather Forecast',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            iconSize: 32,
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    useCelsius: useCelsius,
                    showAlerts: showAlerts,
                    onTemperatureUnitChanged: (value) {
                      setState(() {
                        useCelsius = value;
                      });
                    },
                    onAlertsToggled: (value) {
                      setState(() {
                        showAlerts = value;
                      });
                    },
                    onThemeToggle: () {
                      widget.onThemeToggle();
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
            )
          : Container(
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Enter city name',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          height: 56,
                          width: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.secondary,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: () {
                              if (_searchController.text.isNotEmpty) {
                                setState(() {
                                  isLoading = true;
                                  currentCity = _searchController.text;
                                });
                                _loadWeather();
                                _searchController.clear();
                              }
                            },
                            icon: const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          weatherData!['location']['name'],
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                favoriteLocations.contains(currentCity)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (favoriteLocations.contains(currentCity)) {
                                    favoriteLocations.remove(currentCity);
                                  } else {
                                    favoriteLocations.add(currentCity);
                                  }
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.list),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FavoriteLocationsPage(
                                      favoriteLocations: favoriteLocations,
                                      currentCity: currentCity,
                                      onLocationSelected: (location) {
                                        setState(() {
                                          currentCity = location;
                                          isLoading = true;
                                        });
                                        _loadWeather();
                                      },
                                      onLocationRemoved: (location) {
                                        setState(() {
                                          favoriteLocations.remove(location);
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                _getWeatherIcon(weatherData!['current']['condition']['text']),
                                size: 64,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              _getTemperature(weatherData!['current']['temp_c']),
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              weatherData!['current']['condition']['text'],
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              weatherData!['location']['name'],
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Weather Details',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontSize: 20,
                                ),
                          ),
                          const SizedBox(height: 24),
                          _buildWeatherDetail(
                            context,
                            'Humidity',
                            '${weatherData!['current']['humidity']}%',
                            Icons.water_drop,
                          ),
                          Divider(color: Theme.of(context).dividerColor, height: 32),
                          _buildWeatherDetail(
                            context,
                            'Wind Speed',
                            '${weatherData!['current']['wind_kph']} km/h',
                            Icons.air,
                          ),
                          Divider(color: Theme.of(context).dividerColor, height: 32),
                          _buildWeatherDetail(
                            context,
                            'Pressure',
                            '${weatherData!['current']['pressure_mb']} mb',
                            Icons.speed,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    if (weatherData!['alerts'] != null && showAlerts) ...[
                      Text(
                        'Weather Alerts',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontSize: 20,
                            ),
                      ),
                      const SizedBox(height: 16),
                      WeatherAlert(
                        title: weatherData!['alerts']['alert'][0]['event'] ?? 'Weather Alert',
                        description: weatherData!['alerts']['alert'][0]['desc'] ?? 'No description available',
                        severity: AlertSeverity.moderate,
                        time: DateTime.now(),
                      ),
                      const SizedBox(height: 40),
                    ],
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Weather Statistics',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontSize: 20,
                                ),
                          ),
                          const SizedBox(height: 24),
                          WeatherStats(
                            temperatures: [
                              for (var hour in weatherData!['forecast']['forecastday'][0]['hour'])
                                double.parse(hour['temp_c'].toString())
                            ],
                            dates: [
                              for (var hour in weatherData!['forecast']['forecastday'][0]['hour'])
                                DateTime.parse(hour['time'])
                            ],
                            minTemp: weatherData!['forecast']['forecastday'][0]['day']['mintemp_c'],
                            maxTemp: weatherData!['forecast']['forecastday'][0]['day']['maxtemp_c'],
                            precipitation: weatherData!['forecast']['forecastday'][0]['day']['daily_chance_of_rain'] / 100,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Wind & Moon',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontSize: 20,
                                ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: WindCompass(
                                  windDirection: weatherData!['current']['wind_degree'].toDouble(),
                                  windSpeed: weatherData!['current']['wind_kph'].toDouble(),
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: MoonPhase(
                                  phase: 0.5, // You'll need to calculate this based on the moon phase data
                                  phaseName: weatherData!['forecast']['forecastday'][0]['astro']['moon_phase'],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Today\'s Forecast',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontSize: 20,
                                ),
                          ),
                          HourlyForecast(
                            hourlyData: weatherData!['forecast']['forecastday'][0]['hour'],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    SunPosition(
                      sunrise: weatherData!['forecast']['forecastday'][0]['astro']['sunrise'] ?? '06:00 AM',
                      sunset: weatherData!['forecast']['forecastday'][0]['astro']['sunset'] ?? '06:00 PM',
                      currentTime: weatherData!['current']['last_updated'] ?? DateTime.now().toIso8601String(),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ForecastPage(
                city: currentCity,
              ),
            ),
          );
        },
        child: const Icon(Icons.calendar_today),
      ),
    );
  }

  Widget _buildWeatherDetail(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).textTheme.bodyMedium?.color,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildWeatherInfo(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
