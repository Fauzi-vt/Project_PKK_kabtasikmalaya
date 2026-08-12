import 'package:flutter/material.dart';
import 'dashboard/dashboard_page.dart';
import 'keluarga/keluarga_list_page.dart';
import 'rekapitulasi/rekapitulasi_page.dart';
import 'profile/profile_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    KeluargaListPage(),
    RekapitulasiPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: NavigationBar(
            height: 64,
            elevation: 0,
            backgroundColor: Colors.white,
            indicatorColor: const Color(0xFF1A60D0).withValues(alpha: 0.12),
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined, color: Color(0xFF78909C)),
                selectedIcon:
                    Icon(Icons.home_rounded, color: Color(0xFF1A60D0)),
                label: 'Beranda',
              ),
              NavigationDestination(
                icon: Icon(Icons.family_restroom_outlined,
                    color: Color(0xFF78909C)),
                selectedIcon: Icon(Icons.family_restroom_rounded,
                    color: Color(0xFF1A60D0)),
                label: 'Data KK',
              ),
              NavigationDestination(
                icon: Icon(Icons.analytics_outlined, color: Color(0xFF78909C)),
                selectedIcon:
                    Icon(Icons.analytics_rounded, color: Color(0xFF1A60D0)),
                label: 'Statistik',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded,
                    color: Color(0xFF78909C)),
                selectedIcon:
                    Icon(Icons.person_rounded, color: Color(0xFF1A60D0)),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
