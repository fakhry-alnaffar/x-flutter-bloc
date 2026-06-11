import 'package:flutter_test/flutter_test.dart';
import 'package:x_flutter_bloc/x_flutter_bloc.dart';

class _Sut with ProgressStreamMixin {
  void dispose() => closeProgressStream();
}

void main() {
  late _Sut sut;

  setUp(() => sut = _Sut());
  tearDown(() => sut.dispose());

  group('ProgressStreamMixin', () {
    test('startProgress emits show=true on the first call', () {
      final events = <bool>[];
      sut.progressStream.listen((p) {
        if (p is DefaultProgressState) events.add(p.showProgress);
      });

      sut.startProgress();

      expect(events, [true]);
    });

    test('startProgress does not re-emit show when already active', () {
      final events = <bool>[];
      sut.progressStream.listen((p) {
        if (p is DefaultProgressState) events.add(p.showProgress);
      });

      sut.startProgress();
      sut.startProgress();

      expect(events, [true]);
    });

    test('stopProgress emits hide=false when counter reaches zero', () async {
      final events = <bool>[];
      sut.progressStream.listen((p) {
        if (p is DefaultProgressState) events.add(p.showProgress);
      });

      sut.startProgress();
      await sut.stopProgress();

      expect(events, [true, false]);
    });

    test('stopProgress does not hide until all started operations have stopped',
        () async {
      final events = <bool>[];
      sut.progressStream.listen((p) {
        if (p is DefaultProgressState) events.add(p.showProgress);
      });

      sut.startProgress();
      sut.startProgress();
      await sut.stopProgress();

      expect(events, [true], reason: 'hide must not fire while counter > 0');

      await sut.stopProgress();

      expect(events, [true, false]);
    });

    test('extra stopProgress calls when counter is already 0 are no-ops',
        () async {
      final events = <bool>[];
      sut.progressStream.listen((p) {
        if (p is DefaultProgressState) events.add(p.showProgress);
      });

      await sut.stopProgress();

      expect(events, isEmpty);
    });

    test('startProgress with custom state emits that state', () {
      final events = <BaseProgressState>[];
      sut.progressStream.listen(events.add);

      const custom = DefaultProgressState(showProgress: true);
      sut.startProgress(state: custom);

      expect(events, [custom]);
    });

    test('startProgress is a no-op after closeProgressStream', () {
      final events = <bool>[];
      sut.progressStream.listen((p) {
        if (p is DefaultProgressState) events.add(p.showProgress);
      });

      sut.dispose();
      sut.startProgress();

      expect(events, isEmpty);
    });

    test(
        'new startProgress during anti-flicker delay prevents the hide from firing',
        () async {
      final events = <bool>[];
      sut.progressStream.listen((p) {
        if (p is DefaultProgressState) events.add(p.showProgress);
      });

      sut.startProgress();
      // Trigger the 50 ms delay but start again before it elapses
      final stopFuture = sut.stopProgress();
      sut.startProgress();
      await stopFuture;

      // Hide should NOT have been emitted because the counter was > 0 after
      // the delay elapsed.
      expect(events, [true, true], reason: 'only shows, no hide');
    });
  });
}
