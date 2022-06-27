import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../config/constant/constant.dart';
import '../../data/model/worker.dart';

import '../../widgets/grid_item.dart';
import '../../widgets/dialog.dart';
import '../working_days/working_days.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  bool _isDarkmode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tính lương',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isDarkmode(context) ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            splashRadius: 22,
            splashColor: Colors.transparent,
            onPressed: () {
              Hive.box<bool>(kDarkModeBoxName).put(
                kDarkModeKey,
                !_isDarkmode(context),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showWorkerInfor(context);
        },
      ),
      body: ValueListenableBuilder<Box<Worker>>(
        valueListenable: Hive.box<Worker>(kWorkerBoxName).listenable(),
        builder: (context, workers, _) {
          return _GridWorkers(
            workers: workers.values.toList(),
          );
        },
      ),
    );
  }
}

class _GridWorkers extends StatelessWidget {
  const _GridWorkers({
    Key? key,
    required this.workers,
  }) : super(key: key);

  final List<Worker> workers;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.all(16),
      itemCount: workers.length,
      itemBuilder: (context, index) {
        final worker = workers[index];
        return GridItem(
          child: Text(
            worker.name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => WorkingDaysPage(worker: worker)),
            );
          },
          onLongPress: () {
            showWorkerInfor(context, worker: worker);
          },
        );
      },
    );
  }
}
