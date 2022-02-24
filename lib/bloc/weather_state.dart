import 'package:equatable/equatable.dart';
import 'package:weather_app/model/weather.dart';


/**
 * We can define any number of states.
 * In our case, we have initial, loading, loaded and error.
 * Based on the above states which the BlocListener is listening to in the main.dart, we can render appropriate widgets.
 * We can think of the state in bloc as a means to determine what is coming out of the container into which the events are put.
 */

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final Weather weather;
  const WeatherLoaded(this.weather);
}

class WeatherError extends WeatherState {
  final String? message;
  const WeatherError(this.message);
}