import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/worker.dart';

import '../../dark_mode_cubit.dart';
import '../../widgets/grid_item.dart';
import '../../widgets/dialog.dart';
import '../detail/detail_view.dart';
import 'cubit/worker_cubit.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final cubit = HomeCubit()..getWorkers();

  bool _isDarkmode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Siêu cấp tính lương',
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
            onPressed: context.read<DarkModeCubit>().toggle,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          var haveChanged = await showWorkerInfor(context);

          if (haveChanged == true) {
            cubit.getWorkers();
          }
        },
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        bloc: cubit,
        builder: (context, state) {
          if (state is HomeLoadSuccess) {
            return BlocProvider(
              create: (context) => cubit,
              child: _GridWorkers(workers: state.workers),
            );
          }

          if (state is HomeLoadFailure) {
            return _ErrorView(message: state.message);
          }

          return Container();
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    Key? key,
    required this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.error_outline,
          color: Colors.red.shade400,
          size: 72,
        ),
        const SizedBox(height: 10),
        Text(
          'Bị lỗi rồi!',
          style: TextStyle(
            fontSize: 20,
            color: Colors.red.shade400,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 30),
        Text(
          message,
          style: TextStyle(
            fontSize: 20,
            color: Colors.red.shade400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
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
      physics:
          const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      padding: const EdgeInsets.all(16),
      itemCount: workers.length,
      itemBuilder: (context, index) {
        final worker = workers[index];
        return GridItem(
          child: Text(
            worker.name,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DetailView(worker: worker)),
            );
          },
          onLongPress: () async {
            var haveChanged = await showWorkerInfor(context, worker: worker);
            if (haveChanged == true) {
              context.read<HomeCubit>().getWorkers();
            }
          },
        );
      },
    );
  }
}
