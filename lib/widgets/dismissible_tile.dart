import 'package:flutter/material.dart';
import '../data/model/working_day.dart';

import '../config/utils/common_func.dart';

class DismissibleTile extends StatelessWidget {
  const DismissibleTile({
    required Key key,
    required this.workingDay,
    required this.onDismissed,
  }) : super(key: key);

  final WorkingDay workingDay;

  final Function(DismissDirection) onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key!,
      background: Container(
        padding: const EdgeInsets.only(left: 20),
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        color: Colors.redAccent,
      ),
      secondaryBackground: Container(
        padding: const EdgeInsets.only(right: 20),
        child: const Align(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        color: Colors.redAccent,
      ),
      onDismissed: onDismissed,
      child: ListTile(
        leading: Text(workingDay.date.toString()),
        title: Row(
          children: [
            Text(
              '${formatNumber(workingDay.timeIn)}  -  ${formatNumber(workingDay.timeOut)}',
            ),
            const Spacer(),
            Text(handleResult(workingDay)),
          ],
        ),
      ),
    );
  }

  // Dì 4 ======================================
  String handleResult(WorkingDay workingDay) {
    final prefix = workingDay.totalWorkingHour > 8 ? '+' : '-';

    // unsign overTime
    double overTime = workingDay.calculateOvertime >= 0
        ? workingDay.calculateOvertime
        : workingDay.calculateOvertime * -1;

    if (overTime == 0) return '1';

    return '1 $prefix ${formatNumber(overTime)}';
  }

  // Má ===================================
  // String handleResult(WorkingDay workingDay) {
  //   final prefix = workingDay.totalWorkingHour > 8 ? '+' : '-';

  //   double overTime = workingDay.calculateOvertime;

  //   return '$prefix ${formatNumber(overTime)}';
  // }
}
