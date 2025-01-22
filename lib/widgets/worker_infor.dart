import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../config/extension/string_extension.dart';
import '../config/theme/theme.dart';
import '../model/worker.dart';
import '../utils/common_func.dart';
import 'custom_button.dart';
import 'dialog.dart';

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
  late final TextEditingController nameController;
  late final TextEditingController basicController;
  late final TextEditingController overtimeController;

  @override
  void initState() {
    super.initState();
    if (widget.worker != null) {
      nameController = TextEditingController(text: widget.worker?.name);

      basicController = TextEditingController(
        text: formatNumber(widget.worker!.basicSalary),
      );

      overtimeController = TextEditingController(
        text: formatNumber(widget.worker!.overtimeSalary),
      );
    } else {
      nameController = TextEditingController();
      basicController = TextEditingController();
      overtimeController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Thông tin',
                  style: AppTheme.title(context),
                ),
                const Spacer(),
                CustomButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: Colors.black12,
                  child: const Center(
                    child: Icon(
                      Icons.close,
                      size: 18,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Tên',
              style: AppTheme.lable(context),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: nameController,
              autofocus: true,
              style: AppTheme.textFieldStyle(context),
              decoration: AppTheme.textFieldDecoration(
                hintText: 'Aa',
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lương ngày',
                        style: AppTheme.lable(context),
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        controller: basicController,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                          signed: kIsWeb ? true : Platform.isIOS,
                        ),
                        style: AppTheme.textFieldStyle(context),
                        decoration: AppTheme.textFieldDecoration(
                          hintText: '0',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lương tăng ca',
                        style: AppTheme.lable(context),
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        controller: overtimeController,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                          signed: kIsWeb ? true : Platform.isIOS,
                        ),
                        style: AppTheme.textFieldStyle(context),
                        decoration: AppTheme.textFieldDecoration(
                          hintText: '0',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                if (widget.worker != null)
                  Expanded(
                    child: CustomButton(
                      text: 'Xóa',
                      onPressed: () {
                        _delete(context);
                      },
                      color: Colors.redAccent,
                    ),
                  ),
                if (widget.worker != null) const SizedBox(width: 8),
                Expanded(
                  child: CustomButton(
                    text: 'Lưu',
                    onPressed: () {
                      _save(context);
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  bool _validate() {
    if (nameController.text.trim().isEmpty) {
      showToastError('Tên không được để trống');
      return false;
    }

    return true;
  }

  Future<void> _save(BuildContext context) async {
    if (_validate()) {
      final boxworker = Hive.box<Worker>('workers');
      var worker = Worker(
        name: nameController.text.trim().toTitleCase(),
        basicSalary: double.tryParse(basicController.text) ?? 0,
        overtimeSalary: double.tryParse(overtimeController.text) ?? 0,
        workingDays: widget.worker?.workingDays ?? [],
      );

      try {
        if (widget.worker != null) {
          await boxworker.put(widget.worker!.key, worker);
        } else {
          await boxworker.add(worker);
        }

        if (context.mounted) {
          Navigator.pop(context);
        }
      } catch (e, s) {
        log(e, stacktrace: s);
        if (context.mounted) {
          showErrorDialog(context, content: e.toString());
        }
      }
    }
  }

  Future<void> _delete(BuildContext context) async {
    FocusScope.of(context).unfocus();
    var confirm = await showDeleteConfirmDialog(
      context,
      content: 'Xóa "${widget.worker?.name}"?',
    );
    if (confirm == true) {
      try {
        await widget.worker!.delete();
        if (context.mounted) {
          Navigator.pop(context);
        }
      } catch (e, s) {
        log(e, stacktrace: s);
        if (context.mounted) {
          showErrorDialog(context, content: e.toString());
        }
      }
    }
  }
}
