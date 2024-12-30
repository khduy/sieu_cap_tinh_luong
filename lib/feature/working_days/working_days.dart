import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../utils/common_func.dart';
import '../../model/working_day.dart';
import '../../widgets/image_picker_button.dart';
import '../result/result_page.dart';
import '../../widgets/dismissible_tile.dart';
import 'cubit/break_cubit.dart';
import '../../config/constant/constant.dart';
import '../../model/worker.dart';
import '../../widgets/custom_button.dart';

import '../../widgets/decimal_text_field.dart';
import '../../widgets/dialog.dart';

enum TextFocus {
  vao,
  ra,
}

class WorkingDaysPage extends StatefulWidget {
  const WorkingDaysPage({Key? key, required this.worker}) : super(key: key);
  final Worker worker;

  @override
  State<WorkingDaysPage> createState() => _WorkingDaysPageState();
}

class _WorkingDaysPageState extends State<WorkingDaysPage> {
  final vaoController = TextEditingController();

  final veController = TextEditingController();

  final ngayController = TextEditingController();

  final scrollController = ScrollController();

  final vaoFNode = FocusNode();

  final veFNode = FocusNode();

  final breakCubit = BreakCubit();

  bool needScroll = false;

  TextFocus textFocus = TextFocus.vao;

  @override
  void initState() {
    super.initState();
    vaoFNode.addListener(() {
      if (vaoFNode.hasFocus) textFocus = TextFocus.vao;
    });

    veFNode.addListener(() {
      if (veFNode.hasFocus) textFocus = TextFocus.ra;
    });
  }

  @override
  void dispose() {
    super.dispose();
    vaoFNode.dispose();
    veFNode.dispose();
    vaoController.dispose();
    veController.dispose();
    ngayController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => hideKeyboard(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.worker.name),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
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
                child: const Icon(
                  Icons.delete_rounded,
                  color: Colors.white,
                ),
              ),
            ),
            ImagePickerButton(
              onImageSelected: (file) async {
                showLoading();
                var result = await analyzeImageWithGemini(file);
                hideLoading();
      
                if (result != null) {
                  widget.worker.workingDays.addAll(result);
                  await Hive.box<Worker>(kWorkerBoxName).put(widget.worker.key, widget.worker);
                  needScroll = true;
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                color: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultPage(worker: widget.worker),
                    ),
                  );
                },
                child: const Icon(
                  Icons.view_stream,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ValueListenableBuilder<Box<Worker>>(
                  valueListenable: Hive.box<Worker>(kWorkerBoxName).listenable(
                    keys: [widget.worker.key],
                  ),
                  builder: (context, workers, _) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      if (needScroll) {
                        scrollController.animateTo(
                          scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                        needScroll = false;
                      }
                    });
                    return ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      controller: scrollController,
                      itemCount: workers.get(widget.worker.key)?.workingDays.length ?? 0,
                      itemBuilder: (context, index) {
                        return DismissibleTile(
                          key: UniqueKey(),
                          workingDay: widget.worker.workingDays[index],
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
              Builder(builder: (context) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.black12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: ngayController,
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                                signed: Platform.isIOS,
                              ),
                              autofocus: true,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide.none,
                                ),
                                fillColor: Colors.black12,
                                filled: true,
                                label: const Text('Ngày'),
                              ),
                              onEditingComplete: () {
                                FocusScope.of(context).requestFocus(vaoFNode);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
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
                                          padding: EdgeInsets.symmetric(horizontal: 8),
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
                                        fillColor: WidgetStateProperty.all(
                                          Theme.of(context).colorScheme.primary,
                                        ),
                                        checkColor: Theme.of(context).colorScheme.onPrimary,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: DecimalTextField(
                              controller: vaoController,
                              focusNode: vaoFNode,
                              hintText: "Vào",
                              hintAsLabel: true,
                              backgroundColor: Colors.black12,
                              onEditingComplete: () {
                                FocusScope.of(context).nextFocus();
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DecimalTextField(
                              focusNode: veFNode,
                              controller: veController,
                              hintText: "Về",
                              hintAsLabel: true,
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
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              onPressed: () => checkAndAddIfFocus('.25'),
                              text: '15p',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: CustomButton(
                              onPressed: () => checkAndAddIfFocus('.5'),
                              text: '30p',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: CustomButton(
                              onPressed: () => checkAndAddIfFocus('.75'),
                              text: '45p',
                            ),
                          ),
                          const SizedBox(width: 8),
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
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void checkAndAddIfFocus(String value) {
    switch (textFocus) {
      case TextFocus.ra:
        if (veController.text.isNotEmpty) {
          if (veController.text.contains('.')) {
            veController.text = veController.text.replaceAll(RegExp(r'\..*'), '');
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
            vaoController.text = vaoController.text.replaceAll(RegExp(r'\..*'), '');
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

  void _addWorkingDay() async {
    int date = int.parse(ngayController.text);
    double timeIn = double.parse(vaoController.text);
    double timeOut = double.parse(veController.text);

    var workingDay = WorkingDay(
      date: date,
      timeIn: timeIn,
      timeOut: timeOut,
      hasBreak: breakCubit.state,
    );

    widget.worker.workingDays.add(workingDay);
    widget.worker.workingDays.sort(
      (a, b) => a.date.compareTo(b.date),
    );

    await Hive.box<Worker>(kWorkerBoxName).put(widget.worker.key, widget.worker);

    needScroll = true;

    vaoController.clear();
    veController.clear();
    ngayController.text = (date + 1).toString();
    vaoFNode.requestFocus();
    breakCubit.setBreak(true);
  }

  void _deleteWorkingDay(int index) {
    widget.worker.workingDays.removeAt(index);
    Hive.box<Worker>(kWorkerBoxName).put(widget.worker.key, widget.worker);
  }

  void _deleteAllWorkingDay() {
    widget.worker.workingDays.clear();
    Hive.box<Worker>(kWorkerBoxName).put(widget.worker.key, widget.worker);
  }
}
