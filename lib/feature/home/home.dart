import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sieu_cap_tinh_luong/data/model/worker.dart';
import 'package:sieu_cap_tinh_luong/feature/worker_infor/worker_infor.dart';

import '../../bloc/cubit/worker_cubit.dart';
import '../../widgets/custom_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Siêu cấp tính lương',
                  style: TextStyle(
                    fontFamily: 'Signika',
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            BlocBuilder<WorkerCubit, WorkerState>(
              bloc: context.read<WorkerCubit>(),
              builder: (context, state) {
                if (state is WorkerLoadSuccess) {
                  return _GridWorkers(workers: state.workers);
                }

                if (state is WorkerLoadFailure) {
                  return _ErrorView(message: state.message);
                }

                return const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ],
        ),
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
    return SliverList(
      delegate: SliverChildListDelegate([
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
      ]),
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
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.5,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            if (index == workers.length) {
              return CustomButton(
                child: const Icon(
                  Icons.add_rounded,
                  size: 40,
                  color: Colors.white70,
                ),
                onTap: () async {
                  var haveChanged = await showWorkerInfor(context);

                  if (haveChanged ?? false) {
                    context.read<WorkerCubit>().getWorkers();
                  }
                },
              );
            }
            final worker = workers[index];
            return CustomButton(
              child: Text(
                worker.name,
                style: const TextStyle(
                  fontFamily: 'Signika',
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              color: Colors.primaries[index % Colors.primaries.length],
              onTap: () {},
              onLongPress: () async {
                var haveChanged = await showWorkerInfor(context, worker: worker);
                if (haveChanged ?? false) {
                  context.read<WorkerCubit>().getWorkers();
                }
              },
            );
          },
          childCount: workers.length + 1,
        ),
      ),
    );
  }
}
