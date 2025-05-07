import 'package:flutter/material.dart';



import 'package:weather/weather.dart';
import 'package:google_fonts/google_fonts.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final WeatherFactory wf = WeatherFactory('e07d58cfdc95cb993a238ce7d502367e');
  Weather? weather;
  List<dynamic> forecast = [];
  Map data = {};
  String location = 'Unknown location';
  String time = 'Unknown time';

  String bgimage ='Unkown';
  Color? bgColor = Colors.white;


  @override
  void initState() {

    super.initState();

  }

  void fetchWeather(String location) async {
    try {
      Weather w = await wf.currentWeatherByCityName('$location');
      setState(() {
        weather = w;
      });
    } catch (e) {
      print('Error fetching weather: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    // Retrieve route arguments and ensure they are a Map
    final routeData =data.isNotEmpty ? data : ModalRoute.of(context)!.settings.arguments;
    if (routeData != null && routeData is Map) {
      data = routeData as Map<dynamic, dynamic>;
      location = data['location'] ?? 'Unknown location';
      time = data['time'] ?? 'Unknown time';

      //set background
      if (data['isDaytime']) {
        bgimage = 'day.png';
      } else {
        bgimage = 'night.png';
      }
      if (data['isDaytime']) {
        bgColor = Colors.blue;
      } else {
        bgColor = Colors.indigo[700];
      }
      fetchWeather(location);

    }


    return Scaffold(
      backgroundColor:bgColor ,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/$bgimage'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 120.0, 0, 0),
            child: Column(
              children: [
                TextButton.icon(
                  onPressed: () async{
                    dynamic result = await Navigator.pushNamed(context, '/location');
                    setState(() {
                      data={
                        'time': result['time'],
                        'location':result['location'],
                        'isDaytime':result['isDaytime'],
                        'flag':result['flag'],
                      };
                      fetchWeather(location);
                    });
                  },
                  icon: Icon(Icons.edit_location,
                    color: Colors.grey[300],
                  ),
                  label: Text('edit location',
                    style: TextStyle(
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      location,
                      style: TextStyle(
                        fontSize: 25.0,
                        letterSpacing: 2.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 66.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 50.0),
                if (weather != null) ...[
                  Text( '${weather!.temperature?.celsius?.toStringAsFixed(1) ?? 'N/A'} °C',
                    style:GoogleFonts.lato( textStyle:TextStyle(
                        fontSize: 50.0,
                        color: Colors.white
                    ),
                    ),),

                  Text('Weather: ${weather!.weatherDescription}',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white70,
                      letterSpacing: 4.0,
                    ),),
                ] else ...[
                  CircularProgressIndicator(), // Show loading indicator while fetching weather
                ],

              ],
            ),
          ),
        ),
      ),
    );
  }
}
