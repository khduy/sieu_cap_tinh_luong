// ignore_for_file: must_be_immutable

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

  @override
  String toString() {
    return 'Worker(name: $name, basicSalary: $basicSalary, overtimeSalary: $overtimeSalary, workingDays: $workingDays)';
  }

  @override
  List<Object> get props => [name, basicSalary, overtimeSalary, workingDays];
}
