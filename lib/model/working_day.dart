// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:sieu_cap_tinh_luong/main.dart';
import 'package:sieu_cap_tinh_luong/utils/double_extension.dart';

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

  factory WorkingDay.fromGemini(Map<String, dynamic> map) {
    return WorkingDay(
      date: int.tryParse(map['date']) ?? 0,
      timeIn: timeAsDouble(map['timeIn']).roundToQuarter(),
      timeOut: timeAsDouble(map['timeOut']).roundToQuarter(),
      hasBreak: true,
    );
  }

  @override
  String toString() {
    return 'WorkingDay(date: $date, timeIn: $timeIn, timeOut: $timeOut, hasBreak: $hasBreak)';
  }

  @override
  List<Object?> get props => [date, timeIn, timeOut, hasBreak];

  static double timeAsDouble(String? time) {
    if (time == null || time.isEmpty) return 0;
    final parts = time.split(':');
    final hours = double.parse(parts[0]);
    final minutes = double.parse(parts[1]);
    return hours + (minutes / 60);
  }
}
