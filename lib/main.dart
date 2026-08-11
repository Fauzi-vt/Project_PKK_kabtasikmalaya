import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/keluarga_provider.dart';
import 'views/auth/login_page.dart';
import 'views/dashboard/dashboard_page.dart';

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
        title: 'PKK Dasawisma',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0288D1),
            primary: const Color(0xFF0288D1),
            secondary: const Color(0xFF0097A7),
          ),
          scaffoldBackgroundColor: const Color(0xFFF5F9FC),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginPage(),
          '/dashboard': (context) => const DashboardPage(),
        },
      ),
    );
  }
}
