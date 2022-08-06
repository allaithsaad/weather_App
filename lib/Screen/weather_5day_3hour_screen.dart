import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../Controller/weather_contrloller.dart';

class WeatherFor5Day3Hours extends StatelessWidget {
  const WeatherFor5Day3Hours({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weatherController = Get.find<WeatherController>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: FittedBox(
                  child: Text(
                    "Forecast Weather For the caming 5 days every 3 Hours .",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'flutterfonts'),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                height: Get.height,
                width: Get.width * 0.9,
                child: ListView.builder(
                  itemCount: weatherController.fiveDaysData3Hours.length,
                  itemBuilder: (context, index) {
                    var data = weatherController.fiveDaysData3Hours[index];

                    return Card(
                      color: Colors.blueGrey,
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        trailing: Text('${data.temp} \u2103',
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                        title: Center(
                          child: Column(
                            children: [
                              Text(data.weather![0].description!),
                              Text(
                                  // ignore: prefer_interpolation_to_compose_strings
                                  DateFormat.MMMd().format(data.dateTime!) +
                                      ' ' +
                                      DateFormat.jm().format(data.dateTime!)),
                            ],
                          ),
                        ),
                        leading: CachedNetworkImage(
                          height: 50,
                          width: 50,
                          imageUrl:
                              "http://openweathermap.org/img/wn/${data.weather![0].icon!}@2x.png",
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                                colorFilter: const ColorFilter.mode(
                                    Colors.transparent, BlendMode.colorBurn),
                              ),
                            ),
                          ),
                          placeholder: (context, url) => const LoadingIndicator(
                            indicatorType: Indicator.ballPulse,
                            colors: [
                              Colors.white,
                              Colors.blueGrey,
                              Colors.grey
                            ],
                            strokeWidth: 2,
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
