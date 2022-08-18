import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:sieu_cap_tinh_luong/main.dart';

part 'working_day.g.dart';

@HiveType(typeId: 2)
class WorkingDay extends HiveObject with EquatableMixin {
  @HiveField(0)
  final int date;
  @HiveField(1)
  final double timeIn;
  @HiveField(2)
  final double timeOut;
  @HiveField(3)
  final bool hasBreak;

  WorkingDay({
    required this.date,
    required this.timeIn,
    required this.timeOut,
    required this.hasBreak,
  });

  double get totalWorkingHour => timeOut - timeIn - (hasBreak ? 1 : 0);

  double get calculateOvertime {
    if (edition == Edition.mama) {
      return totalWorkingHour >= 8 ? totalWorkingHour - 8 : totalWorkingHour - 4;
    } else {
      return totalWorkingHour - 8;
    }
  }

  WorkingDay copyWith({
    int? date,
    double? timeIn,
    double? timeOut,
    bool? hasBreak,
  }) {
    return WorkingDay(
      date: date ?? this.date,
      timeIn: timeIn ?? this.timeIn,
      timeOut: timeOut ?? this.timeOut,
      hasBreak: hasBreak ?? this.hasBreak,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'timeIn': timeIn,
      'timeOut': timeOut,
      'hasBreak': hasBreak,
    };
  }

  factory WorkingDay.fromMap(Map<String, dynamic> map) {
    return WorkingDay(
      date: map['date']?.toInt() ?? 0,
      timeIn: map['timeIn']?.toDouble() ?? 0.0,
      timeOut: map['timeOut']?.toDouble() ?? 0.0,
      hasBreak: map['hasBreak'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkingDay.fromJson(String source) =>
      WorkingDay.fromMap(json.decode(source));

  @override
  String toString() {
    return 'WorkingDay(date: $date, timeIn: $timeIn, timeOut: $timeOut, hasBreak: $hasBreak)';
  }

  @override
  List<Object?> get props => [date, timeIn, timeOut, hasBreak];
}
