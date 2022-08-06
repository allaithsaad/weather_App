class FiveDayData {
  final DateTime? dateTime;
  List<Weather>? weather = [];
  final int? temp;

  FiveDayData({this.dateTime, this.weather, this.temp});

  factory FiveDayData.fromJson(dynamic json) {
    if (json == null) {
      return FiveDayData();
    }
    var tx = DateTime.parse(json['dt_txt']).add(const Duration(hours: 3));
    return FiveDayData(
      weather:
          (json['weather'] as List).map((e) => Weather.fromJson(e)).toList(),
      dateTime: DateTime(tx.year, tx.month, tx.day),
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
