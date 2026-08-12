/// Container model for report statistics data.
class ReportData {
  final String reportTitle;
  final String dasawismaName;
  final String kelurahan;
  final String kabupaten;
  final String cadreName;
  final String scopeType; // 'bulan', 'triwulan', 'tahun'
  final String scopeLabel;
  final DateTime generatedAt;

  // Main Statistics
  final int totalKk;
  final int totalWarga;
  final double rumahSehatPercent;
  final double jambanSehatPercent;

  // Demographics & Vulnerable Groups
  final int maleWargaCount;
  final int femaleWargaCount;
  final int balitaCount;
  final int ibuHamilCount;
  final int lansiaCount;

  const ReportData({
    required this.reportTitle,
    required this.dasawismaName,
    required this.kelurahan,
    required this.kabupaten,
    required this.cadreName,
    required this.scopeType,
    required this.scopeLabel,
    required this.generatedAt,
    required this.totalKk,
    required this.totalWarga,
    required this.rumahSehatPercent,
    required this.jambanSehatPercent,
    required this.maleWargaCount,
    required this.femaleWargaCount,
    required this.balitaCount,
    required this.ibuHamilCount,
    required this.lansiaCount,
  });

  /// Factory helper for standard Dasawisma statistics
  factory ReportData.fromDasawisma({
    required String cadreName,
    required String scopeType,
    required String scopeLabel,
  }) {
    return ReportData(
      reportTitle: 'Laporan Rekapitulasi Data Dasawisma',
      dasawismaName: 'Melati 01',
      kelurahan: 'Mekar Jaya',
      kabupaten: 'Kabupaten Tasikmalaya',
      cadreName: cadreName,
      scopeType: scopeType,
      scopeLabel: scopeLabel,
      generatedAt: DateTime.now(),
      totalKk: 142,
      totalWarga: 518,
      rumahSehatPercent: 88.7,
      jambanSehatPercent: 94.4,
      maleWargaCount: 245,
      femaleWargaCount: 273,
      balitaCount: 38,
      ibuHamilCount: 14,
      lansiaCount: 52,
    );
  }
}
