import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:weatherapp/components/weather_item.dart';
import 'widgets/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;  // make sure this is imported

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => Myhomestate();
}

class Myhomestate extends State<Homepage> {
  final TextEditingController _citycontroller = TextEditingController();
  final Constants _constants = Constants();
  static String apikey = 'b74bcb4fff74435182365243250609';
  String location = "Chiniot";
  String weathericon = "assets/heavycloudy.png";
  int temperature = 0;
  int windspeed = 0;
  int humidity = 0;
  int cloud = 0;
  String currentdate = "";
  String currentweatherstatus = "";

  List hourlyweatherforecast = [];
  List dailyweatherforecast = [];

  String weathersearch = "http://api.weatherapi.com/v1/forecast.json?key=" + apikey + "&days=7&q=";

  void fetchWeatherData(String searchText) async {
    try {
      final response = await http.get(Uri.parse(weathersearch + searchText));
      final weatherData = json.decode(response.body) as Map<String, dynamic>;

      if (weatherData.containsKey("error")) {
        print("API Error: ${weatherData['error']['message']}");
        return;
      }

      var locationData = weatherData['location'];
      var currentWeather = weatherData['current'];

      setState(() {
        location = getShortLocationName(locationData['name']);

        var parseDate =
        DateTime.parse(locationData["localtime"].substring(0, 10));
        var newDate = DateFormat('MMMEEEd').format(parseDate);
        currentdate = newDate;

        // update weather
        currentweatherstatus = currentWeather["condition"]['text'];
        weathericon = currentweatherstatus.replaceAll(" ", "").toLowerCase() + ".png";
        temperature = currentWeather['temp_c'].toInt();
        humidity = currentWeather['humidity'].toInt();
        cloud = currentWeather['cloud'].toInt();
        windspeed = currentWeather['wind_kph'].toInt();

        // update forecasts (only if available)
        if (weatherData['forecast'] != null) {
          dailyweatherforecast = weatherData['forecast']['forecastday'];
          hourlyweatherforecast = dailyweatherforecast[0]['hour'];
        }
      });
    } catch (e) {
      print("Exception: $e");
    }
  }

  static String getShortLocationName(String s){
    List<String>wordList=s.split(" ");
    if(wordList.isNotEmpty){
      if(wordList.length>1){
        return wordList[0]+" "+ wordList[1];
      }
      else {
        return wordList[0];
      }
    }
    else{
      return " ";
    }

  }
  @override
  void initState() {
    super.initState();
    fetchWeatherData(location); // fetch Chiniot at startup
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: size.width,
        height: size.height,
        padding: EdgeInsets.only(top: 70, left: 10, right: 10),
        color: _constants.primarycolor.withOpacity(.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: size.height * .7,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                gradient: _constants.lineargradientblue,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _constants.primarycolor.withOpacity(.4), // shadow color
                    spreadRadius: 5, // how much it spreads
                    blurRadius: 10, // softness
                    offset: Offset(0, 5), // x, y position
                  ),
                ],
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Menu Icon (Left)
                        Image.asset(
                          'assets/menu.png',
                          width: 35,
                          height: 35,
                        ),

                        // Location (Center)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/pin.png', width: 20),
                            SizedBox(width: 3),
                            Text(
                              location,
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            IconButton(
                              onPressed: () {
                                _citycontroller.clear();
                                showBarModalBottomSheet(context: context, builder: (context)=>SingleChildScrollView(
                                  controller:ModalScrollController.of(context),
                                  child: Container(
                                    height: size.height*.2,
                                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: 70,
                                          child: Divider(
                                            thickness: 3.5,
                                            color: _constants.primarycolor,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextField(
                                          onChanged: (searchText){
                                            fetchWeatherData(searchText);
                                          },
                                          controller: _citycontroller,
                                          autofocus: true,
                                          decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                Icons.search,
                                                color: _constants.primarycolor,),
                                              suffixIcon:GestureDetector(
                                                onTap: _citycontroller.clear,
                                                child: Icon(
                                                  Icons.close,
                                                  color: _constants.primarycolor,
                                                ),
                                              ),
                                              hintText: 'search city e.g london',
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: _constants.primarycolor,
                                                ),
                                                borderRadius: BorderRadius.circular(20),
                                              )
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ));
                              },
                              icon: Icon(Icons.keyboard_arrow_down,
                                  color: Colors.white),
                            ),
                          ],
                        ),

                        // Profile Icon (Right)
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person,
                              color: Colors.blue, size: 25),
                          // OR use an image:
                          // backgroundImage: AssetImage('assets/profile.png'),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),

                    // Weather Icon (centered)
                    Center(
                      child: SizedBox(
                        height: 280,
                        child: Image.asset("assets/$weathericon"),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(temperature.toString(),
                            style: TextStyle(
                              fontSize: 80,
                              foreground: Paint()..shader = shader,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          "°",
                          style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()..shader = shader,
                          ),
                        )
                      ],
                    ),
                    Text(currentweatherstatus,style: TextStyle(color: Colors.white70,fontSize: 20),),
                    Text(currentdate,style: TextStyle(color: Colors.white70)),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(
                          color: Colors.white70,
                          thickness: 1,
                        )
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            WeatherItem(value: windspeed.toInt(), unit: 'km/h', imageUrl: 'assets/windspeed.png'),
                            WeatherItem(value: humidity.toInt(), unit: 'km/h', imageUrl: 'assets/humidity.png'),
                            WeatherItem(value: cloud.toInt(), unit: 'km/h', imageUrl: 'assets/cloud.png')
                          ],
                        )
                    ),
                  ]),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0),
              height:size.height*.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Today",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                      GestureDetector(
                          onTap: (){},
                          child: Text("Forecast",style: TextStyle(color: _constants.primarycolor,fontSize: 16),)),
                    ],
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      itemCount: hourlyweatherforecast.length,
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        String forecastTime = hourlyweatherforecast[index]['time'].substring(11, 16);
                        String forecastHour = hourlyweatherforecast[index]['time'].substring(11, 13);
                        String currentHour = DateFormat('HH').format(DateTime.now());

                        String forecastName = hourlyweatherforecast[index]["condition"]["text"];
                        String forecastIcon = forecastName.toLowerCase().replaceAll(" ", "") + ".png";
                        String forecastTemp = hourlyweatherforecast[index]["temp_c"].round().toString();

                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          margin: EdgeInsets.only(right: 20),
                          width: 60,
                          decoration: BoxDecoration(
                            color: currentHour == forecastHour
                                ? _constants.primarycolor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 5,
                                spreadRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                forecastTime,
                                style: TextStyle(
                                  color: _constants.greycolor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Image.asset("assets/$forecastIcon", width: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    forecastTemp,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: _constants.greycolor,
                                    ),
                                  ),
                                  Text(
                                    "°",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: _constants.greycolor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],),
            )
          ],
        ),
      ),
    );
  }
}
