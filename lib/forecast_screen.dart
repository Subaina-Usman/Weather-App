import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_weather_assignment/7_forecast_screen.dart';
import 'package:the_weather_assignment/weather_service.dart';

class ForecastScreen extends StatefulWidget {
  final String city;

  const ForecastScreen({required this.city, super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? _currentWeather;
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    _selectedCity = widget.city;
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {
      final weatherData = await _weatherService.fetchCurrentWeather(_selectedCity!);
      setState(() {
        _currentWeather = weatherData;
      });
    } catch (e) {
      print(e);
    }
  }

  void _showCitySelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newCity = '';
        return AlertDialog(
          title: Text('Enter City Name'),
          content: TypeAheadField(
            suggestionsCallback: (pattern) async {
              return await _weatherService.fetchCitySuggestions(pattern);
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion['name']),
              );
            },
            onSelected: (city) {
              newCity = city['name'];
            },

          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (newCity.isNotEmpty) {
                  setState(() {
                    _selectedCity = newCity;
                  });
                  _fetchWeather();
                }
                Navigator.pop(context);
              },
              child: Text('Submit'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1A2344),
        title: Text('Weather App',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: _currentWeather == null
          ? Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A2344),
              Color(0xFF81C7D4),
              Color(0xFFD0F4DE),
              Color(0xFF6497B1),
            ],
          ),
        ),
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xff2C3E50),
          ),
        ),
      )
          : Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A2344),
              Color(0xFF81C7D4),
              Color(0xFFD0F4DE),
              Color(0xFF6497B1),
            ],
          ),
        ),
        child: ListView(
          children: [
            SizedBox(height: 10),
            InkWell(
              onTap: _showCitySelectionDialog,
              child: Text(
                _selectedCity!,
                style: GoogleFonts.lato(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  Image.network(
                    'http:${_currentWeather!['current']['condition']['icon']}',//for weather icon
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    '${_currentWeather!['current']['temp_c'].round()}°C',//for current temperature
                    style: GoogleFonts.lato(
                      fontSize: 36,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    '${_currentWeather!['current']['condition']['text']}',//for weather detail in text
                    style: GoogleFonts.lato(
                      fontSize: 35,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Max: ${_currentWeather!['forecast']['forecastday'][0]['day']['maxtemp_c'].round()}°C',//for max temp
                        style: GoogleFonts.lato(
                          fontSize: 26,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Min: ${_currentWeather!['forecast']['forecastday'][0]['day']['mintemp_c'].round()}°C',//for minimum temp.
                        style: GoogleFonts.lato(
                          fontSize: 26,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildWeatherDetail(
                    'Sunrise',
                    Icons.wb_sunny,
                    _currentWeather!['forecast']['forecastday'][0]
                    ['astro']['sunrise']),//for sunrise
                _buildWeatherDetail(
                    'Sunset',
                    Icons.brightness_3,
                    _currentWeather!['forecast']['forecastday'][0]
                    ['astro']['sunset'])//for sunset
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildWeatherDetail('Humidity', Icons.opacity,
                    _currentWeather!['current']['humidity']),//for humidity
                _buildWeatherDetail('Wind(kph)', Icons.wind_power,
                    _currentWeather!['current']['wind_kph']),//for wind in kmh.
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            sevenForecastScreen(city: _selectedCity!)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1A2344),
                  padding: EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  'Next 7 days forecast',
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchWeather,
        backgroundColor: Color(0xFF1A2344),
        child: Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  Widget _buildWeatherDetail(String label, IconData icon, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Container(
            padding: EdgeInsets.all(5),
            height: 110,
            width: 110,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd,
                    colors: [
                      Color(0xFF1A2344).withOpacity(0.5),
                      Color(0xFF1A2344).withOpacity(0.2),
                    ])),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  label,
                  style: GoogleFonts.lato(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  value is String ? value : value.toString(),
                  style: GoogleFonts.lato(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
