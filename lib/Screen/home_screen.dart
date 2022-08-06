import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:weathr_map_app/Controller/weather_contrloller.dart';
import 'package:weathr_map_app/Screen/weather_5day_3hour_screen.dart';

import 'Widgets/my_search_delegate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final weatherController = Get.find<WeatherController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    weatherController.getStordCureentwheather();
    weatherController.getStordForcastwheather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        elevation: 1,
        title: const Text('Search'),
        actions: [
          IconButton(
              onPressed: () {
                _showSearch(context: context, delegate: MySearchDelegate());
              },
              icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: GetBuilder<WeatherController>(
        init: Get.find<WeatherController>(),
        builder: (_) => Obx(
          () => weatherController.loading.value == true ||
                  weatherController.loading2.value == true ||
                  weatherController.loading3.value == true ||
                  weatherController.loading4.value == true ||
                  weatherController.loading5.value == true ||
                  weatherController.loading6.value == true
              ? Center(
                  child: SizedBox(
                    height: Get.height * 0.3,
                    width: Get.width * .5,
                    child: const LoadingIndicator(
                      indicatorType: Indicator.ballPulse,
                      colors: [Colors.white, Colors.blueGrey, Colors.grey],
                      strokeWidth: 5,
                    ),
                  ),
                )
              : weatherController.currentWeatherData.isEmpty ||
                      weatherController.fiveDaysData.isEmpty ||
                      weatherController.fiveDaysData.length < 2
                  ? Center(
                      child: loadingWidget(),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 10.0,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: currentWether(context),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Forecast Weather For the caming 5 days ",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'flutterfonts'),
                            ),
                          ),
                          weatherListBuilder()
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  SizedBox loadingWidget() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('SomeThing went Rong'),
          weatherController.loading.value == false &&
                  weatherController.loading3.value == false &&
                  weatherController.loading2.value == false
              ? IconButton(
                  onPressed: () {
                    weatherController.onInit();

                    Future.delayed(const Duration(seconds: 3), () {
                      setState(() {});
                    });
                  },
                  icon: const Icon(Icons.refresh_rounded))
              : Container()
        ],
      ),
    );
  }

  Card currentWether(BuildContext context) {
    return Card(
      elevation: 20,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: Container(
        width: Get.width * .9,
        height: Get.height * 0.3,
        decoration: const BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
            image: AssetImage(
              'assets/images/background-image.jpg',
            ),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Stack(children: [
          Container(
            color: Colors.transparent,
            width: Get.width,
            height: Get.height,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    weatherController.currentWeatherData[0].name ??
                        ''.toUpperCase(),
                    style: Theme.of(context).textTheme.caption!.copyWith(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'flutterfonts'),
                  ),
                  CachedNetworkImage(
                    height: 100,
                    width: 100,
                    imageUrl:
                        "http://openweathermap.org/img/wn/${weatherController.currentWeatherData[0].weather![0].icon ?? '10d'}@2x.png",
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
                      colors: [Colors.white, Colors.blueGrey, Colors.grey],
                      strokeWidth: 2,
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      "${(weatherController.currentWeatherData[0].main!.temp! - 273.15).round().toString()} \u2103",
                      style: const TextStyle(
                          fontSize: 30,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'flutterfonts')),
                  const SizedBox(
                    width: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.wind_power_sharp),
                      Text(
                        '  ${weatherController.currentWeatherData[0].wind!.speed} m/s',
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'flutterfonts',
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                weatherController
                    .currentWeatherData[0].weather![0].description!,
                style: Theme.of(context).textTheme.caption!.copyWith(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'flutterfonts'),
              )
            ],
          ),
        ]),
      ),
    );
  }

  SizedBox weatherListBuilder() {
    return SizedBox(
      width: Get.width * 0.9,
      child: ListView.builder(
        itemCount: weatherController.fiveDaysData.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var data = weatherController.fiveDaysData[index];

          return Card(
            color: Colors.blueGrey,
            elevation: 20,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              onTap: () {
                Get.to(() => const WeatherFor5Day3Hours());
              },
              trailing: Text('${data.temp} \u2103',
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold)),
              title: Center(
                child: Text(
                    // ignore: prefer_interpolation_to_compose_strings
                    DateFormat.MMMMd().format(data.dateTime!)),
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
                  colors: [Colors.white, Colors.blueGrey, Colors.grey],
                  strokeWidth: 2,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSearch(
      {required BuildContext context,
      required MySearchDelegate delegate}) async {
    final resul = await showSearch(context: context, delegate: delegate);
    if (resul != null) {
      log(resul.toString());
      log("----------------------------------");
      weatherController.city = resul;
      weatherController.onInit();
    }
  }
}
