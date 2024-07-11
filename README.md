# the_weather_assignment

A new Flutter project.

## Getting Started

# Weather Forecast App

## Overview

The Weather Forecast App is a beautifully designed Flutter application that
provides real-time weather information.
Users can search for any city and view the current weather as well as a 7-day forecast.
The app features smooth animations and a pastel-themed UI to enhance user experience.

## Features

- Real-Time Weather: Get current weather updates for any city.
- 7-Day Forecast: View weather predictions for the upcoming week.
- City Search: Easily search for and select different cities to view their weather data.
- Beautiful Animations: Experience delightful animations, a rotating weather logo.
- Pastel-Themed UI: Enjoy a visually appealing interface with a pastel color palette.


## Getting Started
## Screenshots
![homescreen](https://github.com/Subaina-Usman/Weather-App/assets/174721286/f571b548-6f5f-4932-aa1f-c004503927bd)
![search for city](https://github.com/Subaina-Usman/Weather-App/assets/174721286/daf60157-9199-47f6-9c88-ff84a16dd8e7)
![forecast screen](https://github.com/Subaina-Usman/Weather-App/assets/174721286/ce67fb47-7fa2-42f4-b9d4-ab87de7accdb)
![7 day forecast screen](https://github.com/Subaina-Usman/Weather-App/assets/174721286/75339028-df91-4f96-bdd9-bb6b5486b325)






### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- OpenWeatherMap API Key: [Get your API key](https://openweathermap.org/api)


## User Instructions:

- On the home screen, you can search for a city by tapping the location icon in the app bar or the button city search.
- View the current weather and a 7-day forecast for the selected city.
- Enjoy the dynamic weather animation on the home screen.
## Code Overview

### HomeScreen

The HomeScreen widget serves as the main interface for the app. It includes:
- An app bar with a city search feature.
- A weather logo animation.
- A button(city search) to search for city and  navigate to the forecast screen.

- ### ForecastScreen
- The forecast screen shows the current detailed weather.The forecast screen shows icon 
- according to current weather, current temperature in celsius.text to describe current weather.Maximum and minimum temperature
- for the day.It also shows the sunrise and sunset time,humidity and wind in kph.
- It also includes a button to refresh the app.
- A button 7 day forecast which leads to the 7-day forecast details.

### 7ForecastScreen

The ForecastScreen widget displays the 7-day weather forecast for the selected city.
including temperature in celsius,date details,maximum and minimum temperature,icon 
to show current weather and text to describe current weather

### WeatherService

The WeatherService class handles fetching weather data from the weatherAPI.

### Animations

- Weather Logo Animation: The logo rotates and fades in and out.



## Acknowledgments

- Thanks to WeatherAPI.com for providing the weather data API.
- Icons from [Freepik](https://www.freepik.com/).

---
