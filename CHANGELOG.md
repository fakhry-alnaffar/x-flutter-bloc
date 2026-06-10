## 1.0.1

* **Fix:** Resolved ambiguous import errors for `DataResponse` and `DataResponseSuccess` in `OperationOrchestrator`.
* **Refactor:** Optimized library exports and imports to prevent conflicts between `x_flutter_core` and `x_flutter_core_models`.
* Improved compatibility with the latest `x_flutter_core` updates.

## 1.0.0

* **Initial Production Release**
* Introduced `IBaseBloc` interface for strict protocol-oriented state management.
* Added `BaseStatelessScreen` for high-performance, atomic rebuild UI patterns.
* Enhanced `OperationOrchestrator` with `performSafeOperation` for seamless `DataResponse` handling.
* Implemented reference-counted progress management with 50ms anti-flicker delay.
* Full integration with `flutter_screenutil` for pixel-perfect responsive design.
* Enforced `Equatable` in base state templates for ruthless rebuild reduction.

## 0.0.4

* Fixed issue when screen closed but progress visible

## 0.0.3

* Updated core models

## 0.0.2

* Added AppBlocObserver

## 0.0.1

* Initial release
