/// Model untuk data Anggota Keluarga (Warga) dalam satu KK.
class AnggotaKeluarga {
  final String id;
  final String nama;
  final String nik;
  final String statusHubungan; // Kepala Keluarga, Istri, Anak, dll
  final String jenisKelamin;   // L / P
  final int usia;
  final String statusKhusus;   // '', 'Balita', 'Ibu Hamil', 'Lansia'

  const AnggotaKeluarga({
    required this.id,
    required this.nama,
    required this.nik,
    required this.statusHubungan,
    required this.jenisKelamin,
    required this.usia,
    this.statusKhusus = '',
  });

  factory AnggotaKeluarga.fromMap(Map<String, dynamic> map) {
    return AnggotaKeluarga(
      id: map['id'] as String? ?? '',
      nama: map['nama'] as String? ?? '-',
      nik: map['nik'] as String? ?? '-',
      statusHubungan: map['statusHubungan'] as String? ?? '-',
      jenisKelamin: map['jenisKelamin'] as String? ?? 'L',
      usia: map['usia'] as int? ?? 0,
      statusKhusus: map['statusKhusus'] as String? ?? '',
    );
  }
}
