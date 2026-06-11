import 'package:flutter_test/flutter_test.dart';
import 'package:x_flutter_bloc/x_flutter_bloc.dart';
import 'package:x_flutter_core/x_flutter_core.dart';

class _Sut with ProgressStreamMixin, FailureStreamMixin, OperationOrchestrator {
  void dispose() {
    closeProgressStream();
    closeFailureStream();
  }
}

void main() {
  late _Sut sut;

  setUp(() => sut = _Sut());
  tearDown(() => sut.dispose());

  group('OperationOrchestrator.performOperation', () {
    group('success path', () {
      test('calls onSuccess with the unwrapped data', () async {
        int? received;

        await sut.performOperation<int>(
          operation: () async => DataResponse.success(42),
          onSuccess: (data) => received = data,
        );

        expect(received, 42);
      });

      test('emits show then hide on the progress stream', () async {
        final events = <bool>[];
        sut.progressStream.listen((p) {
          if (p is DefaultProgressState) events.add(p.showProgress);
        });

        await sut.performOperation<int>(
          operation: () async => DataResponse.success(1),
          onSuccess: (_) {},
        );

        expect(events, [true, false]);
      });

      test('returns the original DataResponseSuccess', () async {
        final result = await sut.performOperation<int>(
          operation: () async => DataResponse.success(99),
          onSuccess: (_) {},
        );

        expect(result, isA<DataResponseSuccess<int>>());
      });
    });

    group('failure path', () {
      test('NoInternetConnection emits a ConnectionFailure to failureStream',
          () async {
        Failure? received;
        sut.failureStream.listen((f) => received = f);

        await sut.performOperation<int>(
          operation: () async => NoInternetConnection<int>(),
          onSuccess: (_) => fail('onSuccess must not be called'),
        );

        expect(received, isA<ConnectionFailure>());
      });

      test('Unauthorized emits ApiUnauthorizedFailure', () async {
        Failure? received;
        sut.failureStream.listen((f) => received = f);

        await sut.performOperation<int>(
          operation: () async => Unauthorized<int>(),
          onSuccess: (_) => fail('onSuccess must not be called'),
        );

        expect(received, isA<ApiUnauthorizedFailure>());
      });

      test('custom onError receives the failure instead of the failure stream',
          () async {
        Failure? streamFailure;
        Failure? customFailure;
        sut.failureStream.listen((f) => streamFailure = f);

        await sut.performOperation<int>(
          operation: () async => NoInternetConnection<int>(),
          onSuccess: (_) {},
          onError: (f) => customFailure = f,
        );

        expect(streamFailure, isNull,
            reason: 'stream must not receive failure when onError is provided');
        expect(customFailure, isA<ConnectionFailure>());
      });

      test('failure path still shows and hides progress', () async {
        final events = <bool>[];
        sut.progressStream.listen((p) {
          if (p is DefaultProgressState) events.add(p.showProgress);
        });

        await sut.performOperation<int>(
          operation: () async => NoInternetConnection<int>(),
          onSuccess: (_) {},
        );

        expect(events, [true, false]);
      });
    });

    group('CanceledRequest', () {
      test('does not call onSuccess and does not emit a failure', () async {
        bool successCalled = false;
        Failure? receivedFailure;
        sut.failureStream.listen((f) => receivedFailure = f);

        await sut.performOperation<int>(
          operation: () async => CanceledRequest<int>(),
          onSuccess: (_) => successCalled = true,
        );

        expect(successCalled, isFalse);
        expect(receivedFailure, isNull);
      });
    });

    group('enableProgress: false', () {
      test('skips progress overlay entirely', () async {
        final events = <bool>[];
        sut.progressStream.listen((p) {
          if (p is DefaultProgressState) events.add(p.showProgress);
        });

        await sut.performOperation<int>(
          operation: () async => DataResponse.success(1),
          onSuccess: (_) {},
          enableProgress: false,
        );

        expect(events, isEmpty);
      });
    });

    group('exception in onSuccess', () {
      test('propagates the exception to the caller', () async {
        await expectLater(
          sut.performOperation<int>(
            operation: () async => DataResponse.success(1),
            onSuccess: (_) => throw StateError('onSuccess threw'),
          ),
          throwsA(isA<StateError>()),
        );
      });

      test('still stops the progress overlay despite the exception', () async {
        final events = <bool>[];
        sut.progressStream.listen((p) {
          if (p is DefaultProgressState) events.add(p.showProgress);
        });

        try {
          await sut.performOperation<int>(
            operation: () async => DataResponse.success(1),
            onSuccess: (_) => throw StateError('onSuccess threw'),
          );
        } catch (_) {}

        expect(events, containsAllInOrder([true, false]));
      });
    });
  });
}
