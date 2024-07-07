import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_weather_assignment/forecast_screen.dart';
import 'package:the_weather_assignment/weather_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final WeatherService _weatherService = WeatherService();
  String _city = "Faisalabad";//city set by default.
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showCitySelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter City Name'),
          content: TypeAheadField(
            suggestionsCallback: (pattern) async {
              return await _weatherService.fetchCitySuggestions(pattern);//fetches city suggestions.
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion['name']),
              );
            },
            onSelected: (city) {
              setState(() {
                _city = city['name'];//sets city to the city selected.
              });
              Navigator.pop(context);
              _navigateToForecastScreen();
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToForecastScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForecastScreen(city: _city)),//navigates to forecast screen.
    );
  }

  Future<void> _fetchWeather() async {
    try {
      final weatherData = await _weatherService.fetchCurrentWeather(_city);
      print(weatherData);  // Just for checking the fetched data
    } catch (e) {
      print(e);
    }
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
        actions: [
          IconButton(//another button to select city
            icon: Icon(Icons.location_on),
            onPressed: _showCitySelectionDialog,
          ),
        ],
      ),
      body: Container(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 40,),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _animation.value * 2 * 3.14159,
                    child: Opacity(
                      opacity: _animation.value,
                      child: child,
                    ),
                  );
                },
                child: Image.network(
                  'https://cdn-icons-png.freepik.com/256/11693/11693441.png?ga=GA1.1.1203188098.1697200163&semt=ais_hybrid',
                  height: 200,
                  width: 200,
                ),
              ),
              SizedBox(height: 50),

              Text(
                'Your pocket weather guide!',
                style: GoogleFonts.lato(
                    fontSize: 25,
                    color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 62),

              ElevatedButton(
                onPressed: _showCitySelectionDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1A2344),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Select City',
                  style: GoogleFonts.abrilFatface(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}