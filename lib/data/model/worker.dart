// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import 'working_day.dart';

part 'worker.g.dart';

@HiveType(typeId: 1)
class Worker extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double basicSalary;

  @HiveField(2)
  final double overtimeSalary;

  @HiveField(3)
  final List<WorkingDay> workingDays;

  Worker({
    required this.name,
    required this.basicSalary,
    required this.overtimeSalary,
    required this.workingDays,
  });

  Worker copyWith({
    String? name,
    double? basicSalary,
    double? overtimeSalary,
    List<WorkingDay>? workingDays,
  }) {
    return Worker(
      name: name ?? this.name,
      basicSalary: basicSalary ?? this.basicSalary,
      overtimeSalary: overtimeSalary ?? this.overtimeSalary,
      workingDays: workingDays ?? this.workingDays,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'basicSalary': basicSalary,
      'overtimeSalary': overtimeSalary,
      'workingDays': workingDays.map((x) => x.toMap()).toList(),
    };
  }

  factory Worker.fromMap(Map<String, dynamic> map) {
    return Worker(
      name: map['name'] ?? '',
      basicSalary: map['basicSalary']?.toDouble() ?? 0.0,
      overtimeSalary: map['overtimeSalary']?.toDouble() ?? 0.0,
      workingDays: List<WorkingDay>.from(map['workingDays']?.map((x) => WorkingDay.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Worker.fromJson(String source) => Worker.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Worker(name: $name, basicSalary: $basicSalary, overtimeSalary: $overtimeSalary, workingDays: $workingDays)';
  }

  @override
  List<Object> get props => [name, basicSalary, overtimeSalary, workingDays];
}
