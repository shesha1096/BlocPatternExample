import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:weather_app/bloc/weather_bloc.dart';
import 'package:weather_app/bloc/weather_event.dart';

import 'bloc/weather_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Weather App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late Position _currentPosition;
  late List<Placemark> placeMarks;
  final WeatherBloc weatherBloc = WeatherBloc(); // Always make sure to initialise it.
  late String cityName;
  late String? temperature;
  late String? condition;
  late String? humidity;
  late String? windSpeed;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  @override
  void initState() {
    // TODO: implement initState
    _getCurrentLocation();
    super.initState();
  }

  /**
   * This function first requests the user to grant the location permission.
   * Once granted, it then uses the geolocator library to get the latitude and longitude.
   * Once it has the latitude and longitude, it then uses the placemarkFromCoordinates API to get the list of possible locations from the above values.
   * Using this, we can access the locality/suburb of the user.
   */
  _getCurrentLocation() async
  {
    LocationPermission permission;
    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
    }

     Position position = await  Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high, forceAndroidLocationManager: false);

    placeMarks = await placemarkFromCoordinates(position.latitude, position.longitude);


      setState(() {
        cityName = placeMarks[0].locality!;
        //cityName = "Sydney";
      });

      //Once we have the locality name, we need to pass it to the underlying layer.
      //To the initialised bloc, we add an event of type GetWeather, and we pass the city name to it.
      weatherBloc.add(GetWeather(cityName));
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(

            title: Text(widget.title),
          ),
          body:

              /*
              The bloc provider is listening on the weatherBloc object to identify any change in the state through the BlocListener.
               */
          BlocProvider(
            create: (_) => weatherBloc,
            child: BlocListener<WeatherBloc, WeatherState>(
              listener: (context, state) {
                if (state is WeatherError) {
                  //If the state of the bloc is an error, display appropriate message.
                  //Similarly, the same can be done for the other states defined in the WeatherState class.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message!),
                    ),
                  );
                }
              },
              child: BlocBuilder<WeatherBloc, WeatherState> (
                builder: (context, state) {

                  if (state is WeatherLoading)
                    {
                      return
                        Center(
                          child: CircularProgressIndicator(color: Colors.black,),
                        );
                    }

                  else if (state is WeatherLoaded) // Successful scenario
                  {
                    temperature = state.weather.current?.tempC.toString();
                    condition = state.weather.current?.condition?.text;
                    humidity = state.weather.current?.humidity.toString();
                    windSpeed = state.weather.current?.gustKph.toString();

                    return Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height/4,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.orange,
                          child:
                          Padding(
                            padding: EdgeInsets.fromLTRB(50, 50, 50, 50),
                            child: Column(
                              children: [
                                Text(cityName,style: TextStyle(color: Colors.white, fontSize: 18.0),)
                                ,

                                Text(temperature.toString(),style: TextStyle(color: Colors.white, fontSize: 28.0),)
                                ,

                                Text(condition.toString(),style: TextStyle(color: Colors.white, fontSize: 18.0),)
                                ,

                              ],
                            ),
                          ),
                        )
                        ,
                        SizedBox(height: 20.0,)
                        ,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.thermostat)
                            ,
                            Text('Temperature', style: TextStyle(color: Colors.black, fontSize: 16.0),)
                            ,
                            Text(temperature.toString(), style: TextStyle(color: Colors.black, fontSize: 16.0),)
                          ],
                        )
                        ,
                        SizedBox(height: 20.0,)
                        ,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.cloud)
                            ,
                            Text('Weather', style: TextStyle(color: Colors.black, fontSize: 16.0),)
                            ,
                            Text(condition.toString(), style: TextStyle(color: Colors.black, fontSize: 16.0),)
                          ],
                        )
                        ,
                        SizedBox(height: 20.0,)
                        ,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.shower)
                            ,
                            Text('Humidity', style: TextStyle(color: Colors.black, fontSize: 16.0),)
                            ,
                            Text(humidity.toString(), style: TextStyle(color: Colors.black, fontSize: 16.0),)
                          ],
                        )
                        ,
                        SizedBox(height: 20.0,)
                        ,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.air)
                            ,
                            Text('Wind Speed', style: TextStyle(color: Colors.black, fontSize: 16.0),)
                            ,
                            Text(windSpeed.toString(), style: TextStyle(color: Colors.black, fontSize: 16.0),)
                          ],
                        )
                      ],
                    );
                  }
                  else {
                    return Container();
                  }
                },
              ),
            ),
          )



      );
    }
  }

