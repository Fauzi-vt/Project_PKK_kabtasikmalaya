import 'package:flutter/material.dart';

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_rounded,
                color: Colors.white, size: 24),
            tooltip: 'Unduh Laporan',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.picture_as_pdf_rounded, color: Colors.white),
                      SizedBox(width: 10),
                      Text('Simulasi ekspor laporan PDF berhasil disiapkan'),
                    ],
                  ),
                  backgroundColor: const Color(0xFF1A60D0),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
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
}
