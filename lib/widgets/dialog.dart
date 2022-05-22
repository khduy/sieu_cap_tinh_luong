import 'package:flutter/material.dart';
import 'package:sieu_cap_tinh_luong/widgets/custom_button.dart';

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
      content: Text(content ?? 'Xác nhận xóa?'),
      actions: [
        Row(
          children: [
            const SizedBox(width: 10),
            Expanded(
              child: CustomButton(
                onPressed: () => Navigator.pop(context, false),
                text: 'Không',
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CustomButton(
                onPressed: () => Navigator.pop(context, true),
                text: 'Xóa',
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ],
      actionsPadding: const EdgeInsets.only(bottom: 8),
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
      content: Text(content ?? 'Có lỗi xảy ra, vui lòng thử lại sau'),
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

Future<bool?> showWorkerInfor(BuildContext context, {Worker? worker}) async {
  final result = await showDialog<bool?>(
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
  return result;
}
