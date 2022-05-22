import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:sieu_cap_tinh_luong/widgets/cancel_button.dart';
import 'package:sieu_cap_tinh_luong/widgets/custom_button.dart';
import '../config/extension/string_extension.dart';
import '../data/model/worker.dart';

import '../config/theme/theme.dart';
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
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Thông tin',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  if (widget.worker != null)
                    CustomButton(
                      child: const Center(
                        child: Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                        ),
                      ),
                      onPressed: () async {
                        await _delete(context);
                      },
                      color: Colors.black12,
                    )
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Tên',
                style: AppTheme.textFieldLabelStyle(context),
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: nameController,
                autofocus: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                style: AppTheme.textFieldTextStyle,
                decoration: AppTheme.textFieldDecoration.copyWith(
                  hintText: 'Aa',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Chưa nhập tên kìa';
                  }
                  return null;
                },
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
                          style: AppTheme.textFieldLabelStyle(context),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: basicController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: AppTheme.textFieldTextStyle,
                          decoration: AppTheme.textFieldDecoration.copyWith(
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
                          style: AppTheme.textFieldLabelStyle(context),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: overtimeController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: AppTheme.textFieldTextStyle,
                          decoration: AppTheme.textFieldDecoration.copyWith(
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
                  CancelButton(
                    text: 'Đóng',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomButton(
                      text: 'Lưu',
                      onPressed: () async {
                        await _save(context);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
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

        Navigator.pop(context, true);
      } catch (e) {
        showErrorDialog(context, content: e.toString());
      }
    }
  }

  Future<void> _delete(BuildContext context) async {
    FocusScope.of(context).unfocus();
    var confirm = await showDeleteConfirmDialog(
      context,
      content: 'Xóa "${widget.worker?.name}"?',
    );
    if (confirm ?? false) {
      try {
        await widget.worker!.delete();
        Navigator.pop(context, true);
      } catch (e) {
        showErrorDialog(context, content: e.toString());
      }
    }
  }
}
