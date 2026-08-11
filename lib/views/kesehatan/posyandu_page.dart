import 'package:flutter/material.dart';

class PosyanduPage extends StatefulWidget {
  final String? keluargaId;
  final String? namaKepalaKeluarga;

  const PosyanduPage({
    super.key,
    this.keluargaId,
    this.namaKepalaKeluarga,
  });

  @override
  State<PosyanduPage> createState() => _PosyanduPageState();
}

class _PosyanduPageState extends State<PosyanduPage> {
  final _formKey = GlobalKey<FormState>();

  // Card 1: Pasangan Usia Subur (PUS) & KB
  bool _isPus = true;
  String? _selectedMetodeKb = 'Suntik';

  // Card 2: Kesehatan Ibu Hamil
  bool _hasIbuHamil = false;
  final _usiaKehamilanController = TextEditingController(text: '4');
  bool _hasBukuKia = true;

  // Card 3: Data Bayi & Balita
  bool _hasBalita = true;
  bool _isAktifPosyandu = true;
  String? _selectedStatusImunisasi = 'Lengkap';

  bool _isSaving = false;

  final List<String> _metodeKbOptions = [
    'Pil',
    'Suntik',
    'IUD',
    'Implant',
    'Kondom',
    'MOW / MOP',
    'Tidak Ikut KB',
  ];

  final List<String> _statusImunisasiOptions = [
    'Lengkap',
    'Belum Lengkap',
    'Tidak Diimunisasi',
  ];

  @override
  void dispose() {
    _usiaKehamilanController.dispose();
    super.dispose();
  }

  Future<void> _simpanDataKesehatan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    // Simulasi penyiapan / penyimpanan data ke server
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
                'Data kesehatan & Posyandu (KIA) berhasil disimpan!',
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
      'pus': _isPus,
      'metodeKb': _isPus ? _selectedMetodeKb : null,
      'ibuHamil': _hasIbuHamil,
      'usiaKehamilan': _hasIbuHamil ? _usiaKehamilanController.text.trim() : null,
      'bukuKia': _hasIbuHamil ? _hasBukuKia : null,
      'balita': _hasBalita,
      'aktifPosyandu': _hasBalita ? _isAktifPosyandu : null,
      'statusImunisasi': _hasBalita ? _selectedStatusImunisasi : null,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Kesehatan & Posyandu (KIA)',
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

              // ── Card 1: Pasangan Usia Subur (PUS) & KB ─────────────────────
              _buildCardPusKb(),
              const SizedBox(height: 16),

              // ── Card 2: Kesehatan Ibu Hamil ────────────────────────────────
              _buildCardIbuHamil(),
              const SizedBox(height: 16),

              // ── Card 3: Data Bayi & Balita ─────────────────────────────────
              _buildCardBalita(),
              const SizedBox(height: 24),

