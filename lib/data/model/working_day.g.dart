// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'working_day.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkingDayAdapter extends TypeAdapter<WorkingDay> {
  @override
  final int typeId = 2;

  @override
  WorkingDay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkingDay(
      date: fields[0] as int,
      timeIn: fields[1] as double,
      timeOut: fields[2] as double,
      hasBreak: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, WorkingDay obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.timeIn)
      ..writeByte(2)
      ..write(obj.timeOut)
      ..writeByte(3)
      ..write(obj.hasBreak);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkingDayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
