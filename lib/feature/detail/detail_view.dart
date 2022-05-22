import 'package:flutter/material.dart';
import 'package:sieu_cap_tinh_luong/data/model/worker.dart';
import 'package:sieu_cap_tinh_luong/widgets/custom_button.dart';

import '../../widgets/dialog.dart';

class DetailView extends StatelessWidget {
  const DetailView({Key? key, required this.worker}) : super(key: key);
  final Worker worker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(worker.name),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                  child: const Icon(
                    Icons.delete_rounded,
                    color: Colors.white,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                  color: Colors.redAccent,
                  onPressed: () async {
                    var deleteAll = await showDeleteConfirmDialog(
                      context,
                      content: 'Xóa tất cả?',
                    );
                    if (deleteAll == true) {}
                  },
                ),
                const SizedBox(width: 8),
                CustomButton(
                  child: const Icon(
                    Icons.view_stream,
                    color: Colors.white,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                  color: Colors.green,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
