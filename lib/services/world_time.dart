import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';



class WorldTime{

  String location;//location name
  String time ='';//time in that location
  String flag;
  String url;//location url
  bool isDaytime= false;

  WorldTime({required this.location,required this.flag,required this.url});

  Future<void> getTime() async{

    try{
      http.Response response = await http.get(
          Uri.parse('https://worldtimeapi.org/api/timezone/$url')
      );
      Map data = jsonDecode(response.body);
      String datetime=data['datetime'];
      String offset=data['utc_offset'];
      //print(datetime);
      //print(offset);


      //create datetime object
      DateTime now = DateTime.parse(datetime);
      String offsetHour = offset.substring(1, 3);
      now = now.add(Duration(hours:int.parse(offsetHour) ));
      //set the time property
      isDaytime = now.hour > 6 && now.hour < 20 ? true : false;
      time = DateFormat.jm().format(now);
    }
    catch(e){
      print('there is error:$e');
      time='could not get time data';
    }



  }

}
