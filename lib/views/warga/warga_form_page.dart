import 'package:flutter/material.dart';

class WargaFormPage extends StatefulWidget {
  final String keluargaId;
  final String? namaKepalaKeluarga;

  const WargaFormPage({
    super.key,
    required this.keluargaId,
    this.namaKepalaKeluarga,
  });

  @override
  State<WargaFormPage> createState() => _WargaFormPageState();
}

class _WargaFormPageState extends State<WargaFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final _nikController = TextEditingController();
  final _namaController = TextEditingController();
  final _tempatLahirController = TextEditingController();
  final _pekerjaanController = TextEditingController();

  // Date selection
  DateTime? _tanggalLahir;

  // Dropdown Values
  String? _selectedJenisKelamin;
  String? _selectedAgama;
  String? _selectedPendidikan;
  String? _selectedStatusPerkawinan;
  String? _selectedStatusHubungan;

  bool _isSubmitting = false;

  // Option lists
  final List<String> _jenisKelaminOptions = ['Laki-laki', 'Perempuan'];
  final List<String> _agamaOptions = [
    'Islam',
    'Kristen',
    'Katolik',
    'Hindu',
    'Buddha',
    'Khonghucu',
    'Lainnya'
  ];
  final List<String> _pendidikanOptions = [
    'Tidak/Belum Sekolah',
    'SD / Sederajat',
    'SMP / Sederajat',
    'SMA / Sederajat',
    'Diploma III (D3)',
    'Sarjana (S1 / D4)',
    'Magister (S2)',
    'Doktor (S3)',
  ];
  final List<String> _statusPerkawinanOptions = [
    'Belum Kawin',
    'Kawin',
    'Cerai Hidup',
    'Cerai Mati',
  ];
  final List<String> _statusHubunganOptions = [
    'Kepala Keluarga',
    'Istri',
    'Anak',
    'Menantu',
    'Cucu',
    'Orang Tua',
    'Famili Lain',
  ];

  @override
  void dispose() {
    _nikController.dispose();
    _namaController.dispose();
    _tempatLahirController.dispose();
    _pekerjaanController.dispose();
    super.dispose();
  }

  Future<void> _selectTanggalLahir(BuildContext context) async {
    final DateTime initialDate = DateTime(2000, 1, 1);
    final DateTime firstDate = DateTime(1920);
    final DateTime lastDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tanggalLahir ?? initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      locale: const Locale('id', 'ID'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1A60D0),
              onPrimary: Colors.white,
              onSurface: Color(0xFF102851),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _tanggalLahir) {
      setState(() {
        _tanggalLahir = picked;
      });
    }
  }

  Future<void> _simpanDataWarga() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_tanggalLahir == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih Tanggal Lahir'),
          backgroundColor: Color(0xFFD32F2F),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Simulasi penyiapan / pengiriman data asinkron (API call)
    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    final String namaInput = _namaController.text.trim();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Berhasil menambahkan warga: $namaInput',
                style: const TextStyle(fontWeight: FontWeight.w600),
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
      'nik': _nikController.text.trim(),
      'nama': namaInput,
      'tempatLahir': _tempatLahirController.text.trim(),
      'tanggalLahir': _tanggalLahir,
      'jenisKelamin': _selectedJenisKelamin,
      'agama': _selectedAgama,
      'pendidikan': _selectedPendidikan,
      'statusPerkawinan': _selectedStatusPerkawinan,
      'statusHubungan': _selectedStatusHubungan ?? 'Anak',
      'pekerjaan': _pekerjaanController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FA),
      appBar: AppBar(
        title: const Text(
          'Form Tambah Warga',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFF1A60D0),
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
              // Banner info KK
              _buildKkBanner(),
              const SizedBox(height: 16),

              // Card Form
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
                      'Data Identitas Warga',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF102851),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Lengkapi seluruh formulir sesuai data KTP / Akta Kelahiran',
                      style: TextStyle(fontSize: 12, color: Color(0xFF78909C)),
                    ),
                    const SizedBox(height: 20),

                    // NIK
                    _buildLabel('Nomor Induk Kependudukan (NIK) *'),
                    TextFormField(
                      controller: _nikController,
                      keyboardType: TextInputType.number,
                      maxLength: 16,
                      decoration: _buildInputDecoration(
                        hint: 'Masukkan 16 digit NIK',
                        icon: Icons.credit_card_rounded,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'NIK wajib diisi';
                        }
                        if (value.trim().length != 16) {
                          return 'NIK harus terdiri dari 16 digit angka';
                        }
                        if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
                          return 'NIK hanya boleh berisi angka';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Nama Lengkap
                    _buildLabel('Nama Lengkap *'),
                    TextFormField(
                      controller: _namaController,
                      textCapitalization: TextCapitalization.words,
                      decoration: _buildInputDecoration(
                        hint: 'Contoh: Siti Aminah',
                        icon: Icons.person_rounded,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nama Lengkap wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Jenis Kelamin
                    _buildLabel('Jenis Kelamin *'),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedJenisKelamin,
                      decoration: _buildInputDecoration(
                        hint: 'Pilih Jenis Kelamin',
                        icon: Icons.wc_rounded,
                      ),
                      items: _jenisKelaminOptions
                          .map((jk) => DropdownMenuItem(
                                value: jk,
                                child: Text(jk),
                              ))
                          .toList(),
                      onChanged: (val) => setState(() => _selectedJenisKelamin = val),
                      validator: (val) => val == null ? 'Jenis Kelamin wajib dipilih' : null,
                    ),
                    const SizedBox(height: 14),

                    // Status Hubungan Dalam Keluarga
                    _buildLabel('Status Hubungan Dalam Keluarga *'),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedStatusHubungan,
                      decoration: _buildInputDecoration(
                        hint: 'Pilih Status Hubungan',
                        icon: Icons.family_restroom_rounded,
                      ),
                      items: _statusHubunganOptions
                          .map((sh) => DropdownMenuItem(
                                value: sh,
                                child: Text(sh),
                              ))
                          .toList(),
                      onChanged: (val) => setState(() => _selectedStatusHubungan = val),
                      validator: (val) => val == null ? 'Status Hubungan wajib dipilih' : null,
                    ),
                    const SizedBox(height: 14),

                    // Tempat & Tanggal Lahir
                    Row(
                      children: [
                        // Tempat Lahir
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Tempat Lahir *'),
                              TextFormField(
                                controller: _tempatLahirController,
                                textCapitalization: TextCapitalization.words,
                                decoration: _buildInputDecoration(
                                  hint: 'Tasikmalaya',
                                  icon: Icons.location_city_rounded,
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Wajib diisi';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Tanggal Lahir
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Tanggal Lahir *'),
                              InkWell(
                                onTap: () => _selectTanggalLahir(context),
                                borderRadius: BorderRadius.circular(12),
                                child: InputDecorator(
                                  decoration: _buildInputDecoration(
                                    hint: 'Pilih Tanggal',
                                    icon: Icons.calendar_today_rounded,
                                  ),
                                  child: Text(
                                    _tanggalLahir != null
                                        ? '${_tanggalLahir!.day.toString().padLeft(2, '0')}/${_tanggalLahir!.month.toString().padLeft(2, '0')}/${_tanggalLahir!.year}'
                                        : 'Tgl/Bln/Thn',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: _tanggalLahir != null
                                          ? const Color(0xFF102851)
                                          : Colors.grey.shade400,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Agama
                    _buildLabel('Agama *'),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedAgama,
                      decoration: _buildInputDecoration(
                        hint: 'Pilih Agama',
                        icon: Icons.auto_awesome_rounded,
                      ),
                      items: _agamaOptions
                          .map((a) => DropdownMenuItem(
                                value: a,
                                child: Text(a),
                              ))
                          .toList(),
                      onChanged: (val) => setState(() => _selectedAgama = val),
                      validator: (val) => val == null ? 'Agama wajib dipilih' : null,
                    ),
                    const SizedBox(height: 14),

                    // Pendidikan Terakhir
                    _buildLabel('Pendidikan Terakhir *'),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedPendidikan,
                      decoration: _buildInputDecoration(
                        hint: 'Pilih Pendidikan',
                        icon: Icons.school_rounded,
                      ),
                      items: _pendidikanOptions
                          .map((p) => DropdownMenuItem(
                                value: p,
                                child: Text(p),
                              ))
                          .toList(),
                      onChanged: (val) => setState(() => _selectedPendidikan = val),
                      validator: (val) => val == null ? 'Pendidikan wajib dipilih' : null,
                    ),
                    const SizedBox(height: 14),

                    // Pekerjaan
                    _buildLabel('Pekerjaan *'),
                    TextFormField(
                      controller: _pekerjaanController,
                      textCapitalization: TextCapitalization.words,
                      decoration: _buildInputDecoration(
                        hint: 'Contoh: Wiraswasta / Ibu Rumah Tangga',
                        icon: Icons.work_rounded,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Pekerjaan wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Status Perkawinan
                    _buildLabel('Status Perkawinan *'),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedStatusPerkawinan,
                      decoration: _buildInputDecoration(
                        hint: 'Pilih Status Perkawinan',
                        icon: Icons.favorite_rounded,
                      ),
                      items: _statusPerkawinanOptions
                          .map((sp) => DropdownMenuItem(
                                value: sp,
                                child: Text(sp),
                              ))
                          .toList(),
                      onChanged: (val) => setState(() => _selectedStatusPerkawinan = val),
                      validator: (val) => val == null ? 'Status Perkawinan wajib dipilih' : null,
                    ),
                    const SizedBox(height: 24),

                    // Tombol Simpan
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _isSubmitting ? null : _simpanDataWarga,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A60D0),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFF1A60D0).withValues(alpha: 0.6),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: _isSubmitting
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
                          _isSubmitting ? 'Menyimpan...' : 'Simpan Data Warga',
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

  // ── Helper Widgets ──────────────────────────────────────────────────────────
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
              color: const Color(0xFF1A60D0),
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
                  'Kartu Keluarga Tujuan',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF546E7A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.namaKepalaKeluarga != null
                      ? '${widget.namaKepalaKeluarga} (${widget.keluargaId})'
                      : 'ID KK: ${widget.keluargaId}',
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFF102851),
        ),
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
      prefixIcon: Icon(icon, color: const Color(0xFF1A60D0), size: 20),
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
        borderSide: const BorderSide(color: Color(0xFF1A60D0), width: 1.5),
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
