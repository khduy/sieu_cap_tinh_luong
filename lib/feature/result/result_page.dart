import 'package:flutter/material.dart';
import '../../config/utils/common_func.dart';
import '../../data/model/worker.dart';
import '../../widgets/custom_button.dart';

import '../../widgets/decimal_text_field.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({
    Key? key,
    required this.worker,
  }) : super(key: key);
  final Worker worker;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  FocusNode myFocusNode = FocusNode();

  double totalWorkingDay = 0;

  double totalOvertime = 0;

  double tongluongngay = 0;

  double tongluongtangca = 0;

  late TextEditingController basicSalaryController;

  late TextEditingController overtimeSalaryController;

  late TextEditingController totalWorkingDayController;

  late TextEditingController totalOvertimeController;

  @override
  initState() {
    super.initState();
    // Dì 4
    // tongngay = widget.worker.workingDays.length.toDouble();

    // Má
    for (var day in widget.worker.workingDays) {
      if (day.totalWorkingHour >= 8) {
        totalWorkingDay += 1;
      } else {
        totalWorkingDay += 0.5;
      }
    }

    for (var element in widget.worker.workingDays) {
      totalOvertime += element.calculateOvertime;
    }

    basicSalaryController = TextEditingController(
      text: formatNumber(widget.worker.basicSalary),
    );

    overtimeSalaryController = TextEditingController(
      text: formatNumber(widget.worker.overtimeSalary),
    );

    totalWorkingDayController = TextEditingController(
      text: formatNumber(totalWorkingDay),
    );
    totalOvertimeController = TextEditingController(
      text: formatNumber(totalOvertime),
    );

    tongluongngay = nhan(totalWorkingDay, widget.worker.basicSalary);
    tongluongtangca = nhan(totalOvertime, widget.worker.overtimeSalary);
  }

  double nhan(double? a, double? b) {
    a = a ?? 0;
    b = b ?? 0;
    return a * b;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kết quả')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ngày:'),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: DecimalTextField(
                    controller: totalWorkingDayController,
                    onChanged: (value) {
                      setState(() {
                        tongluongngay = nhan(
                          double.tryParse(value),
                          double.tryParse(basicSalaryController.text),
                        );
                      });
                    },
                  ),
                ),
                const Text(' x '),
                Expanded(
                  flex: 3,
                  child: DecimalTextField(
                    controller: basicSalaryController,
                    onChanged: (value) {
                      setState(() {
                        tongluongngay = nhan(
                          double.tryParse(value),
                          double.tryParse(totalWorkingDayController.text),
                        );
                      });
                    },
                    onSubmitted: (_) => myFocusNode.requestFocus(),
                  ),
                ),
                const Text(' = '),
                Expanded(
                  flex: 4,
                  child: Text(
                    formatNumber(tongluongngay),
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Tăng ca:'),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: DecimalTextField(
                    controller: totalOvertimeController,
                    onChanged: (value) {
                      setState(() {
                        tongluongtangca = nhan(
                          double.tryParse(value),
                          double.tryParse(overtimeSalaryController.text),
                        );
                      });
                    },
                  ),
                ),
                const Text(' x '),
                Expanded(
                  flex: 3,
                  child: DecimalTextField(
                    focusNode: myFocusNode,
                    controller: overtimeSalaryController,
                    onChanged: (value) {
                      setState(() {
                        tongluongtangca = nhan(
                          double.tryParse(value),
                          double.tryParse(totalOvertimeController.text),
                        );
                      });
                    },
                  ),
                ),
                const Text(' = '),
                Expanded(
                  flex: 4,
                  child: Text(
                    formatNumber(tongluongtangca),
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
              child: Divider(
                height: 1,
                thickness: 2,
              ),
            ),
            Row(
              children: [
                const Text('Tổng:'),
                const Spacer(),
                Text(
                  formatNumber(tongluongtangca + tongluongngay),
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 150,
                child: CustomButton(
                  onPressed: () => Navigator.pop(context),
                  text: 'OK',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
