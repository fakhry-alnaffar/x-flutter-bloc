# Onix Flutter BLoC

A production-grade state management layer built on top of `flutter_bloc`. Designed for scalability, clean architecture, and seamless integration with the Onix ecosystem.

## 🚀 Key Features

*   **Modern Bloc & Cubit**: Fully modernized for Dart 3.12+ and Flutter 3.44+.
*   **Single Results (SR)**: Handle one-time events (Navigation, Toasts, Dialogs) without polluting the state.
*   **Integrated Loading & Errors**: Built-in support for progress overlays and failure streams.
*   **DataResponse Integration**: Automatic handling of `onix_flutter_core` sealed `DataResponse` model.
*   **Memory Safe**: Declarative stream listening to prevent leaks.
*   **Senior-Level Architecture**: Minimal boilerplate, high maintainability.

## 📦 Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  onix_flutter_bloc:
    git:
      url: https://github.com/OnixFlutterTeam/onix-flutter-bloc.git
      ref: main
```

## 🛠 Usage

### 1. Create your BLoC

Extend `BaseBloc` (or `BaseCubit`) and define your Event, State, and Single Result (SR) types.

```dart
class MyBloc extends BaseBloc<MyEvent, MyState, MySR> {
  MyBloc() : super(const MyState.initial());

  Future<void> _onFetch(FetchEvent event, Emitter<MyState> emit) async {
    await performOperation(
      operation: () => _repository.getData(),
      onSuccess: (data) => emit(MyState.success(data)),
      // enableProgress: true, // Default
    );
  }
}
```

### 2. Build your Screen

Extend `BaseState` (or `BaseCubitState`) to handle the lifecycle and UI streams automatically.

```dart
class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends BaseState<MyState, MyBloc, MySR, MyScreen> {
  @override
  MyBloc createBloc() => MyBloc();

  @override
  void onSR(BuildContext context, MySR sr) {
    // Handle one-time events here (e.g. navigation)
  }

  @override
  void onFailure(BuildContext context, Failure failure) {
    // Handle errors globally for this screen
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modern Bloc')),
      body: blocBuilder(
        builder: (context, state) {
          return Center(child: Text('State: $state'));
        },
      ),
    );
  }
}
```

### 3. Integrated Operations

Use `performOperation` inside your Bloc to automatically handle:
*   **Progress**: Shows/hides `loader_overlay` automatically.
*   **Errors**: Maps `DataResponse` errors to the `failureStream`.
*   **Success**: Returns the unwrapped data to your success callback.

## 🔍 AppBlocObserver

To track your application state transitions and Single Results, register the `AppBlocObserver`:

```dart
void main() {
  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}
```

---

Built with ❤️ by Onix Flutter Team.
