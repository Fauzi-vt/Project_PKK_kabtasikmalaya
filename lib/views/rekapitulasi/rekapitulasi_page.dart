import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/report_data.dart';
import '../../providers/keluarga_provider.dart';
import '../../services/report_export_service.dart';

class RekapitulasiPage extends StatelessWidget {
  const RekapitulasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FA),
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rekapitulasi & Grafik Data',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              'Dasawisma Melati 01 · Kab. Tasikmalaya',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1A60D0),
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 20),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_rounded,
                color: Colors.white, size: 24),
            tooltip: 'Unduh Laporan',
            onPressed: () => _showExportReportBottomSheet(context),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 1. Kartu Ringkasan Utama ──────────────────────────────────────
            _buildRingkasanUtamaGrid(),
            const SizedBox(height: 20),

            // ── 2. Grafik Demografi Gender ───────────────────────────────────
            _buildGrafikDemografiGender(),
            const SizedBox(height: 20),

            // ── 3. Grafik Kelompok Rentan ────────────────────────────────────
            _buildGrafikKelompokRentan(),
            const SizedBox(height: 20),

            // ── 4. Grafik Kondisi Rumah & Sanitasi ────────────────────────────
            _buildStatistikKondisiRumah(),
            const SizedBox(height: 20),

            // ── 5. Distribusi Pekerjaan ───────────────────────────────────────
            _buildDistribusiPekerjaan(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ── 1. Kartu Ringkasan Utama Grid ──────────────────────────────────────────
  Widget _buildRingkasanUtamaGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ringkasan Data Utama',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF102851),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Akumulasi data terverifikasi di wilayah Dasawisma Melati 01',
          style: TextStyle(fontSize: 12, color: Color(0xFF78909C)),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: 'Total KK',
                value: '142',
                unit: 'Keluarga',
                icon: Icons.family_restroom_rounded,
                gradientColors: [const Color(0xFF1A60D0), const Color(0xFF0F3E90)],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                title: 'Total Warga',
                value: '518',
                unit: 'Jiwa',
                icon: Icons.groups_rounded,
                gradientColors: [const Color(0xFF00897B), const Color(0xFF004D40)],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: 'Rumah Sehat',
                value: '88.7%',
                unit: '126 dari 142 KK',
                icon: Icons.home_work_rounded,
                gradientColors: [const Color(0xFF43A047), const Color(0xFF1B5E20)],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                title: 'Jamban Sehat',
                value: '94.4%',
                unit: '134 dari 142 KK',
                icon: Icons.clean_hands_rounded,
                gradientColors: [const Color(0xFF0288D1), const Color(0xFF01579B)],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required List<Color> gradientColors,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(
              icon,
              size: 64,
              color: Colors.white.withValues(alpha: 0.12),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                unit,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── 2. Grafik Demografi Gender (Horizontal Bar Chart) ──────────────────────
  Widget _buildGrafikDemografiGender() {
    const int lakiLaki = 249;
    const int perempuan = 269;
    const int total = lakiLaki + perempuan;
    final double percentLaki = (lakiLaki / total) * 100;
    final double percentPerempuan = (perempuan / total) * 100;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.wc_rounded,
                    color: Color(0xFF1A60D0), size: 20),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Demografi Berdasarkan Gender',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF102851),
                      ),
                    ),
                    Text(
                      'Perbandingan populasi Laki-laki vs Perempuan',
                      style: TextStyle(fontSize: 11, color: Color(0xFF78909C)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Horizontal Bar Visual
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 32,
              child: Row(
                children: [
                  Expanded(
                    flex: lakiLaki,
                    child: Container(
                      color: const Color(0xFF1A60D0),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                        '${percentLaki.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: perempuan,
                    child: Container(
                      color: const Color(0xFFD81B60),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 12),
                      child: Text(
                        '${percentPerempuan.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Legend / Detail Cards
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A60D0).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF1A60D0).withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1A60D0),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Laki-laki',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF546E7A),
                              ),
                            ),
                            Text(
                              '$lakiLaki Jiwa',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF102851),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD81B60).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFD81B60).withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD81B60),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Perempuan',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF546E7A),
                              ),
                            ),
                            Text(
                              '$perempuan Jiwa',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF102851),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── 3. Grafik Kelompok Rentan ─────────────────────────────────────────────
  Widget _buildGrafikKelompokRentan() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
                child: const Icon(Icons.shield_rounded,
                    color: Color(0xFFE65100), size: 20),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statistik Kelompok Rentan & KIA',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF102851),
                      ),
                    ),
                    Text(
                      'Monitoring Kesehatan Ibu, Anak & Lansia',
                      style: TextStyle(fontSize: 11, color: Color(0xFF78909C)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          _buildRentanProgressItem(
            label: 'Balita (0 - 5 Tahun)',
            count: 42,
            percent: 0.081,
            percentText: '8.1%',
            icon: Icons.child_care_rounded,
            color: const Color(0xFFE65100),
          ),
          const SizedBox(height: 14),

          _buildRentanProgressItem(
            label: 'Ibu Hamil (Bumil)',
            count: 12,
            percent: 0.023,
            percentText: '2.3%',
            icon: Icons.favorite_rounded,
            color: const Color(0xFFD81B60),
          ),
          const SizedBox(height: 14),

          _buildRentanProgressItem(
            label: 'Lansia (> 60 Tahun)',
            count: 38,
            percent: 0.073,
            percentText: '7.3%',
            icon: Icons.elderly_rounded,
            color: const Color(0xFF6A1B9A),
          ),
          const SizedBox(height: 14),

          _buildRentanProgressItem(
            label: 'Anak Usia Sekolah (6 - 18 Tahun)',
            count: 114,
            percent: 0.220,
            percentText: '22.0%',
            icon: Icons.school_rounded,
            color: const Color(0xFF00897B),
          ),
        ],
      ),
    );
  }

  Widget _buildRentanProgressItem({
    required String label,
    required int count,
    required double percent,
    required String percentText,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF102851),
                ),
              ),
            ),
            Text(
              '$count Jiwa ',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              '($percentText)',
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF78909C),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: percent * 3.5, // Dikali skala visual agar lebih jelas
            backgroundColor: color.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  // ── 4. Statistik Kondisi Rumah ─────────────────────────────────────────────
  Widget _buildStatistikKondisiRumah() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.home_work_rounded,
                    color: Color(0xFF2E7D32), size: 20),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statistik Hunian & Sanitasi',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF102851),
                      ),
                    ),
                    Text(
                      'Kondisi fisik rumah & fasilitas dasar kesehatan',
                      style: TextStyle(fontSize: 11, color: Color(0xFF78909C)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          _buildSanitasiProgress(
            label: 'Rumah Layak Huni (RLH)',
            countText: '126 / 142 KK',
            percent: 0.887,
            percentText: '88.7%',
            color: const Color(0xFF2E7D32),
          ),
          const SizedBox(height: 14),

          _buildSanitasiProgress(
            label: 'Kepemilikan Jamban Sehat',
            countText: '134 / 142 KK',
            percent: 0.944,
            percentText: '94.4%',
            color: const Color(0xFF0288D1),
          ),
          const SizedBox(height: 14),

          _buildSanitasiProgress(
            label: 'Akses Air Bersih (PDAM/Sumur)',
            countText: '138 / 142 KK',
            percent: 0.972,
            percentText: '97.2%',
            color: const Color(0xFF00ACC1),
          ),
          const SizedBox(height: 14),

          _buildSanitasiProgress(
            label: 'Pengelolaan Sampah Mandiri',
            countText: '118 / 142 KK',
            percent: 0.831,
            percentText: '83.1%',
            color: const Color(0xFFF57C00),
          ),
          const SizedBox(height: 14),

          _buildSanitasiProgress(
            label: 'Saluran Pembuangan Air (SPAL)',
            countText: '122 / 142 KK',
            percent: 0.859,
            percentText: '85.9%',
            color: const Color(0xFF3F51B5),
          ),
        ],
      ),
    );
  }

  Widget _buildSanitasiProgress({
    required String label,
    required String countText,
    required double percent,
    required String percentText,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF102851),
              ),
            ),
            Row(
              children: [
                Text(
                  countText,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF78909C),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    percentText,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: percent,
            backgroundColor: color.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  // ── 5. Distribusi Pekerjaan ────────────────────────────────────────────────
  Widget _buildDistribusiPekerjaan() {
    final List<Map<String, dynamic>> pekerjaanList = [
      {'nama': 'Wiraswasta / Usaha Mandiri', 'jumlah': 168, 'percent': 32.4, 'color': const Color(0xFF1A60D0)},
      {'nama': 'Ibu Rumah Tangga', 'jumlah': 142, 'percent': 27.4, 'color': const Color(0xFFD81B60)},
      {'nama': 'Karyawan Swasta', 'jumlah': 94, 'percent': 18.1, 'color': const Color(0xFF00897B)},
      {'nama': 'PNS / TNI / Polri', 'jumlah': 52, 'percent': 10.0, 'color': const Color(0xFF6A1B9A)},
      {'nama': 'Petani / Buruh Harian', 'jumlah': 44, 'percent': 8.5, 'color': const Color(0xFFE65100)},
      {'nama': 'Lainnya / Belum Bekerja', 'jumlah': 18, 'percent': 3.6, 'color': const Color(0xFF78909C)},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EAF6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.work_rounded,
                    color: Color(0xFF3F51B5), size: 20),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Distribusi Mata Pencaharian',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF102851),
                      ),
                    ),
                    Text(
                      'Mata pencaharian utama warga usia produktif',
                      style: TextStyle(fontSize: 11, color: Color(0xFF78909C)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Column(
            children: pekerjaanList.map((item) {
              final Color itemColor = item['color'] as Color;
              final double percent = (item['percent'] as num).toDouble() / 100;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item['nama'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF102851),
                          ),
                        ),
                        Text(
                          '${item['jumlah']} Orang (${item['percent']}%)',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: itemColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percent,
                        backgroundColor: itemColor.withValues(alpha: 0.12),
                        valueColor: AlwaysStoppedAnimation<Color>(itemColor),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatOptionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE2E8F0),
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? color : const Color(0xFF102851),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF78909C),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExportReportBottomSheet(BuildContext context) {
    final now = DateTime.now();
    final monthNames = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    final currentMonth = monthNames[now.month - 1];
    final quarter = ((now.month - 1) ~/ 3) + 1;

    String selectedFormat = 'PDF';
    String selectedScope = 'bulan';
    bool isExporting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
                top: 20,
                left: 20,
                right: 20,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A60D0).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.picture_as_pdf_rounded,
                            color: Color(0xFF1A60D0),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ekspor & Cetak Laporan',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF102851),
                                ),
                              ),
                              Text(
                                'Pilih format & cakupan data Dasawisma Melati 01',
                                style: TextStyle(fontSize: 12, color: Color(0xFF78909C)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Format Selection
                    const Text(
                      'Format Dokumen',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF102851),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildFormatOptionCard(
                            title: 'Dokumen PDF',
                            subtitle: 'Formal (.pdf)',
                            icon: Icons.picture_as_pdf_rounded,
                            color: const Color(0xFFD32F2F),
                            isSelected: selectedFormat == 'PDF',
                            onTap: () {
                              setModalState(() => selectedFormat = 'PDF');
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildFormatOptionCard(
                            title: 'Spreadsheet',
                            subtitle: 'Excel (.xlsx)',
                            icon: Icons.table_chart_rounded,
                            color: const Color(0xFF2E7D32),
                            isSelected: selectedFormat == 'Excel',
                            onTap: () {
                              setModalState(() => selectedFormat = 'Excel');
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Scope Selection
                    const Text(
                      'Cakupan Periode Laporan',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF102851),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: Text('Bulan Ini ($currentMonth ${now.year})'),
                          selected: selectedScope == 'bulan',
                          selectedColor: const Color(0xFF1A60D0).withValues(alpha: 0.15),
                          labelStyle: TextStyle(
                            color: selectedScope == 'bulan'
                                ? const Color(0xFF1A60D0)
                                : Colors.grey.shade700,
                            fontWeight: selectedScope == 'bulan'
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          onSelected: (val) {
                            if (val) setModalState(() => selectedScope = 'bulan');
                          },
                        ),
                        ChoiceChip(
                          label: Text('Triwulan $quarter (Q$quarter ${now.year})'),
                          selected: selectedScope == 'triwulan',
                          selectedColor: const Color(0xFF1A60D0).withValues(alpha: 0.15),
                          labelStyle: TextStyle(
                            color: selectedScope == 'triwulan'
                                ? const Color(0xFF1A60D0)
                                : Colors.grey.shade700,
                            fontWeight: selectedScope == 'triwulan'
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          onSelected: (val) {
                            if (val) setModalState(() => selectedScope = 'triwulan');
                          },
                        ),
                        ChoiceChip(
                          label: Text('Tahun Berjalan (${now.year})'),
                          selected: selectedScope == 'tahun',
                          selectedColor: const Color(0xFF1A60D0).withValues(alpha: 0.15),
                          labelStyle: TextStyle(
                            color: selectedScope == 'tahun'
                                ? const Color(0xFF1A60D0)
                                : Colors.grey.shade700,
                            fontWeight: selectedScope == 'tahun'
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          onSelected: (val) {
                            if (val) setModalState(() => selectedScope = 'tahun');
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Preview Summary Card
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.remove_red_eye_outlined,
                                  size: 16, color: Color(0xFF546E7A)),
                              SizedBox(width: 6),
                              Text(
                                'Pratinjau Data Ringkasan',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF546E7A),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Kepala Keluarga:',
                                  style: TextStyle(fontSize: 12, color: Color(0xFF78909C))),
                              Text('142 KK',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF102851))),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Anggota Warga:',
                                  style: TextStyle(fontSize: 12, color: Color(0xFF78909C))),
                              Text('518 Jiwa',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF102851))),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Cakupan Rumah Sehat:',
                                  style: TextStyle(fontSize: 12, color: Color(0xFF78909C))),
                              Text('88.7% (126/142)',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Submit Export Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A60D0),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: isExporting
                            ? null
                            : () async {
                                setModalState(() => isExporting = true);
                                try {
                                  final provider = Provider.of<KeluargaProvider>(
                                      context,
                                      listen: false);
                                  final cadreName = provider
                                          .currentUser?['nama'] as String? ??
                                      'Siti Aminah, S.Pd';

                                  final scopeLabel =
                                      ReportExportService.calculateScopeLabel(
                                          selectedScope, now);
                                  final reportData = ReportData.fromDasawisma(
                                    cadreName: cadreName,
                                    scopeType: selectedScope,
                                    scopeLabel: scopeLabel,
                                  );

                                  final ReportExportResult result;
                                  if (selectedFormat == 'PDF') {
                                    result = await ReportExportService.exportPdf(
                                        reportData);
                                  } else {
                                    result =
                                        await ReportExportService.exportExcel(
                                            reportData);
                                  }

                                  if (!context.mounted) return;
                                  Navigator.pop(ctx);
                                  _showExportSuccessModal(context, result);
                                } catch (e) {
                                  if (!context.mounted) return;
                                  setModalState(() => isExporting = false);
                                  Navigator.pop(ctx);
                                  _showExportErrorModal(
                                      context,
                                      e,
                                      () =>
                                          _showExportReportBottomSheet(context));
                                }
                              },
                        icon: isExporting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Icon(
                                selectedFormat == 'PDF'
                                    ? Icons.picture_as_pdf_rounded
                                    : Icons.table_chart_rounded,
                                size: 20,
                              ),
                        label: Text(
                          isExporting
                              ? 'Memproses Dokumen...'
                              : 'Ekspor Dokumen $selectedFormat',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showExportSuccessModal(
      BuildContext context, ReportExportResult result) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            top: 20,
            left: 20,
            right: 20,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              const SizedBox(height: 18),

              // Success Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F5E9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF2E7D32),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Laporan Berhasil Dibuat',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF102851),
                          ),
                        ),
                        Text(
                          'Dokumen ${result.format} telah siap diakses',
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF78909C)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // File Metadata Container
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          result.format == 'PDF'
                              ? Icons.picture_as_pdf_rounded
                              : Icons.table_chart_rounded,
                          color: result.format == 'PDF'
                              ? const Color(0xFFD32F2F)
                              : const Color(0xFF2E7D32),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            result.filename,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF102851),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Format Dokumen:',
                            style: TextStyle(
                                fontSize: 11, color: Color(0xFF78909C))),
                        Text(result.format,
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF102851))),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Cakupan Periode:',
                            style: TextStyle(
                                fontSize: 11, color: Color(0xFF78909C))),
                        Text(result.scopeLabel,
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF102851))),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Lokasi Berkas: ',
                            style: TextStyle(
                                fontSize: 11, color: Color(0xFF78909C))),
                        Expanded(
                          child: Text(
                            result.file.path,
                            style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF546E7A),
                                fontStyle: FontStyle.italic),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Actions: Buka File, Bagikan, Export Lagi
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A60D0),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () async {
                    final opened =
                        await ReportExportService.openFile(result.file);
                    if (!opened && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Berkas tersimpan di: ${result.file.path}'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.open_in_new_rounded, size: 20),
                  label: const Text(
                    'Buka Berkas Laporan',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF102851),
                          side: const BorderSide(color: Color(0xFFCFD8DC)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          ReportExportService.shareFile(
                              result.file, result.scopeLabel);
                        },
                        icon: const Icon(Icons.share_rounded, size: 18),
                        label: const Text(
                          'Bagikan',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF1A60D0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          _showExportReportBottomSheet(context);
                        },
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: const Text(
                          'Ekspor Lagi',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showExportErrorModal(
      BuildContext context, dynamic error, VoidCallback onRetry) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.error_outline_rounded, color: Color(0xFFD32F2F), size: 28),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Gagal Membuat Laporan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: const Text(
          'Terjadi kendala saat menyusun atau menyimpan berkas laporan. Pastikan ruang penyimpanan perangkat mencukupi.',
          style: TextStyle(fontSize: 13, color: Color(0xFF546E7A)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A60D0),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              onRetry();
            },
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Coba Lagi',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
