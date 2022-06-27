import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../config/utils/common_func.dart';
import '../../data/model/working_day.dart';
import '../result/result_page.dart';
import '../../widgets/dismissible_tile.dart';
import 'cubit/break_cubit.dart';
import '../../config/constant/constant.dart';
import '../../data/model/worker.dart';
import '../../widgets/custom_button.dart';

import '../../widgets/decimal_text_field.dart';
import '../../widgets/dialog.dart';

enum TextFocus {
  vao,
  ra,
}

class WorkingDaysPage extends StatelessWidget {
  WorkingDaysPage({Key? key, required this.worker}) : super(key: key);
  final Worker worker;

  final vaoController = TextEditingController();
  final veController = TextEditingController();
  final ngayController = TextEditingController();
  final scrollController = ScrollController();

  final vaoFNode = FocusNode();
  final veFNode = FocusNode();
  final textFocus = TextFocus.vao;

  final breakCubit = BreakCubit();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(worker.name),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CustomButton(
                  child: const Icon(
                    Icons.delete_rounded,
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  color: Colors.redAccent,
                  onPressed: () async {
                    var deleteAll = await showDeleteConfirmDialog(
                      context,
                      content: 'Xóa tất cả?',
                    );
                    if (deleteAll == true) {
                      _deleteAllWorkingDay();
                    }
                  },
                ),
                const SizedBox(width: 8),
                CustomButton(
                  child: const Icon(
                    Icons.view_stream,
                    color: Colors.white,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.green,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultPage(worker: worker),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder<Box<Worker>>(
              valueListenable: Hive.box<Worker>(kWorkerBoxName).listenable(
                keys: [worker.key],
              ),
              builder: (context, workers, widget) {
                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  controller: scrollController,
                  itemCount: workers.get(worker.key)?.workingDays.length ?? 0,
                  itemBuilder: (context, index) {
                    return DismissibleTile(
                      key: UniqueKey(),
                      workingDay: worker.workingDays[index],
                      onDismissed: (direction) {
                        _deleteWorkingDay(index);
                      },
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(
                    indent: 15,
                    endIndent: 15,
                    thickness: 1,
                    height: 1,
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[800]
                : Colors.black12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: ngayController,
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Colors.black12,
                          filled: true,
                          hintText: 'Ngày',
                        ),
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(vaoFNode);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: BlocBuilder<BreakCubit, bool>(
                        bloc: breakCubit,
                        builder: (context, state) {
                          return InkWell(
                            onTap: () {
                              breakCubit.setBreak(!state);
                            },
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      'Nghỉ trưa:',
                                    ),
                                  ),
                                ),
                                Checkbox(
                                  value: state,
                                  onChanged: (value) {
                                    breakCubit.setBreak(value!);
                                  },
                                  fillColor: MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: DecimalTextField(
                        controller: vaoController,
                        focusNode: vaoFNode,
                        hintText: "Vào",
                        backgroundColor: Colors.black12,
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DecimalTextField(
                        focusNode: veFNode,
                        controller: veController,
                        hintText: "Về",
                        backgroundColor: Colors.black12,
                        onEditingComplete: () {
                          if (_validate()) {
                            _addWorkingDay();
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const SizedBox(width: 5),
                    Expanded(
                      child: CustomButton(
                        onPressed: () {
                          checkAndAddIfFocus('.25');
                        },
                        text: '15p',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomButton(
                        onPressed: () {
                          checkAndAddIfFocus('.5');
                        },
                        text: '30p',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomButton(
                        onPressed: () {
                          checkAndAddIfFocus('.75');
                        },
                        text: '45p',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomButton(
                        onPressed: () {
                          if (ngayController.text.isNotEmpty) {
                            int ngay = int.parse(ngayController.text);
                            ngayController.text = (ngay + 1).toString();
                          }
                        },
                        text: 'Nghỉ',
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(width: 5),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void checkAndAddIfFocus(String value) {
    switch (textFocus) {
      case TextFocus.ra:
        if (veController.text.isNotEmpty) {
          if (veController.text.contains('.')) {
            veController.text =
                veController.text.replaceAll(RegExp(r'\..*'), '');
          }
          veController.text += value;
          //fix cursor move to end
          veController.selection = TextSelection.fromPosition(
            TextPosition(offset: veController.text.length),
          );
        }
        break;
      case TextFocus.vao:
        if (vaoController.text.isNotEmpty) {
          if (vaoController.text.contains('.')) {
            vaoController.text =
                vaoController.text.replaceAll(RegExp(r'\..*'), '');
          }
          vaoController.text += value;
          //fix cursor move to end
          vaoController.selection = TextSelection.fromPosition(
            TextPosition(offset: vaoController.text.length),
          );
        }
        break;
    }
  }

  bool _validate() {
    if (ngayController.text.isEmpty) {
      showToastError('Chưa nhập ngày');
      return false;
    }
    if (vaoController.text.isEmpty) {
      showToastError('Chưa nhập giờ vào');
      return false;
    }
    if (veController.text.isEmpty) {
      showToastError('Chưa nhập giờ về');
      return false;
    }
    return true;
  }

  void _addWorkingDay() {
    int date = int.parse(ngayController.text);
    double timeIn = double.parse(vaoController.text);
    double timeOut = double.parse(veController.text);

    var workingDay = WorkingDay(
      date: date,
      timeIn: timeIn,
      timeOut: timeOut,
      hasBreak: breakCubit.state,
    );

    Hive.box<Worker>(kWorkerBoxName).put(worker.key, worker);

    worker.workingDays.add(workingDay);
    worker.workingDays.sort(
      (a, b) => a.date.compareTo(b.date),
    );

    scrollController.animateTo(
      scrollController.position.pixels + 60,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    vaoController.clear();
    veController.clear();
    ngayController.text = (date + 1).toString();
    vaoFNode.requestFocus();
    breakCubit.setBreak(true);
  }

  void _deleteWorkingDay(int index) {
    worker.workingDays.removeAt(index);
    Hive.box<Worker>(kWorkerBoxName).put(worker.key, worker);
  }

  void _deleteAllWorkingDay() {
    worker.workingDays.clear();
    Hive.box<Worker>(kWorkerBoxName).put(worker.key, worker);
  }
}
