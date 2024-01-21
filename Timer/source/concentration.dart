class Concentration {
  String? date;
  String? time;
  int? cctTime;
  int? cctScore;
  int? id;

  Concentration({this.date, this.time, this.cctTime, this.cctScore, this.id});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'cctTime': cctTime,
      'cctScore': cctScore,
    };
  }
}