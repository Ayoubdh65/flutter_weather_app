import 'package:flutter/material.dart';
import 'package:world_time/services/world_time.dart';

class ChooseLocation extends StatefulWidget {
  const ChooseLocation({super.key});

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {

  List<WorldTime> locations =[
    WorldTime(location: 'London', flag: 'uk.png', url: 'Europe/London'),
    WorldTime(location: 'Athene', flag: 'greece.png', url: 'Europe/Berlin'),
    WorldTime(location: 'Chicago', flag: 'usa.jpg', url: 'America/Chicago'),
    WorldTime(location: 'Tunisia', flag: 'tunis.png', url: 'Africa/Tunis'),
  ];

  void updatetime (index) async{
    WorldTime instance = locations[index];
    await instance.getTime();
    //navigate to home screen
    Navigator.pop(context , {
      'location':instance.location,
      'flag':instance.flag,
      'time':instance.time,
      'isDaytime':instance.isDaytime,
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('choose a location'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder:(context, index){
          return Padding(
            padding: const EdgeInsets.symmetric(vertical:1.0 , horizontal: 4.0 ),
            child: Card(
              child: ListTile(
                onTap: (){
                  updatetime (index);
                },
                title: Text(locations[index].location),
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/${locations[index].flag}'),
                ),
              ),
            ),
          );
        } ,

      ) ,
    );
  }
}
