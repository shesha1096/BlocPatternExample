import 'package:weather_app/model/weather.dart';

import 'api_provider.dart';


/**
 * This class is similar to what a repository/service does in microservices architecture or Android MVVM architecture.
 * It can either connect to API calls, or fetch data from databases.
 */

class ApiRepository {
  final _provider = ApiProvider();

  Future<Weather> fetchWeatherData(String city) {
    return _provider.fetchWeatherData(city);
  }
}

class NetworkError extends Error {}