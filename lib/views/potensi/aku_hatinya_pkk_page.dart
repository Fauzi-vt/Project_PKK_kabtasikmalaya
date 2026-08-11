import 'package:flutter/material.dart';

class AkuHatinyaPKKPage extends StatefulWidget {
  final String? keluargaId;
  final String? namaKepalaKeluarga;

  const AkuHatinyaPKKPage({
    super.key,
    this.keluargaId,
    this.namaKepalaKeluarga,
  });

  @override
  State<AkuHatinyaPKKPage> createState() => _AkuHatinyaPKKPageState();
}

class _AkuHatinyaPKKPageState extends State<AkuHatinyaPKKPage> {
  final _formKey = GlobalKey<FormState>();

  // State untuk 3 SwitchListTile
  bool _hasToga = true;
  bool _hasWarungHidup = true;
  bool _hasPeternakanKolam = false;

  // Controller untuk Keterangan Tambahan opsional
  final _keteranganController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _keteranganController.dispose();
    super.dispose();
  }

  Future<void> _simpanDataPotensi() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    // Simulasi penyimpanan data ke backend
    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;

    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Data potensi pekarangan (Aku Hatinya PKK) berhasil disimpan!',
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

    Navigator.pop(context, {
      'toga': _hasToga,
      'warungHidup': _hasWarungHidup,
      'peternakanKolam': _hasPeternakanKolam,
      'keterangan': _keteranganController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FA),
      appBar: AppBar(
        title: const Text(
          'Aku Hatinya PKK',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header Card ────────────────────────────────────────────────
              _buildHeaderCard(),
              const SizedBox(height: 16),

              // Banner Informasi KK jika dipassing
              if (widget.namaKepalaKeluarga != null || widget.keluargaId != null) ...[
                _buildKkBanner(),
                const SizedBox(height: 16),
              ],

              // ── Form Input Interaktif ──────────────────────────────────────
              Container(
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
                    const Text(
                      'Form Pemanfaatan Pekarangan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF102851),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Aktifkan sakelar jika keluarga memiliki pemanfaatan berikut',
                      style: TextStyle(fontSize: 12, color: Color(0xFF78909C)),
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: Color(0xFFE2E8F0)),
                    const SizedBox(height: 10),

                    // 1. TOGA (Tanaman Obat Keluarga)
                    _buildSwitchItem(
                      title: 'TOGA (Tanaman Obat Keluarga)',
                      subtitle: 'Kunyit, Jahe, Kencur, Temulawak, Sirih, Lidah Buaya, dll.',
                      icon: Icons.eco_rounded,
                      iconColor: const Color(0xFF2E7D32),
                      value: _hasToga,
                      onChanged: (val) => setState(() => _hasToga = val),
                    ),
                    const SizedBox(height: 10),

                    // 2. Warung Hidup (Sayur / Bumbu)
                    _buildSwitchItem(
                      title: 'Warung Hidup (Sayur & Bumbu)',
                      subtitle: 'Cabai, Tomat, Terong, Sawi, Kangkung, Daun Bawang, dll.',
                      icon: Icons.grass_rounded,
                      iconColor: const Color(0xFF1565C0),
                      value: _hasWarungHidup,
                      onChanged: (val) => setState(() => _hasWarungHidup = val),
                    ),
                    const SizedBox(height: 10),

                    // 3. Peternakan / Kolam Ikan
                    _buildSwitchItem(
                      title: 'Peternakan & Kolam Pekarangan',
                      subtitle: 'Ayam, Bebek, Kelinci, Kolam Lele, Nila, Gurame, dll.',
                      icon: Icons.pets_rounded,
                      iconColor: const Color(0xFFE65100),
                      value: _hasPeternakanKolam,
                      onChanged: (val) =>
                          setState(() => _hasPeternakanKolam = val),
                    ),
                    const SizedBox(height: 20),

                    const Divider(height: 1, color: Color(0xFFE2E8F0)),
                    const SizedBox(height: 16),

                    // 4. Keterangan Tambahan Opsional
                    const Text(
                      'Keterangan Tambahan (Opsional)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF102851),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Catat rincian jenis tanaman, jumlah pot, atau jenis ternak',
                      style: TextStyle(fontSize: 11, color: Color(0xFF78909C)),
                    ),
                    const SizedBox(height: 10),

                    TextFormField(
                      controller: _keteranganController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText:
                            'Contoh: Menanam 10 pot cabai rawit, 5 jahe merah, dan memiliki kolam lele 50 ekor.',
                        hintStyle: TextStyle(
                            color: Colors.grey.shade400, fontSize: 13),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(bottom: 40),
                          child: Icon(Icons.notes_rounded,
                              color: Color(0xFF1565C0), size: 20),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide:
                              const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide:
                              const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                              color: Color(0xFF1565C0), width: 1.5),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Tombol Simpan Data Potensi ───────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _isSaving ? null : _simpanDataPotensi,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              const Color(0xFF1565C0).withValues(alpha: 0.6),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: _isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Icon(Icons.save_rounded, size: 20),
                        label: Text(
                          _isSaving ? 'Menyimpan Data...' : 'Simpan Data',
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
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header Card ────────────────────────────────────────────────────────────
  Widget _buildHeaderCard() {
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.yard_rounded,
              color: Color(0xFF2E7D32),
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aku Hatinya PKK',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF102851),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Amalkan dan Kukuhkan Halaman Asri Teratur Indah dan Nyaman',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF78909C),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── KK Banner ──────────────────────────────────────────────────────────────
  Widget _buildKkBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBDEFB)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1565C0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.home_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Keluarga Sasaran Pendataan',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF546E7A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.namaKepalaKeluarga != null
                      ? '${widget.namaKepalaKeluarga} (${widget.keluargaId ?? 'KK'})'
                      : 'ID KK: ${widget.keluargaId ?? 'KK-001'}',
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
    );
  }

  // ── SwitchListTile Item Widget ──────────────────────────────────────────────
  Widget _buildSwitchItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: value
            ? const Color(0xFF1565C0).withValues(alpha: 0.04)
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: value
              ? const Color(0xFF1565C0).withValues(alpha: 0.3)
              : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        activeThumbColor: const Color(0xFF1565C0),
        activeTrackColor: const Color(0xFF1565C0).withValues(alpha: 0.3),
        inactiveThumbColor: Colors.grey.shade400,
        inactiveTrackColor: Colors.grey.shade200,
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: value ? const Color(0xFF102851) : const Color(0xFF546E7A),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF78909C),
            ),
          ),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
