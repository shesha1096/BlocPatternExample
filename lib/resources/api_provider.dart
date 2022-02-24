import 'package:dio/dio.dart';
import 'package:weather_app/model/weather.dart';
import 'package:weather_app/auth/apikey.dart';

/**
 * Here's where the API call is made. I have used the dio library to make the API call.
 * I have used a free weather API to get the weather conditions.
 * https://weatherapi.com
 */


class ApiProvider {
  final Dio _dio = Dio();
  final String _url = 'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=';

  Future<Weather> fetchWeatherData(String city) async {
    try {
      Response response = await _dio.get(_url+city);
      return Weather.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return Weather.withError("Data not found / Connection issue");
    }
  }
}