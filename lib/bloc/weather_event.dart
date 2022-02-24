import 'package:equatable/equatable.dart';
import 'package:weather_app/model/weather.dart';


/**
 * The event that gets put into the bloc, which triggers the next flow to fetch the data from the API.
 */


abstract class GetWeatherEvent extends Equatable {
  final String cityName;
  const GetWeatherEvent(this.cityName);

  @override
  List<Object> get props => [];
}

class GetWeather extends GetWeatherEvent {
  GetWeather(String cityName) : super(cityName);
}


