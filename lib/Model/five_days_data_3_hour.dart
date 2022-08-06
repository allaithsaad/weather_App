class FiveDayData3Hour {
  final DateTime? dateTime;
  List<Weather>? weather = [];
  final int? temp;

  FiveDayData3Hour({this.dateTime, this.weather, this.temp});

  factory FiveDayData3Hour.fromJson(dynamic json) {
    if (json == null) {
      return FiveDayData3Hour();
    }
    return FiveDayData3Hour(
      weather:
          (json['weather'] as List).map((e) => Weather.fromJson(e)).toList(),
      dateTime: DateTime.parse(json['dt_txt']).add(const Duration(hours: 3)),
      temp: (double.parse(json['main']['temp'].toString()) - 273.15).round(),
    );
  }
}

class Weather {
  final int? id;
  final String? main;
  final String? description;
  final String? icon;

  Weather({this.id, this.main, this.description, this.icon});

  factory Weather.fromJson(dynamic json) {
    if (json == null) {
      return Weather();
    }

    return Weather(
        id: json['id'],
        main: json['main'],
        description: json['description'],
        icon: json['icon']);
  }
}
