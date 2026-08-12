import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'providers/keluarga_provider.dart';
import 'views/auth/login_page.dart';
import 'views/main_navigation_page.dart';
import 'views/splash/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KeluargaProvider()),
      ],
      child: MaterialApp(
        title: 'PKKITA Tasikmalaya',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1A60D0),
            primary: const Color(0xFF1A60D0),
            secondary: const Color(0xFF0097A7),
          ),
          scaffoldBackgroundColor: const Color(0xFFF5F9FC),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
          ),
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: ZoomPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          ),
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashPage(),
          '/login': (context) => const LoginPage(),
          '/': (context) => const LoginPage(),
          '/dashboard': (context) => const MainNavigationPage(),
        },
      ),
    );
  }
}
