import 'package:flutter/material.dart';
import '../../models/anggota_keluarga.dart';

class KeluargaDetailPage extends StatefulWidget {
  final Map<String, dynamic> keluarga;

  const KeluargaDetailPage({super.key, required this.keluarga});

  @override
  State<KeluargaDetailPage> createState() => _KeluargaDetailPageState();
}

class _KeluargaDetailPageState extends State<KeluargaDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  // Mock data anggota keluarga berdasarkan ID KK yang dipilih
  late List<AnggotaKeluarga> _anggotaList;

  // Mock kondisi rumah
  late bool _rumahLayakHuni;
  late String _sumberAir;
  late bool _jambanSehat;
  late bool _tempatSampah;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    _loadMockData();
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  /// Mengisi data anggota keluarga berdasarkan ID KK (mock data).
  void _loadMockData() {
    final kkId = widget.keluarga['id'] ?? '';

    // Mock data berbeda per KK
    final Map<String, List<Map<String, dynamic>>> mockAnggota = {
      'KK-001': [
        {
          'id': 'WRG-001', 'nama': 'Ahmad Subagja',
          'nik': '3206011204850001', 'statusHubungan': 'Kepala Keluarga',
          'jenisKelamin': 'L', 'usia': 41, 'statusKhusus': '',
        },
        {
          'id': 'WRG-002', 'nama': 'Siti Nuraeni',
          'nik': '3206015504880002', 'statusHubungan': 'Istri',
          'jenisKelamin': 'P', 'usia': 38, 'statusKhusus': 'Ibu Hamil',
        },
        {
          'id': 'WRG-003', 'nama': 'Rizky Ahmad',
          'nik': '3206012010180003', 'statusHubungan': 'Anak',
          'jenisKelamin': 'L', 'usia': 8, 'statusKhusus': '',
        },
        {
          'id': 'WRG-004', 'nama': 'Dewi Ahmad',
          'nik': '3206012505210004', 'statusHubungan': 'Anak',
          'jenisKelamin': 'P', 'usia': 3, 'statusKhusus': 'Balita',
        },
      ],
      'KK-002': [
        {
          'id': 'WRG-005', 'nama': 'Hendra Wijaya',
          'nik': '3206011505780005', 'statusHubungan': 'Kepala Keluarga',
          'jenisKelamin': 'L', 'usia': 48, 'statusKhusus': '',
        },
        {
          'id': 'WRG-006', 'nama': 'Yeni Rahayu',
          'nik': '3206016006820006', 'statusHubungan': 'Istri',
          'jenisKelamin': 'P', 'usia': 44, 'statusKhusus': '',
        },
        {
          'id': 'WRG-007', 'nama': 'Rian Hendra',
          'nik': '3206010907040007', 'statusHubungan': 'Anak',
          'jenisKelamin': 'L', 'usia': 22, 'statusKhusus': '',
        },
      ],
      'KK-003': [
        {
          'id': 'WRG-008', 'nama': 'Budi Santoso',
          'nik': '3206011103750008', 'statusHubungan': 'Kepala Keluarga',
          'jenisKelamin': 'L', 'usia': 51, 'statusKhusus': '',
        },
        {
          'id': 'WRG-009', 'nama': 'Rina Santoso',
          'nik': '3206016208780009', 'statusHubungan': 'Istri',
          'jenisKelamin': 'P', 'usia': 48, 'statusKhusus': '',
        },
        {
          'id': 'WRG-010', 'nama': 'Gilang Santoso',
          'nik': '3206011505010010', 'statusHubungan': 'Anak',
          'jenisKelamin': 'L', 'usia': 25, 'statusKhusus': '',
        },
        {
          'id': 'WRG-011', 'nama': 'Sari Santoso',
          'nik': '3206012202040011', 'statusHubungan': 'Anak',
          'jenisKelamin': 'P', 'usia': 22, 'statusKhusus': '',
        },
        {
          'id': 'WRG-012', 'nama': 'Bayu Santoso',
          'nik': '3206011507180012', 'statusHubungan': 'Anak',
          'jenisKelamin': 'L', 'usia': 8, 'statusKhusus': '',
        },
      ],
      'KK-004': [
        {
          'id': 'WRG-013', 'nama': 'Dedi Kurniawan',
          'nik': '3206010208800013', 'statusHubungan': 'Kepala Keluarga',
          'jenisKelamin': 'L', 'usia': 46, 'statusKhusus': '',
        },
        {
          'id': 'WRG-014', 'nama': 'Fera Kurniawan',
          'nik': '3206014509830014', 'statusHubungan': 'Istri',
          'jenisKelamin': 'P', 'usia': 43, 'statusKhusus': '',
        },
      ],
    };

    final Map<String, Map<String, dynamic>> mockKondisiRumah = {
      'KK-001': {'layak': true, 'air': 'PDAM', 'jamban': true, 'sampah': true},
      'KK-002': {'layak': true, 'air': 'Sumur Terlindung', 'jamban': true, 'sampah': true},
      'KK-003': {'layak': false, 'air': 'Sumur Galian', 'jamban': false, 'sampah': true},
      'KK-004': {'layak': true, 'air': 'PDAM', 'jamban': true, 'sampah': false},
    };

    final rawAnggota = mockAnggota[kkId] ?? [];
    _anggotaList = rawAnggota.map((m) => AnggotaKeluarga.fromMap(m)).toList();

    final kondisi = mockKondisiRumah[kkId] ?? {};
    _rumahLayakHuni = kondisi['layak'] as bool? ?? true;
    _sumberAir = kondisi['air'] as String? ?? 'PDAM';
    _jambanSehat = kondisi['jamban'] as bool? ?? true;
    _tempatSampah = kondisi['sampah'] as bool? ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final kk = widget.keluarga;
    final bool isVerified = kk['status'] == 'Terverifikasi';

    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FA),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── SliverAppBar dengan Header Gradient ──────────────────────
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: const Color(0xFF1A60D0),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1A60D0), Color(0xFF0A2A6E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Dekorasi lingkaran latar
                        Positioned(
                          right: -30, top: -30,
                          child: Container(
                            width: 150, height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.05),
                            ),
                          ),
                        ),
                        Positioned(
                          left: -20, bottom: -40,
                          child: Container(
                            width: 120, height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.04),
                            ),
                          ),
                        ),
                        // Konten header
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.18),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(
                                      Icons.home_rounded,
                                      color: Colors.white, size: 26,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          kk['kepalaKeluarga'] ?? '-',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Kepala Keluarga',
                                          style: TextStyle(
                                            color: Colors.white.withValues(alpha: 0.75),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Status badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: isVerified
                                          ? const Color(0xFF43A047)
                                          : const Color(0xFFFF8F00),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      kk['status'] ?? '-',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
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
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Kartu Info KK ──────────────────────────────────
                      _buildInfoKkCard(kk),
                      const SizedBox(height: 16),

                      // ── Status Kondisi Rumah ────────────────────────────
                      _buildKondisiRumahCard(),
                      const SizedBox(height: 24),

                      // ── Header Anggota Keluarga ─────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Anggota Keluarga',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF102851),
                                ),
                              ),
                              Text(
                                'Daftar warga dalam KK ini',
                                style: TextStyle(
                                    fontSize: 11, color: Color(0xFF78909C)),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE3F2FD),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${_anggotaList.length} Orang',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A60D0),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // ── List / Empty Anggota Keluarga ───────────────────
                      _anggotaList.isEmpty
                          ? _buildEmptyAnggota()
                          : Column(
                              children: List.generate(
                                _anggotaList.length,
                                (i) => _buildAnggotaCard(
                                    _anggotaList[i], i),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // ── FAB: Tambah Warga ─────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate ke form tambah warga
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text('Form Tambah Warga akan tersedia segera'),
                ],
              ),
              backgroundColor: const Color(0xFF1A60D0),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        },
        backgroundColor: const Color(0xFF1A60D0),
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text(
          'Tambah Warga',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }

  // ── Kartu Informasi KK ─────────────────────────────────────────────────────
  Widget _buildInfoKkCard(Map<String, dynamic> kk) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header kartu
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.credit_card_rounded,
                    color: Color(0xFF1A60D0), size: 20),
              ),
              const SizedBox(width: 10),
              const Text(
                'Informasi Kartu Keluarga',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF102851),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFEDF2F7)),
          const SizedBox(height: 14),
          _buildInfoRow(Icons.badge_rounded, 'No. KK', kk['noKk'] ?? '-'),
          _buildInfoRow(Icons.grid_view_rounded, 'Dasawisma',
              kk['dasawisma'] ?? '-'),
          _buildInfoRow(Icons.location_on_rounded, 'Wilayah',
              'RT ${kk['rt'] ?? '-'} / RW ${kk['rw'] ?? '-'}'),
          _buildInfoRow(Icons.people_rounded, 'Jumlah Anggota',
              '${kk['jumlahAnggota'] ?? 0} Orang'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Icon(icon, size: 15, color: const Color(0xFF78909C)),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF546E7A),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF102851),
            ),
          ),
        ],
      ),
    );
  }

  // ── Kartu Kondisi Rumah ────────────────────────────────────────────────────
  Widget _buildKondisiRumahCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.home_work_rounded,
                    color: Color(0xFFE65100), size: 20),
              ),
              const SizedBox(width: 10),
              const Text(
                'Status Kondisi Rumah',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF102851),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Chip-chip status
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildStatusChip(
                label: _rumahLayakHuni ? 'Layak Huni ✓' : 'Tidak Layak ✗',
                isOk: _rumahLayakHuni,
              ),
              _buildStatusChip(
                label: 'Air: $_sumberAir',
                isOk: true,
                customColor: const Color(0xFF0288D1),
              ),
              _buildStatusChip(
                label: _jambanSehat ? 'Jamban Sehat ✓' : 'Jamban Tidak Layak ✗',
                isOk: _jambanSehat,
              ),
              _buildStatusChip(
                label: _tempatSampah ? 'Sampah Terkelola ✓' : 'Sampah Belum Terkelola ✗',
                isOk: _tempatSampah,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip({
    required String label,
    required bool isOk,
    Color? customColor,
  }) {
    final Color bgColor = customColor != null
        ? customColor.withValues(alpha: 0.1)
        : isOk
            ? const Color(0xFFE8F5E9)
            : const Color(0xFFFFEBEE);
    final Color textColor = customColor ??
        (isOk ? const Color(0xFF2E7D32) : const Color(0xFFC62828));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: textColor.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  // ── Kartu Item Anggota Keluarga ───────────────────────────────────────────
  Widget _buildAnggotaCard(AnggotaKeluarga anggota, int index) {
    final bool isKepala = anggota.statusHubungan == 'Kepala Keluarga';
    final bool isPerempuan = anggota.jenisKelamin == 'P';

    Color badgeColor;
    Color badgeBg;
    switch (anggota.statusKhusus) {
      case 'Ibu Hamil':
        badgeColor = const Color(0xFFD81B60);
        badgeBg = const Color(0xFFFCE4EC);
        break;
      case 'Balita':
        badgeColor = const Color(0xFFE65100);
        badgeBg = const Color(0xFFFFF3E0);
        break;
      case 'Lansia':
        badgeColor = const Color(0xFF6A1B9A);
        badgeBg = const Color(0xFFF3E5F5);
        break;
      default:
        badgeColor = Colors.transparent;
        badgeBg = Colors.transparent;
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 250 + (index * 70)),
      curve: Curves.easeOut,
      builder: (context, value, child) => Transform.translate(
        offset: Offset(0, 16 * (1 - value)),
        child: Opacity(opacity: value, child: child),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isKepala ? const Color(0xFFF0F7FF) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isKepala
                ? const Color(0xFFBBD6FA)
                : const Color(0xFFEDF2F7),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isKepala
                      ? [const Color(0xFF1A60D0), const Color(0xFF0F3E90)]
                      : isPerempuan
                          ? [const Color(0xFFD81B60), const Color(0xFF880E4F)]
                          : [const Color(0xFF00897B), const Color(0xFF00574B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                isKepala
                    ? Icons.person_rounded
                    : isPerempuan
                        ? Icons.face_3_rounded
                        : Icons.face_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          anggota.nama,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isKepala
                                ? const Color(0xFF1A60D0)
                                : const Color(0xFF102851),
                          ),
                        ),
                      ),
                      if (isKepala)
                        const Icon(Icons.star_rounded,
                            color: Color(0xFF1A60D0), size: 16),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'NIK: ${anggota.nik}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF78909C),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      // Status hubungan
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isKepala
                              ? const Color(0xFFE3F2FD)
                              : const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          anggota.statusHubungan,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isKepala
                                ? const Color(0xFF1A60D0)
                                : const Color(0xFF546E7A),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),

                      // Usia
                      Text(
                        '${anggota.usia} thn · ${anggota.jenisKelamin == 'L' ? 'Laki-laki' : 'Perempuan'}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF78909C),
                        ),
                      ),
                      const SizedBox(width: 6),

                      // Status khusus badge
                      if (anggota.statusKhusus.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: badgeBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            anggota.statusKhusus,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: badgeColor,
                            ),
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
    );
  }

  // ── Empty State Anggota ────────────────────────────────────────────────────
  Widget _buildEmptyAnggota() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEDF2F7)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.people_outline_rounded,
              size: 44,
              color: Color(0xFF1A60D0),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum Ada Data Anggota',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF102851),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tekan tombol "Tambah Warga" di bawah\nuntuk mulai menambahkan anggota keluarga.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF78909C),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
