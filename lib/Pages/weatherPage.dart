import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/modles/weathermodel.dart';
import 'package:weather_app/services/weather-services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherpageState();
}

class _WeatherpageState extends State<WeatherPage> {
  final _weatherService = WeatherService("ae7bfeac3959db565175f230115ac2d2");
  Weather? _weather;

  // Fetch weather data asynchronously
  _fetchWeather() async {
    try {
      String cityName = await _weatherService.getCurrentCity();
      print("Fetched city: $cityName"); // Debugging line
      final weather = await _weatherService.getWeather(cityName);
      print(
          "Fetched weather: ${weather.temperature}, ${weather.cityName}"); // Debugging line
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print("Error fetching weather: $e");
    }
    String getCurrentAnimation(String? mainCondition) {
      if (mainCondition == null) return 'assets/sun animation.json';
      switch (mainCondition.toLowerCase()) {
        case 'clouds':
        case 'mist':
        case 'smoke':
        case 'haze':
        case 'dust':
        case 'fog':
          return 'assets/cloud.json';
        case 'rain':
        case 'drizzle':
        case 'shower rain':
          return 'assets/rain.json';
        case 'clear':
          return 'assets/sun animation.json';
        default:
          return 'assets/sun animation.json';
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather(); // Fetch weather data when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Center(
        child: _weather == null
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _weather?.cityName ?? 'Loading city..',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Lottie.asset(
                    'assets/rain.json',
                    width: 100,
                    height: 100,
                  ),
                  Text(
                    '${_weather?.temperature.round()}°C',
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _weather?.mainCondition ?? '',
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
      ),
    );
  }
}
