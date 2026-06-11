import 'package:flutter_test/flutter_test.dart';
import 'package:x_flutter_bloc/x_flutter_bloc.dart';

class _Sut with FailureStreamMixin {
  void dispose() => closeFailureStream();
}

void main() {
  late _Sut sut;

  setUp(() => sut = _Sut());
  tearDown(() => sut.dispose());

  group('FailureStreamMixin', () {
    test('emitFailure delivers the failure to failureStream', () {
      Failure? received;
      sut.failureStream.listen((f) => received = f);

      const failure = ConnectionFailure();
      sut.emitFailure(failure);

      expect(received, failure);
    });

    test('emitFailure is a no-op after closeFailureStream', () {
      Failure? received;
      sut.failureStream.listen((f) => received = f);

      sut.dispose();
      sut.emitFailure(const ConnectionFailure());

      expect(received, isNull);
    });

    test('multiple failures are delivered in order', () {
      final received = <Failure>[];
      sut.failureStream.listen(received.add);

      const f1 = ConnectionFailure();
      const f2 = ApiUnauthorizedFailure();
      sut.emitFailure(f1);
      sut.emitFailure(f2);

      expect(received, [f1, f2]);
    });

    test('multiple listeners each receive the emitted failure', () {
      Failure? receivedA;
      Failure? receivedB;
      sut.failureStream.listen((f) => receivedA = f);
      sut.failureStream.listen((f) => receivedB = f);

      const failure = ConnectionFailure();
      sut.emitFailure(failure);

      expect(receivedA, failure);
      expect(receivedB, failure);
    });
  });
}
