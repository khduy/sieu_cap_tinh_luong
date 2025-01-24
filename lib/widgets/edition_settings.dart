import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../config/constant/constant.dart';
import '../main.dart';

class EditionSettings extends StatelessWidget {
  const EditionSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<String>>(
      valueListenable: Hive.box<String>(kEditionBoxName).listenable(),
      builder: (context, box, _) {
        final currentEdition = box.get(kEditionKey)?.toEdition() ?? Edition.di4;
        return PopupMenuButton<Edition>(
          icon: const Icon(Icons.settings),
          initialValue: currentEdition,
          tooltip: 'Chọn phiên bản',
          onSelected: (Edition edition) {
            box.put(kEditionKey, edition.toStorageString());
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<Edition>>[
            const PopupMenuItem<Edition>(
              value: Edition.mama,
              child: Text('Phiên bản Mama'),
            ),
            const PopupMenuItem<Edition>(
              value: Edition.di4,
              child: Text('Phiên bản Di 4'),
            ),
          ],
        );
      },
    );
  }
}
