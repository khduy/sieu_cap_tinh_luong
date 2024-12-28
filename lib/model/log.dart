import 'package:intl/intl.dart';

class Log {
  final dynamic error;
  final DateTime time;
  final StackTrace? stackTrace;

  Log(this.error, {this.stackTrace}) : time = DateTime.now();

  @override
  String toString() {
    const timeFormat = 'yyyy-MM-dd HH:mm:ss.SSS';
    final baseLog = '[${DateFormat(timeFormat).format(time)}] $error';
    if (stackTrace != null) {
      return '$baseLog\n$stackTrace';
    }
    return baseLog;
  }
}
