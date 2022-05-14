import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:sieu_cap_tinh_luong/config/extension/string_extension.dart';
import 'package:sieu_cap_tinh_luong/data/model/worker.dart';

import '../../config/theme/theme.dart';

class WorkerInfor extends StatefulWidget {
  final Worker? worker;

  const WorkerInfor({
    Key? key,
    this.worker,
  }) : super(key: key);

  @override
  State<WorkerInfor> createState() => _WorkerInforState();
}

class _WorkerInforState extends State<WorkerInfor> {
  final _formKey = GlobalKey<FormState>();
  final numberFormat = NumberFormat("##.##");

  late final TextEditingController nameController;
  late final TextEditingController basicController;
  late final TextEditingController overtimeController;

  @override
  void initState() {
    super.initState();
    if (widget.worker != null) {
      nameController = TextEditingController(text: widget.worker?.name);

      basicController = TextEditingController(
        text: numberFormat.format(widget.worker?.basicSalary),
      );

      overtimeController = TextEditingController(
        text: numberFormat.format(widget.worker?.overtimeSalary),
      );
    } else {
      nameController = TextEditingController();
      basicController = TextEditingController();
      overtimeController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                autofocus: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: AppTheme.textFieldDecoration.copyWith(
                  labelText: 'Tên',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Chưa nhập tên kìa';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: basicController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: AppTheme.textFieldDecoration.copyWith(
                  labelText: 'Lương ngày',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: overtimeController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: AppTheme.textFieldDecoration.copyWith(
                  labelText: 'Lương tăng ca',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (widget.worker != null)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await widget.worker!.delete();
                          Navigator.pop(context, true);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
                        ),
                        child: const Text('Xóa', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  if (widget.worker != null) const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          final boxworker = Hive.box<Worker>('workers');
                          var worker = Worker(
                            name: nameController.text.trim().toTitleCase(),
                            basicSalary: double.tryParse(basicController.text) ?? 0,
                            overtimeSalary: double.tryParse(overtimeController.text) ?? 0,
                            workingDays: widget.worker?.workingDays ?? [],
                          );

                          if (widget.worker != null) {
                            await boxworker.put(widget.worker!.key, worker);
                          } else {
                            await boxworker.add(worker);
                          }

                          Navigator.pop(context, true);
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff5985FF)),
                      ),
                      child: const Text('Lưu', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool?> showWorkerInfor(BuildContext context, {Worker? worker, int? index}) async {
  final result = await showDialog<bool?>(
    context: context,
    builder: (context) => AlertDialog(
      scrollable: true,
      title: const Text('Thông tin'),
      contentPadding: EdgeInsets.zero,
      backgroundColor: const Color(0xff202121),
      content: WorkerInfor(
        worker: worker,
      ),
    ),
  );
  return result;
}
