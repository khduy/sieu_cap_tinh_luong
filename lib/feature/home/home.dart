import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cubit/worker_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Siêu cấp tính lương'),
      ),
      body: BlocBuilder<WorkerCubit, WorkerState>(
        bloc: context.read<WorkerCubit>(),
        builder: (context, state) {
          if (state is WorkerLoadSuccess) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              padding: const EdgeInsets.all(30),
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: state.workers.length + 1,
              itemBuilder: (context, index) {
                if (index == state.workers.length) {
                  return _GridItems(
                    child: const Icon(
                      Icons.add_rounded,
                      size: 40,
                    ),
                    onTap: () {},
                  );
                }
                final worker = state.workers[index];
                return _GridItems(
                  child: Text(
                    worker.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xffF3F3F3),
                    ),
                  ),
                  onTap: () {},
                  onLongPress: () {},
                );
              },
            );
          }
          if (state is WorkerLoadFailure) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red.shade400,
                  size: 72,
                ),
                const SizedBox(height: 10),
                Text(
                  'Lỗi rồi!',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  state.message,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red.shade400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class _GridItems extends StatelessWidget {
  const _GridItems({
    Key? key,
    required this.child,
    required this.onTap,
    this.onLongPress,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: const Color(0xff313133),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.05),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}