              // ── Tombol Simpan Data Kesehatan ───────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _simpanDataKesehatan,
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
                    _isSaving ? 'Menyimpan Data...' : 'Simpan Data Kesehatan',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFCE4EC),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.medical_services_rounded,
              color: Color(0xFFD81B60),
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kesehatan & Posyandu',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF102851),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Pendataan PUS, Akseptor KB, Ibu Hamil & Kesehatan Balita',
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
        borderRadius: BorderRadius.circular(14),
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

  // ── Card 1: Pasangan Usia Subur (PUS) & KB ─────────────────────────────────
  Widget _buildCardPusKb() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
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
                child: const Icon(Icons.favorite_rounded,
                    color: Color(0xFF1565C0), size: 20),
              ),
              const SizedBox(width: 10),
              const Text(
                'Pasangan Usia Subur (PUS) & KB',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF102851),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Switch PUS
          _buildSwitchTile(
            title: 'Apakah Pasangan Usia Subur (PUS)?',
            subtitle: 'Pasangan suami istri usia 15–49 tahun',
            value: _isPus,
            onChanged: (val) => setState(() => _isPus = val),
          ),

          // Conditional Dropdown KB
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isPus
                ? Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Metode Kontrasepsi (KB) *',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF102851),
                          ),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedMetodeKb,
                          decoration: _buildInputDecoration(
                            hint: 'Pilih Metode KB',
                            icon: Icons.health_and_safety_rounded,
                          ),
                          items: _metodeKbOptions
                              .map((kb) => DropdownMenuItem(
                                    value: kb,
                                    child: Text(kb),
                                  ))
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _selectedMetodeKb = val),
                          validator: (val) => _isPus && val == null
                              ? 'Metode KB wajib dipilih'
                              : null,
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  // ── Card 2: Kesehatan Ibu Hamil ────────────────────────────────────────────
  Widget _buildCardIbuHamil() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
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
                  color: const Color(0xFFFCE4EC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.pregnant_woman_rounded,
                    color: Color(0xFFD81B60), size: 20),
              ),
              const SizedBox(width: 10),
              const Text(
                'Kesehatan Ibu Hamil',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF102851),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Switch Ibu Hamil
          _buildSwitchTile(
            title: 'Terdapat Ibu Hamil di keluarga ini?',
            subtitle: 'Pemeriksaan kehamilan & buku KIA',
            value: _hasIbuHamil,
            onChanged: (val) => setState(() => _hasIbuHamil = val),
          ),

          // Conditional Input Ibu Hamil
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _hasIbuHamil
                ? Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Usia Kehamilan (Bulan) *',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF102851),
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _usiaKehamilanController,
                          keyboardType: TextInputType.number,
                          decoration: _buildInputDecoration(
                            hint: 'Masukkan usia kehamilan dalam bulan',
                            icon: Icons.calendar_month_rounded,
                          ),
                          validator: (val) {
                            if (_hasIbuHamil) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Usia kehamilan wajib diisi';
                              }
                              final int? bulan = int.tryParse(val.trim());
                              if (bulan == null || bulan < 1 || bulan > 10) {
                                return 'Masukkan bulan antara 1 s.d 10';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // Switch Buku KIA
                        _buildSwitchTile(
                          title: 'Memiliki Buku KIA / Pemeriksaan Rutin?',
                          subtitle: 'Buku Kesehatan Ibu dan Anak dari fasilitas kesehatan',
                          value: _hasBukuKia,
                          onChanged: (val) => setState(() => _hasBukuKia = val),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  // ── Card 3: Data Bayi & Balita ─────────────────────────────────────────────
  Widget _buildCardBalita() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
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
                child: const Icon(Icons.child_care_rounded,
                    color: Color(0xFFE65100), size: 20),
              ),
              const SizedBox(width: 10),
              const Text(
                'Data Bayi & Balita',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF102851),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Switch Balita
          _buildSwitchTile(
            title: 'Terdapat Bayi / Balita?',
            subtitle: 'Anak berusia 0 s.d. 5 tahun',
            value: _hasBalita,
            onChanged: (val) => setState(() => _hasBalita = val),
          ),

          // Conditional Input Balita
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _hasBalita
                ? Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Switch Penimbangan Posyandu
                        _buildSwitchTile(
                          title: 'Aktif menimbang ke Posyandu setiap bulan?',
                          subtitle: 'Pemantauan tumbuh kembang bulanan',
                          value: _isAktifPosyandu,
                          onChanged: (val) =>
                              setState(() => _isAktifPosyandu = val),
                        ),
                        const SizedBox(height: 14),

                        // Dropdown Status Imunisasi
                        const Text(
                          'Status Imunisasi Dasar *',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF102851),
                          ),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedStatusImunisasi,
                          decoration: _buildInputDecoration(
                            hint: 'Pilih Status Imunisasi',
                            icon: Icons.vaccines_rounded,
                          ),
                          items: _statusImunisasiOptions
                              .map((im) => DropdownMenuItem(
                                    value: im,
                                    child: Text(im),
                                  ))
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _selectedStatusImunisasi = val),
                          validator: (val) => _hasBalita && val == null
                              ? 'Status Imunisasi wajib dipilih'
                              : null,
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  // ── Helper Widgets ──────────────────────────────────────────────────────────
  Widget _buildSwitchTile({
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
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: value
              ? const Color(0xFF1565C0).withValues(alpha: 0.3)
              : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        activeThumbColor: const Color(0xFF1565C0),
        activeTrackColor: const Color(0xFF1565C0).withValues(alpha: 0.3),
        inactiveThumbColor: Colors.grey.shade400,
        inactiveTrackColor: Colors.grey.shade200,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 13,
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

  InputDecoration _buildInputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
      prefixIcon: Icon(icon, color: const Color(0xFF1565C0), size: 20),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1565C0), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD32F2F)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 1.5),
      ),
    );
  }
}
