// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:weathr_map_app/Controller/network_type.dart';
import 'package:weathr_map_app/Model/five_days_data.dart';

import '../Model/current_weather_data.dart';
import '../Model/five_days_data_3_hour.dart';

class WeatherController extends GetxController {
  String apiKey = 'ec4df545d2519ec6dc4830fc95cf2df9';
  final String _uri = 'https://api.openweathermap.org/data/2.5';

  List<CurrentWeatherData> currentWeatherData = [];

  List<FiveDayData> fiveDaysData = [];

  List<FiveDayData3Hour> fiveDaysData3Hours = [];

  String city = 'sanaa';
  String lan = 'ar';

  Box? box1;
  final String _currentWetherHiveKey = 'currentWether';
  final String _forcastWetherHiveKey = 'forcastWether';

  final networkConnecationType = Get.find<NetworkConnecationType>();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    hiveIn();
    getCurrentWheather();
    getForcastWheather();
  }

  final _dio = Dio();
  RxBool loading = false.obs;
  RxBool loading2 = false.obs;
  RxBool loading3 = false.obs;

  getCurrentWheather() async {
    loading2.value = true;
    try {
      _dio
          .get('$_uri/weather?q=$city&lang=$lan&appid=$apiKey')
          .then((response) {
        if (response.statusCode == 200) {
          print(response.data.toString());
          strorCureentWheather(response.data);
        } else if (response.statusCode == 404) {
          Get.snackbar('Error', 'هناك خطاء في اسم المدينة');
        } else {
          Get.snackbar('Error', 'هناك مشكلة تأكد من إتصالك بالإنترنت  .');
        }
      }).onError((error, stackTrace) {
        if (error.toString().contains('Http status error [404]')) {
          Get.snackbar('Error', 'هناك خطاء في اسم المدينة');
        } else {
          Get.snackbar('Error', 'هناك مشكلة تأكد من إتصالك بالإنترنت  .');
        }
      });
      loading2.value = false;
      update();
    } catch (error) {
      log(error.toString());
      loading2.value = false;
      update();
    }
  }

  hiveIn() async {
    box1 = await Hive.openBox('StoreWeather').whenComplete(() {
      log('Box is Opend ');
    });
  }

  strorCureentWheather(var res) async {
    loading2.value = true;
    if (box1 == null) {
      box1 = await Hive.openBox('StoreWeather');
      box1!.put(_currentWetherHiveKey, res!);
      log('store current data Done 1');
      getStordCureentwheather();
    } else {
      box1!.put(_currentWetherHiveKey, res!);
      log('store current data Done 2 ');
      getStordCureentwheather();
    }
    loading2.value = false;
    update();
  }

  getStordCureentwheather() async {
    loading.value = true;

    if (box1 == null) {
      try {
        box1 = await Hive.openBox('StoreWeather');
        currentWeatherData.clear();
        var value = box1!.get(_currentWetherHiveKey);
        currentWeatherData.add(CurrentWeatherData.fromJson(value));

        log('Current Data box is not open');
        log('Get current data Done 1');
        update();
        loading.value = false;
      } catch (e) {
        log(e.toString());
        loading.value = false;
      }
      loading.value = false;
    } else {
      var value = box1!.get(_currentWetherHiveKey);
      currentWeatherData.add(CurrentWeatherData.fromJson(value));
      log('Current Data box is not open');
      log('Get current data Done 2');
      loading.value = false;
      update();
    }
  }

  RxBool loading4 = false.obs;
  RxBool loading5 = false.obs;
  RxBool loading6 = false.obs;
  getForcastWheather() async {
    loading4.value = true;
    try {
      _dio
          .get('$_uri/forecast?q=$city&lang=$lan&appid=$apiKey')
          .then((response) {
        if (response.statusCode == 200) {
          print(response.data.toString());
          strorForcastWheather(response.data);
          loading4.value = false;
        } else if (response.statusCode == 404) {
          loading4.value = false;
        } else {
          loading4.value = false;
        }
      }).onError((error, stackTrace) {
        if (error.toString().contains('Http status error [404]')) {
          loading4.value = false;
        } else {
          loading4.value = false;
        }
      });
    } catch (error) {
      loading4.value = false;
      log(error.toString());
    }
  }

  strorForcastWheather(var res) async {
    loading5.value = true;
    if (box1 == null) {
      box1 = await Hive.openBox('StoreWeather');
      box1!.put(_forcastWetherHiveKey, res!);
      log('store forcast data Done 1');
      getStordForcastwheather();
      loading5.value = false;
    } else {
      box1!.put(_forcastWetherHiveKey, res!);
      log('store forcast data Done 2 ');
      getStordForcastwheather();
      loading5.value = false;
    }
  }

  List<FiveDayData> filterList(List<FiveDayData> models) {
    List<FiveDayData> resList = [];

    for (var model in models) {
      bool peerless = true;

      for (var result in resList) {
        if (result.dateTime == model.dateTime) {
          peerless = false;
        }
      }

      if (peerless) {
        resList.add(model);
      }
    }

    return resList;
  }

  getStordForcastwheather() async {
    loading6.value = true;

    if (box1 == null) {
      try {
        box1 = await Hive.openBox('StoreWeather');
        fiveDaysData.clear();
        var value = box1!.get(_forcastWetherHiveKey);
        fiveDaysData = (value['list'] as List)
            .map((t) => FiveDayData.fromJson(t))
            .toList();
        fiveDaysData3Hours.clear();
        fiveDaysData3Hours = (value['list'] as List)
            .map((t) => FiveDayData3Hour.fromJson(t))
            .toList();

        fiveDaysData = filterList(fiveDaysData);

        log('Forcast Data box is not open');
        log('Get Forcast data Done 1');
        update();
        loading6.value = false;
      } catch (e) {
        log(e.toString());
        loading6.value = false;
      }
      loading6.value = false;
    } else {
      var value = box1!.get(_forcastWetherHiveKey);
      fiveDaysData.clear();
      fiveDaysData =
          (value['list'] as List).map((t) => FiveDayData.fromJson(t)).toList();

      fiveDaysData3Hours.clear();
      fiveDaysData3Hours = (value['list'] as List)
          .map((t) => FiveDayData3Hour.fromJson(t))
          .toList();

      fiveDaysData = filterList(fiveDaysData);

      log('Forcast Data box is not open');
      log('Get Forcast data Done 2');
      log(fiveDaysData.length.toString());
      update();
      loading6.value = false;
    }
  }
}
