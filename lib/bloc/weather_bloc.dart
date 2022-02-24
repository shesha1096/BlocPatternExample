import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/weather_event.dart';
import 'package:weather_app/bloc/weather_state.dart';
import 'package:weather_app/resources/api_repository.dart';


/**
 * We need to think of the bloc pattern as a container into which events are put, and the
 * thing that comes out from the box is a state. It is very similar to the LiveData concept in Android.
 * The bloc listens to the events that are put into it, and based on the type of event, it performs appropriate actions.
 * In our case, we have only event. However, several types of events can be added to this bloc.
 */

class WeatherBloc extends Bloc<GetWeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {

    final ApiRepository _apiRepository = ApiRepository();
    /*
    Notice how we are listening to our event which we have defined in weather_event.dart.
    At first, we emit WeatherLoading state out of the container, so that the listener understands that the API call has been initiated.
     */
    on<GetWeather>((event, emit) async {
      try {
        emit(WeatherLoading());
        final mList = await _apiRepository.fetchWeatherData(event.cityName); // Accessing the city name from the event.
        emit(WeatherLoaded(mList));
        if (mList.error != null) {
          emit(WeatherError(mList.error));
        }
      } on NetworkError {
        emit(WeatherError("Could not fetch data. is your device online?"));
      }
    });
  }
}