import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/keluarga_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _counterController;
  late Animation<double> _counterAnimation;

  // Real-time interactive state
  bool _isOnline = true;
  bool _isSyncing = false;
  double _syncProgress = 1.0;
  int _pendingSyncCount = 0;
  String _lastSyncTime = 'Baru saja';
  String _selectedPeriod = 'Bulan Ini'; // 'Hari Ini', 'Bulan Ini', 'Tahun Ini'

  // Mock stats data that change based on selected period
  final Map<String, Map<String, dynamic>> _statsByPeriod = {
    'Hari Ini': {
      'totalKk': 3,
      'totalWarga': 11,
      'balita': 1,
      'ibuHamil': 1,
      'targetPercent': 0.92,
      'rumahSehatPercent': 0.95,
    },
    'Bulan Ini': {
      'totalKk': 24,
      'totalWarga': 88,
      'balita': 7,
      'ibuHamil': 3,
      'targetPercent': 0.85,
      'rumahSehatPercent': 0.90,
    },
    'Tahun Ini': {
      'totalKk': 142,
      'totalWarga': 512,
      'balita': 38,
      'ibuHamil': 14,
      'targetPercent': 0.98,
      'rumahSehatPercent': 0.94,
    },
  };

  // Mock list of families for interactive modal
  final List<Map<String, dynamic>> _familyList = [
    {
      'noKk': '3206011204200001',
      'kepalaKeluarga': 'Ahmad Subagja',
      'anggota': 4,
      'rtRw': 'RT 03 / RW 05',
      'status': 'Terverifikasi',
      'rumahSehat': true,
    },
    {
      'noKk': '3206011204200002',
      'kepalaKeluarga': 'Hendra Wijaya',
      'anggota': 3,
      'rtRw': 'RT 03 / RW 05',
      'status': 'Terverifikasi',
      'rumahSehat': true,
    },
    {
      'noKk': '3206011204200003',
      'kepalaKeluarga': 'Budi Santoso',
      'anggota': 5,
      'rtRw': 'RT 03 / RW 05',
      'status': 'Pending Sync',
      'rumahSehat': false,
    },
    {
      'noKk': '3206011204200004',
      'kepalaKeluarga': 'Dedi Kurniawan',
      'anggota': 2,
      'rtRw': 'RT 03 / RW 05',
      'status': 'Terverifikasi',
      'rumahSehat': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _counterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _counterAnimation = CurvedAnimation(
      parent: _counterController,
      curve: Curves.easeOutCubic,
    );
    _counterController.forward();
  }

  @override
  void dispose() {
    _counterController.dispose();
    super.dispose();
  }

  void _triggerSync() async {
    if (_isSyncing) return;
    setState(() {
      _isSyncing = true;
      _syncProgress = 0.0;
    });

    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 180));
      if (!mounted) return;
      setState(() {
        _syncProgress = i / 10.0;
      });
    }

    if (!mounted) return;
    setState(() {
      _isSyncing = false;
      _pendingSyncCount = 0;
      _lastSyncTime = 'Hari ini, 12:22 WIB';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Sinkronisasi Sukses! Semua data Dasawisma terunggah.',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, KeluargaProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: Color(0xFFD32F2F)),
            SizedBox(width: 10),
            Text('Konfirmasi Keluar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari akun PKKITA?',
          style: TextStyle(color: Color(0xFF546E7A), fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal',
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              provider.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
            child: const Text('Keluar Sesi',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _openDataKeluargaSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color(0xFFE3F2FD),
                          child: Icon(Icons.family_restroom_rounded,
                              color: Color(0xFF1A60D0)),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Data Keluarga (KK)',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF102851)),
                            ),
                            Text(
                              'Daftar Rumah Tangga Dasawisma',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF78909C)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _openTambahKkForm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A60D0),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Tambah KK',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Search bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari Nama Kepala Keluarga / No. KK...',
                    hintStyle: TextStyle(
                        color: Colors.grey.shade400, fontSize: 13),
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: Color(0xFF1A60D0)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: _familyList.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = _familyList[index];
                      final bool isVerified = item['status'] == 'Terverifikasi';
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFEBF1F6)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A60D0).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.home_rounded,
                                  color: Color(0xFF1A60D0), size: 24),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['kepalaKeluarga'],
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF102851)),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'NO. KK: ${item['noKk']}',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF78909C),
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: isVerified
                                              ? const Color(0xFFE8F5E9)
                                              : const Color(0xFFFFF3E0),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          item['status'],
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: isVerified
                                                ? const Color(0xFF2E7D32)
                                                : const Color(0xFFE65100),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '👥 ${item['anggota']} Anggota',
                                        style: const TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF546E7A),
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded,
                                color: Colors.grey),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _openTambahKkForm() {
    final nameCtrl = TextEditingController();
    final kkCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          top: 20,
          left: 20,
          right: 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '➕ Input Data KK Baru',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF102851)),
              ),
              const SizedBox(height: 4),
              const Text(
                'Masukkan informasi Kepala Keluarga untuk kelompok Dasawisma Melati 01',
                style: TextStyle(fontSize: 12, color: Color(0xFF78909C)),
              ),
              const SizedBox(height: 18),
              const Text('Nama Kepala Keluarga',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF102851))),
              const SizedBox(height: 6),
              TextFormField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  hintText: 'Contoh: Ahmad Subagja',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 14),
              const Text('Nomor Kartu Keluarga (KK)',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF102851))),
              const SizedBox(height: 6),
              TextFormField(
                controller: kkCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '16 Digit No. KK',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
                validator: (v) => v == null || v.length < 16
                    ? 'Masukkan 16 digit No. KK'
                    : null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A60D0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        _familyList.insert(0, {
                          'noKk': kkCtrl.text,
                          'kepalaKeluarga': nameCtrl.text,
                          'anggota': 1,
                          'rtRw': 'RT 03 / RW 05',
                          'status': 'Pending Sync',
                          'rumahSehat': true,
                        });
                        _pendingSyncCount++;
                      });
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Berhasil menambahkan KK: ${nameCtrl.text}'),
                          backgroundColor: const Color(0xFF2E7D32),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  child: const Text('Simpan Data KK',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openFeatureModalSheet({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Color(0xFFF8FAFC),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.12),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF102851)),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF78909C)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<KeluargaProvider>(context);
    final user = provider.currentUser;

    final namaKader = user?['nama'] ?? 'Siti Aminah, S.Pd';
    final role = user?['role'] ?? 'Kader Dasawisma';
    final dasawisma = 'Melati 01';
    final desa = user?['kelurahan'] ?? 'Sukahening';
    final kecamatan = 'Sukahening';
    final kabupaten = 'Kabupaten Tasikmalaya';

    final currentStats = _statsByPeriod[_selectedPeriod]!;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FA),

      // ── 1. Header (AppBar) & Navigasi ──
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A60D0),
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo_pkk_3d.png',
              height: 36,
              width: 36,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.shield,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'PKKITA',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  'Kab. Tasikmalaya',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Connection Status Toggle Badge
          GestureDetector(
            onTap: () {
              setState(() => _isOnline = !_isOnline);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      _isOnline ? '🟢 Mode Online Aktif' : '🟠 Mode Offline Aktif'),
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2), width: 1),
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isOnline
                          ? const Color(0xFF00E676)
                          : const Color(0xFFFFB74D),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _isOnline ? 'Online' : 'Offline',
                    style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Tombol Logout Door Exit Icon
          IconButton(
            icon: const Icon(Icons.exit_to_app_rounded,
                color: Colors.white, size: 26),
            tooltip: 'Keluar Sesi',
            onPressed: () => _showLogoutDialog(context, provider),
          ),
          const SizedBox(width: 4),
        ],
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── 2. Banner Profil Kader (Kartu Identitas) ──
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF1A60D0),
                    Color(0xFF0F3E90),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1A60D0).withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 50,
                    bottom: -40,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.04),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    width: 2),
                              ),
                              child: const CircleAvatar(
                                radius: 26,
                                backgroundColor: Color(0xFF3B82F6),
                                child: Icon(Icons.person_rounded,
                                    size: 30, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Selamat Datang, Kader! 👋',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFFB3D4FF),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    namaKader,
                                    style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.18),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      role,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        Divider(
                            color: Colors.white.withValues(alpha: 0.2),
                            height: 1),
                        const SizedBox(height: 14),

                        const Text(
                          'WILAYAH PENDATAAN DASAWISMA',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.1,
                            color: Color(0xFF99C2FF),
                          ),
                        ),
                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: _buildWilayahChip(
                                icon: Icons.grid_view_rounded,
                                label: 'Dasawisma',
                                value: dasawisma,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildWilayahChip(
                                icon: Icons.holiday_village_rounded,
                                label: 'Desa/Kel',
                                value: desa,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _buildWilayahChip(
                                icon: Icons.account_balance_rounded,
                                label: 'Kecamatan',
                                value: kecamatan,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildWilayahChip(
                                icon: Icons.location_city_rounded,
                                label: 'Kabupaten',
                                value: kabupaten,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Real-Time Sync Status Engine ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: _pendingSyncCount > 0
                      ? const Color(0xFFFFB74D)
                      : const Color(0xFFE2E8F0),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _pendingSyncCount > 0
                              ? const Color(0xFFFFF3E0)
                              : const Color(0xFFE8F5E9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _pendingSyncCount > 0
                              ? Icons.sync_problem_rounded
                              : Icons.cloud_done_rounded,
                          color: _pendingSyncCount > 0
                              ? const Color(0xFFF57C00)
                              : const Color(0xFF2E7D32),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _pendingSyncCount > 0
                                  ? '$_pendingSyncCount Data Belum Tersinkron'
                                  : 'Semua Data Tersinkron',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: _pendingSyncCount > 0
                                    ? const Color(0xFFE65100)
                                    : const Color(0xFF1B5E20),
                              ),
                            ),
                            Text(
                              'Terakhir diperbarui: $_lastSyncTime',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF78909C),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _isSyncing ? null : _triggerSync,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A60D0),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: _isSyncing
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(Icons.sync_rounded, size: 18),
                        label: Text(
                          _isSyncing
                              ? '${(_syncProgress * 100).toInt()}%'
                              : 'Sync',
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  if (_isSyncing) ...[
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _syncProgress,
                        backgroundColor: Colors.blue.shade50,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF1A60D0)),
                        minHeight: 5,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ── 3. Real-Time Interactive Statistics ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statistik Real-Time',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF102851),
                      ),
                    ),
                    Text(
                      'Monitoring data kelompok Dasawisma',
                      style: TextStyle(fontSize: 11, color: Color(0xFF78909C)),
                    ),
                  ],
                ),
                // Period Filter Selector Tabs
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: ['Hari Ini', 'Bulan Ini', 'Tahun Ini'].map((p) {
                      final isSelected = _selectedPeriod == p;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedPeriod = p;
                            _counterController.reset();
                            _counterController.forward();
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF1A60D0)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            p,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color:
                                  isSelected ? Colors.white : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Animated Real-Time Stat Boxes
            AnimatedBuilder(
              animation: _counterAnimation,
              builder: (context, child) {
                return Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _buildAnimatedStatBox(
                            count: (_counterAnimation.value *
                                    currentStats['totalKk'])
                                .toInt(),
                            label: 'Total KK',
                            icon: Icons.home_rounded,
                            color: const Color(0xFF1A60D0),
                          ),
                          const SizedBox(width: 8),
                          _buildAnimatedStatBox(
                            count: (_counterAnimation.value *
                                    currentStats['totalWarga'])
                                .toInt(),
                            label: 'Total Warga',
                            icon: Icons.groups_rounded,
                            color: const Color(0xFF00897B),
                          ),
                          const SizedBox(width: 8),
                          _buildAnimatedStatBox(
                            count: (_counterAnimation.value *
                                    currentStats['balita'])
                                .toInt(),
                            label: 'Balita',
                            icon: Icons.child_care_rounded,
                            color: const Color(0xFFE65100),
                          ),
                          const SizedBox(width: 8),
                          _buildAnimatedStatBox(
                            count: (_counterAnimation.value *
                                    currentStats['ibuHamil'])
                                .toInt(),
                            label: 'Ibu Hamil',
                            icon: Icons.favorite_rounded,
                            color: const Color(0xFFD81B60),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Progress Target Bars
                      Row(
                        children: [
                          Expanded(
                            child: _buildProgressBar(
                              label: 'Cakupan Pendataan',
                              percent: currentStats['targetPercent'],
                              color: const Color(0xFF1A60D0),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildProgressBar(
                              label: 'Rumah Sehat',
                              percent: currentStats['rumahSehatPercent'],
                              color: const Color(0xFF00897B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // ── 4. Modul Utama (Menu Aksi Grid) ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Modul Utama Pendataan',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF102851),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Interactive',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A60D0),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.05,
              children: [
                // 1. Data Keluarga
                _buildActionCard(
                  title: 'Data Keluarga',
                  subtitle: 'Pendataan rumah tangga & Kepala Keluarga (KK)',
                  icon: Icons.family_restroom_rounded,
                  accentColor: const Color(0xFF1A60D0),
                  onTap: _openDataKeluargaSheet,
                ),

                // 2. Daftar Warga
                _buildActionCard(
                  title: 'Daftar Warga',
                  subtitle: 'Detail data anggota keluarga (NIK, Pekerjaan)',
                  icon: Icons.groups_rounded,
                  accentColor: const Color(0xFF00897B),
                  onTap: () => _openFeatureModalSheet(
                    title: 'Daftar Warga Dasawisma',
                    subtitle: 'Total 88 Warga terdaftar dalam kelompok Melati 01',
                    icon: Icons.groups_rounded,
                    color: const Color(0xFF00897B),
                    children: [
                      _buildWargaItem('Siti Aminah, S.Pd', '3206015504880001',
                          'Istri (Ibu Rumah Tangga)', 'Ibu Hamil'),
                      _buildWargaItem('Ahmad Subagja', '3206011204850002',
                          'Kepala Keluarga (PNS)', 'Warga Aktif'),
                      _buildWargaItem('Rizky Subagja', '3206012010180003',
                          'Anak (Pelajar)', 'Balita'),
                      _buildWargaItem('Dewi Subagja', '3206012505210004',
                          'Anak', 'Balita'),
                    ],
                  ),
                ),

                // 3. Kondisi Rumah
                _buildActionCard(
                  title: 'Kondisi Rumah',
                  subtitle: 'Evaluasi hunian, jamban, SPAL & sumber air',
                  icon: Icons.home_work_rounded,
                  accentColor: const Color(0xFFE65100),
                  onTap: () => _openFeatureModalSheet(
                    title: 'Evaluasi Kondisi Rumah',
                    subtitle: 'Kriteria Kelayakan Hunian & Sanitasi Lingkungan',
                    icon: Icons.home_work_rounded,
                    color: const Color(0xFFE65100),
                    children: [
                      _buildCheckItem(
                          'Kategori Layak Huni (RLH)', true, 'Struktur kokoh & ventilasi memadai'),
                      _buildCheckItem(
                          'Jamban Keluarga Sehat', true, 'Memiliki Septic Tank sendiri'),
                      _buildCheckItem(
                          'Tempat Pembuangan Sampah', true, 'Tersedia pemilahan organik/anorganik'),
                      _buildCheckItem(
                          'Saluran Pembuangan Air (SPAL)', true, 'SPAL tertutup & lancar'),
                      _buildCheckItem(
                          'Sumber Air Bersih', true, 'Air PDAM / Sumur Terlindung'),
                    ],
                  ),
                ),

                // 4. Rekapitulasi
                _buildActionCard(
                  title: 'Rekapitulasi',
                  subtitle: 'Ringkasan statistik otomatis KK, Warga & KIA',
                  icon: Icons.analytics_rounded,
                  accentColor: const Color(0xFF6A1B9A),
                  onTap: () => _openFeatureModalSheet(
                    title: 'Laporan Rekapitulasi Data',
                    subtitle: 'Ringkasan Grafik & Ekspor Data PDF/Excel',
                    icon: Icons.analytics_rounded,
                    color: const Color(0xFF6A1B9A),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6A1B9A).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Laporan Dasawisma Melati 01',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6A1B9A))),
                            SizedBox(height: 4),
                            Text(
                                '• Total 24 KK terdata\n• 88 Total Warga (42 Pria, 46 Wanita)\n• 7 Balita Sehat, 3 Ibu Hamil\n• 22 Rumah Sehat (91.6%)',
                                style: TextStyle(
                                    fontSize: 13, height: 1.5)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6A1B9A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.download_rounded, size: 18),
                          label: const Text('Unduh Laporan Rekap (PDF)',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Mengunduh Laporan Rekapitulasi PDF...'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── 5. Fitur Pendukung & Potensi ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Fitur Pendukung & Potensi',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF102851),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Kominfo PKK',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE65100),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                // 1. Aku Hatinya PKK
                Expanded(
                  child: _buildSecondaryCard(
                    title: 'Aku Hatinya PKK',
                    description: 'Pemanfaatan Pekarangan & UP2K',
                    icon: Icons.yard_rounded,
                    color: const Color(0xFF2E7D32),
                    onTap: () => _openFeatureModalSheet(
                      title: 'Aku Hatinya PKK',
                      subtitle:
                          'Amalkan dan Kukuhkan Halaman Asri Teratur Indah dan Nyaman',
                      icon: Icons.yard_rounded,
                      color: const Color(0xFF2E7D32),
                      children: [
                        _buildCheckItem('Tanaman Pangan & Toga', true,
                            'Kencur, Jahe, Cabai, Sayuran Pekarangan'),
                        _buildCheckItem(
                            'Industri Rumah Tangga (UP2K)', true,
                            'Kerajinan Anyaman & Olahan Makanan Lokal'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // 2. Kesehatan & Posyandu (KIA)
                Expanded(
                  child: _buildSecondaryCard(
                    title: 'Posyandu (KIA)',
                    description: 'Pencatatan Bumil & Kesehatan Balita',
                    icon: Icons.child_care_rounded,
                    color: const Color(0xFFD81B60),
                    onTap: () => _openFeatureModalSheet(
                      title: 'Kesehatan Ibu & Anak (KIA)',
                      subtitle:
                          'Monitoring Posyandu, Usia Kehamilan & Imunisasi Balita',
                      icon: Icons.child_care_rounded,
                      color: const Color(0xFFD81B60),
                      children: [
                        _buildCheckItem('Pemantauan Ibu Hamil', true,
                            '3 Ibu Hamil terdata (Rutins Cek Posyandu)'),
                        _buildCheckItem('Imunisasi Balita Lengkap', true,
                            '7 Balita Lulus Imunisasi Dasar'),
                      ],
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),

      // ── Quick Action Floating Button (+ Tambah Data) ──
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openTambahKkForm,
        backgroundColor: const Color(0xFF1A60D0),
        foregroundColor: Colors.white,
        elevation: 6,
        icon: const Icon(Icons.add_rounded, size: 24),
        label: const Text('Tambah Data KK',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ),
    );
  }

  // ── Helper Widgets ──

  Widget _buildWilayahChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFFB3D4FF)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Color(0xFFB3D4FF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedStatBox({
    required int count,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 4),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar({
    required String label,
    required double percent,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style:
                    const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            Text('${(percent * 100).toInt()}%',
                style: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent,
            backgroundColor: color.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: accentColor.withValues(alpha: 0.1),
        highlightColor: accentColor.withValues(alpha: 0.05),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFEBF1F6), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: accentColor, size: 26),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF102851),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF78909C),
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFEBF1F6), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF102851),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF78909C),
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWargaItem(
      String name, String nik, String relation, String badge) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEBF1F6)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFE3F2FD),
            child: Icon(Icons.person_outline_rounded, color: Color(0xFF1A60D0)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF102851))),
                Text('NIK: $nik • $relation',
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF78909C))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(badge,
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32))),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String title, bool checked, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEBF1F6)),
      ),
      child: Row(
        children: [
          Icon(
            checked ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: checked ? const Color(0xFF2E7D32) : Colors.red,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF102851))),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF78909C))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


