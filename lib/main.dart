import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weathr_map_app/Controller/weather_contrloller.dart';
import 'package:weathr_map_app/Screen/home_screen.dart';
import 'package:get/get.dart';

import 'Controller/network_type.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: BindingsBuilder(() => {
            Get.put(NetworkConnecationType()),
            Get.put(WeatherController()),
          }),
      title: 'Weather App',
      theme: ThemeData(
          useMaterial3: true,
          primaryColor: Colors.white,
          backgroundColor: Color.fromARGB(255, 172, 210, 228),
          brightness: Brightness.light),
      home: const HomeScreen(),
    );
  }
}
