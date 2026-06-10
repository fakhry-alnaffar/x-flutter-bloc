import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:x_flutter_bloc/x_flutter_bloc.dart';

class _TestCubit extends Cubit<int> with SingleResultMixin<int, String> {
  _TestCubit() : super(0);
}

void main() {
  late _TestCubit cubit;

  setUp(() => cubit = _TestCubit());
  tearDown(() async => cubit.close());

  group('SingleResultMixin', () {
    test('addSr delivers the value to singleResults', () {
      String? received;
      cubit.singleResults.listen((sr) => received = sr);

      cubit.addSr('hello');

      expect(received, 'hello');
    });

    test('addSr is a no-op after close', () async {
      String? received;
      cubit.singleResults.listen((sr) => received = sr);

      await cubit.close();
      cubit.addSr('after close');

      expect(received, isNull);
    });

    test('multiple SRs are delivered in order', () {
      final received = <String>[];
      cubit.singleResults.listen(received.add);

      cubit.addSr('a');
      cubit.addSr('b');
      cubit.addSr('c');

      expect(received, ['a', 'b', 'c']);
    });

    test('multiple listeners each receive the SR', () {
      String? receivedA;
      String? receivedB;
      cubit.singleResults.listen((sr) => receivedA = sr);
      cubit.singleResults.listen((sr) => receivedB = sr);

      cubit.addSr('broadcast');

      expect(receivedA, 'broadcast');
      expect(receivedB, 'broadcast');
    });

    test('close() closes the SR stream and the bloc', () async {
      bool srDone = false;
      cubit.singleResults.listen(null, onDone: () => srDone = true);

      await cubit.close();
      await Future.microtask(() {});

      expect(srDone, isTrue);
      expect(cubit.isClosed, isTrue);
    });
  });
}
