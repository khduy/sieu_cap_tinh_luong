import 'package:flutter/material.dart';
import 'cancel_button.dart';
import 'custom_button.dart';

import '../data/model/worker.dart';
import 'worker_infor.dart';

Future<bool?> showDeleteConfirmDialog(
  BuildContext context, {
  String? title,
  String? content,
}) async {
  final result = await showDialog<bool?>(
    context: context,
    builder: (context) => AlertDialog(
      scrollable: true,
      title: Text(title ?? 'Xác nhận'),
      content: Text(
        content ?? 'Xác nhận xóa?',
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CancelButton(
              onPressed: () => Navigator.pop(context, false),
              text: 'Không',
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomButton(
                onPressed: () => Navigator.pop(context, true),
                text: 'Xóa',
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ],
      actionsPadding: const EdgeInsets.symmetric(horizontal: 12),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    ),
  );
  return result;
}

Future<void> showErrorDialog(
  BuildContext context, {
  String? title,
  String? content,
}) async {
  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      scrollable: true,
      title: Text(title ?? 'Lỗi'),
      content: Text(
        content ?? 'Có lỗi xảy ra, vui lòng thử lại sau',
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      ),
      actions: [
        CustomButton(
          onPressed: () => Navigator.pop(context),
          text: 'Đóng',
        ),
      ],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    ),
  );
}

void showWorkerInfor(BuildContext context, {Worker? worker}) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      insetPadding: const EdgeInsets.all(24),
      child: WorkerInfor(
        worker: worker,
      ),
    ),
  );
}
