# X Flutter Bloc 🚀

**X Flutter Bloc** is a modern, enterprise-grade state management framework built on top of `flutter_bloc`. It is designed to eliminate boilerplate, enforce Clean Architecture, and provide ruthless performance optimization out of the box.

Designed specifically for the **X Flutter Core** ecosystem, it seamlessly integrates network responses, global loading overlays, and centralized error handling.

---

## ✨ Key Features

- 🏗️ **Architectural Enforcement**: Strict separation of concerns using `BaseBloc` and `BaseCubit`.
- ⚡ **Ruthless Performance**: `BaseStatelessScreen` architecture designed for **Atomic Rebuilds**.
- 🔄 **Operation Orchestration**: Handle API calls with `performSafeOperation` — automatic loading, error mapping, and data success handling.
- 🛡️ **Type-Safe UI Streams**: Built-in protocols for `FailureStream`, `ProgressStream`, and `SingleResults`.
- ⏳ **Anti-Flicker Loading**: Intelligent reference-counted progress management with a 50ms anti-flicker delay.
- 📱 **Pixel Perfect**: Built-in integration with `flutter_screenutil` for adaptive UI.

---

## 📦 Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  x_flutter_bloc:
    git:
      url: https://github.com/fakhry-alnaffar/x-flutter-bloc.git
```

---

## 🏛️ Core Concepts

### 1. The BLoC Layer (`BaseBloc` / `BaseCubit`)
Forget manual `try-catch` and loading flags. Use `performSafeOperation`.

```dart
class LoginBloc extends BaseBloc<LoginEvent, LoginState, LoginSR> {
  final LoginUseCase _loginUseCase;

  LoginBloc(this._loginUseCase) : super(const LoginInitial());

  Future<void> _onLogin(LoginSubmitted event, Emitter emit) async {
    await performSafeOperation(
      operation: () => _loginUseCase(event.username, event.password),
      onSuccess: (user) {
        emit(LoginSuccess(user));
        addSr(const LoginSR.navigateToHome()); // Single Result for Navigation
      },
    );
  }
}
```

### 2. The UI Layer (`BaseStatelessScreen`)
The high-performance way to build screens. No `StatefulWidget` needed unless you have local controllers.

```dart
class LoginScreen extends BaseStatelessScreen<LoginState, LoginBloc, LoginSR> {
  const LoginScreen({super.key});

  @override
  LoginBloc createBloc(BuildContext context) => getIt<LoginBloc>();

  @override
  void onSR(BuildContext context, LoginSR sr) {
    if (sr is NavigateToHome) context.go('/home');
  }

  @override
  Widget buildScreen(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocSelector<LoginBloc, LoginState, String>(
          selector: (state) => state.errorMessage,
          builder: (context, error) => Text(error),
        ),
      ),
    );
  }
}
```

---

## 🚀 Operation Orchestration
The `OperationOrchestrator` mixin automates the repetitive task of handling `DataResponse` from the data layer:

1. **Shows Progress**: Triggers the global loading overlay.
2. **Executes**: Runs your UseCase/Repository call.
3. **Success**: Passes pure data to your `onSuccess` callback.
4. **Failure**: Automatically maps errors to the `failureStream` for the UI to show a Toast/Snackbar.
5. **Hides Progress**: Intelligently hides the loader, handling concurrent requests correctly.

---

## 🛠️ Best Practices

- **Atomic Rebuilds**: Always use `BlocSelector` or `context.select` inside `buildScreen`. Avoid rebuilding the whole Scaffold.
- **Single Results**: Use `addSr` for anything that isn't "State" (Navigation, Snacks, Dialogs).
- **Pure Domain**: Ensure your UseCases return `DataResponse<T>` from `x_flutter_core` for seamless integration.

---

## 🤝 Contributing
Built with ❤️ by **Fakhry Alnaffar** and the X team. 
Feel free to open issues or pull requests to improve the ecosystem.

## 📄 License
This project is licensed under the Apache License 2.0.
```
