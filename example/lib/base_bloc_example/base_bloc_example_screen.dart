import 'package:example/base_bloc_example/bloc/base_bloc_example_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:x_flutter_bloc/x_flutter_bloc.dart';
import 'package:x_flutter_core_models/x_flutter_core_models.dart';

class BaseBlocExampleScreen extends BaseStatelessScreen<
    BaseBlocExampleScreenState,
    BaseBlocExampleScreenBloc,
    BaseBlocExampleScreenSR> {
  final String title;

  const BaseBlocExampleScreen({
    required this.title,
    super.key,
  });

  @override
  BaseBlocExampleScreenBloc createBloc(BuildContext context) =>
      GetIt.I.get<BaseBlocExampleScreenBloc>();

  @override
  Widget buildScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title, style: TextStyle(fontSize: 18.sp)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
              style: TextStyle(fontSize: 14.sp),
            ),
            20.verticalSpace,
            // Atomic Rebuild: Using BlocSelector
            BlocSelector<BaseBlocExampleScreenBloc, BaseBlocExampleScreenState,
                int>(
              selector: (state) => switch (state) {
                BaseBlocExampleScreenData(:final counter) => counter,
                _ => 0,
              },
              builder: (context, counter) {
                return Text(
                  '$counter',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontSize: 32.sp, fontWeight: FontWeight.bold),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 16.h, right: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () =>
                  blocOf(context).add(BaseBlocExampleScreenEventOnIncrement()),
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
            16.horizontalSpace,
            FloatingActionButton(
              onPressed: () => blocOf(context)
                  .addSr(BaseBlocExampleScreenSRShowDialog('Hello from SR')),
              tooltip: 'Show dialog',
              child: const Icon(Icons.message),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onSR(BuildContext context, BaseBlocExampleScreenSR sr) {
    if (sr is BaseBlocExampleScreenSRShowDialog) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: Text('Bloc dialog', style: TextStyle(fontSize: 18.sp)),
          content: Text(sr.message, style: TextStyle(fontSize: 14.sp)),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void onFailure(BuildContext context, Failure failure) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: ${failure.toString()}'),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
