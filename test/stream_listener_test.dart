import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:x_flutter_bloc/x_flutter_bloc.dart';

void main() {
  group('StreamListener', () {
    testWidgets('delivers every stream event to onData', (tester) async {
      final controller = StreamController<int>.broadcast();
      final received = <int>[];

      await tester.pumpWidget(
        StreamListener<int>(
          stream: controller.stream,
          onData: received.add,
          child: const SizedBox(),
        ),
      );

      controller.add(1);
      controller.add(2);
      controller.add(3);
      await tester.pump();

      expect(received, [1, 2, 3]);
      await controller.close();
    });

    testWidgets('cancels subscription when the widget is disposed',
        (tester) async {
      final controller = StreamController<int>.broadcast();
      final received = <int>[];

      await tester.pumpWidget(
        StreamListener<int>(
          stream: controller.stream,
          onData: received.add,
          child: const SizedBox(),
        ),
      );

      controller.add(1);
      await tester.pump();

      await tester.pumpWidget(const SizedBox()); // triggers dispose

      controller.add(2); // must not arrive after dispose
      await tester.pump();

      expect(received, [1]);
      await controller.close();
    });

    testWidgets('re-subscribes to the new stream when the stream reference changes',
        (tester) async {
      final controller1 = StreamController<int>.broadcast();
      final controller2 = StreamController<int>.broadcast();
      final received = <int>[];

      await tester.pumpWidget(
        StreamListener<int>(
          stream: controller1.stream,
          onData: received.add,
          child: const SizedBox(),
        ),
      );

      controller1.add(1);
      await tester.pump();

      await tester.pumpWidget(
        StreamListener<int>(
          stream: controller2.stream,
          onData: received.add,
          child: const SizedBox(),
        ),
      );

      controller1.add(99); // old stream — must be ignored after re-subscribe
      controller2.add(2);
      await tester.pump();

      expect(received, [1, 2]);
      await controller1.close();
      await controller2.close();
    });

    testWidgets('does not create a duplicate subscription when stream is unchanged',
        (tester) async {
      final controller = StreamController<int>.broadcast();
      final received = <int>[];

      await tester.pumpWidget(
        StreamListener<int>(
          stream: controller.stream,
          onData: received.add,
          child: const SizedBox(),
        ),
      );

      // Rebuild with an identical stream reference
      await tester.pumpWidget(
        StreamListener<int>(
          stream: controller.stream,
          onData: received.add,
          child: const SizedBox(),
        ),
      );

      controller.add(1);
      await tester.pump();

      expect(received, [1],
          reason: 'event must arrive exactly once, not duplicated');
      await controller.close();
    });

    testWidgets('invokes onDone when the stream is closed', (tester) async {
      final controller = StreamController<int>.broadcast();
      bool doneCalled = false;

      await tester.pumpWidget(
        StreamListener<int>(
          stream: controller.stream,
          onData: (_) {},
          onDone: () => doneCalled = true,
          child: const SizedBox(),
        ),
      );

      await controller.close();
      await tester.pump();

      expect(doneCalled, isTrue);
    });
  });
}
