import 'package:flutter/material.dart';

class KondisiRumahPage extends StatefulWidget {
  final String? keluargaId;
  final String? namaKepalaKeluarga;

  const KondisiRumahPage({
    super.key,
    this.keluargaId,
    this.namaKepalaKeluarga,
  });

  @override
  State<KondisiRumahPage> createState() => _KondisiRumahPageState();
}

class _KondisiRumahPageState extends State<KondisiRumahPage> {
  final _formKey = GlobalKey<FormState>();

  // State untuk 4 SwitchListTile
  bool _isRumahLayakHuni = true;
  bool _hasJambanSehat = true;
  bool _hasTempatSampah = true;
  bool _hasSpal = true;

  // State untuk Dropdown Sumber Air Bersih
  String? _selectedSumberAir = 'PDAM';

  bool _isSaving = false;

  final List<String> _sumberAirOptions = [
    'PDAM',
    'Sumur Gali',
    'Sumur Bor',
    'Mata Air',
    'Sungai',
  ];

  Future<void> _simpanEvaluasi() async {
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
                'Data evaluasi kondisi rumah berhasil disimpan!',
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
      'rumahLayakHuni': _isRumahLayakHuni,
      'jambanSehat': _hasJambanSehat,
      'tempatSampah': _hasTempatSampah,
      'spal': _hasSpal,
      'sumberAir': _selectedSumberAir,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FA),
      appBar: AppBar(
        title: const Text(
          'Form Survei Kondisi Rumah',
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

              // ── Form Input Evaluasi ────────────────────────────────────────
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
                      'Poin-Poin Evaluasi Hunian',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF102851),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Aktifkan sakelar jika kriteria terpenuhi (Ya/Ada/Layak)',
                      style: TextStyle(fontSize: 12, color: Color(0xFF78909C)),
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: Color(0xFFE2E8F0)),
                    const SizedBox(height: 10),

                    // 1. Kategori Layak Huni
                    _buildSwitchItem(
                      title: 'Kategori Layak Huni (RLH)',
                      subtitle: 'Struktur kokoh, pencahayaan & ventilasi memadai',
                      value: _isRumahLayakHuni,
                      onChanged: (val) =>
                          setState(() => _isRumahLayakHuni = val),
                    ),
                    const SizedBox(height: 10),

                    // 2. Jamban Keluarga Sehat
                    _buildSwitchItem(
                      title: 'Jamban Keluarga Sehat',
                      subtitle: 'Memiliki septic tank sendiri & saniter',
                      value: _hasJambanSehat,
                      onChanged: (val) => setState(() => _hasJambanSehat = val),
                    ),
                    const SizedBox(height: 10),

                    // 3. Tempat Pembuangan Sampah
                    _buildSwitchItem(
                      title: 'Tempat Pembuangan Sampah',
                      subtitle: 'Tersedia pemilahan sampah organik & anorganik',
                      value: _hasTempatSampah,
                      onChanged: (val) =>
                          setState(() => _hasTempatSampah = val),
                    ),
                    const SizedBox(height: 10),

                    // 4. Saluran Pembuangan Air (SPAL)
                    _buildSwitchItem(
                      title: 'Saluran Pembuangan Air (SPAL)',
                      subtitle: 'SPAL tertutup, tidak tergenang & lancar',
                      value: _hasSpal,
                      onChanged: (val) => setState(() => _hasSpal = val),
                    ),
                    const SizedBox(height: 20),

                    const Divider(height: 1, color: Color(0xFFE2E8F0)),
                    const SizedBox(height: 16),

                    // 5. Dropdown Sumber Air Bersih
                    const Text(
                      'Sumber Air Bersih Utama *',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF102851),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Pilih sumber pasokan air yang digunakan sehari-hari',
                      style: TextStyle(fontSize: 11, color: Color(0xFF78909C)),
                    ),
                    const SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      initialValue: _selectedSumberAir,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.water_drop_rounded,
                            color: Color(0xFF1565C0), size: 22),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                              color: Color(0xFF1565C0), width: 1.5),
                        ),
                      ),
                      items: _sumberAirOptions
                          .map((air) => DropdownMenuItem(
                                value: air,
                                child: Text(
                                  air,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF102851),
                                  ),
                                ),
                              ))
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _selectedSumberAir = val),
                      validator: (val) =>
                          val == null ? 'Sumber air wajib dipilih' : null,
                    ),

                    const SizedBox(height: 28),

                    // ── Tombol Simpan Data Evaluasi ──────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _isSaving ? null : _simpanEvaluasi,
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
                          _isSaving
                              ? 'Menyimpan Data...'
                              : 'Simpan Data Evaluasi',
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
              color: const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.home_work_rounded,
              color: Color(0xFFD32F2F),
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Evaluasi Kondisi Rumah',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF102851),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Kriteria Kelayakan Hunian & Sanitasi Lingkungan',
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
                  'Keluarga Sasaran Survei',
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        activeThumbColor: const Color(0xFF1565C0),
        activeTrackColor: const Color(0xFF1565C0).withValues(alpha: 0.3),
        inactiveThumbColor: Colors.grey.shade400,
        inactiveTrackColor: Colors.grey.shade200,
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
