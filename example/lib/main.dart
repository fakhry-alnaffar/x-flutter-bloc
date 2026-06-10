import 'package:example/base_bloc_example/base_bloc_example_screen.dart';
import 'package:example/base_cubit_example/base_cubit_example_screen.dart';
import 'package:example/di.dart';
import 'package:example/my_account/presentation/screen/my_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDi(GetIt.I);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GlobalLoaderOverlay(
        overlayWidgetBuilder: (_) => const Center(
          child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF)),
            useMaterial3: true,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const MyHomePage(),
            '/base_cubit_example': (context) =>
                const BaseCubitExampleScreen(title: 'Base Cubit Example'),
            '/base_bloc_example': (context) =>
                const BaseBlocExampleScreen(title: 'Base BLoC Example'),
            '/my_account': (context) => const MyAccountScreen(),
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('X Flutter BLoC — Examples'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _NavButton(
                label: 'Base Cubit Example',
                icon: Icons.square_rounded,
                color: const Color(0xFF2196F3),
                route: '/base_cubit_example',
              ),
              const SizedBox(height: 12),
              _NavButton(
                label: 'Base BLoC Example',
                icon: Icons.account_tree_rounded,
                color: const Color(0xFF9C27B0),
                route: '/base_bloc_example',
              ),
              const SizedBox(height: 12),
              _NavButton(
                label: 'My Account (Clean Arch)',
                icon: Icons.manage_accounts_rounded,
                color: const Color(0xFF6C63FF),
                route: '/my_account',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.route,
  });

  final String label;
  final IconData icon;
  final Color color;
  final String route;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton.icon(
        onPressed: () => Navigator.pushNamed(context, route),
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
