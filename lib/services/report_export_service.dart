import 'dart:io';
import 'package:excel/excel.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../models/report_data.dart';

class ReportExportResult {
  final File file;
  final String filename;
  final String format;
  final String scopeLabel;

  const ReportExportResult({
    required this.file,
    required this.filename,
    required this.format,
    required this.scopeLabel,
  });
}

class ReportExportService {
  static const monthNames = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];

  /// Calculates dynamic period label based on current date and scope type.
  static String calculateScopeLabel(String scopeType, DateTime date) {
    final year = date.year;
    if (scopeType == 'bulan') {
      final monthName = monthNames[date.month - 1];
      return '$monthName $year';
    } else if (scopeType == 'triwulan') {
      final quarter = ((date.month - 1) ~/ 3) + 1;
      return 'Triwulan $quarter (Q$quarter $year)';
    } else {
      return 'Tahun $year';
    }
  }

  /// Generates clean platform-safe filenames without special characters.
  static String generateFilename(
      String format, String scopeType, DateTime date) {
    final year = date.year;
    final extension = format.toLowerCase() == 'pdf' ? 'pdf' : 'xlsx';

    String periodTag;
    if (scopeType == 'bulan') {
      periodTag = '${monthNames[date.month - 1]}_$year';
    } else if (scopeType == 'triwulan') {
      final quarter = ((date.month - 1) ~/ 3) + 1;
      periodTag = 'Q${quarter}_$year';
    } else {
      periodTag = 'Tahun_$year';
    }

    return 'PKKITA_Rekapitulasi_$periodTag.$extension';
  }

  /// Exports real binary PDF document
  static Future<ReportExportResult> exportPdf(ReportData data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header Banner
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(16),
                decoration: const pw.BoxDecoration(
                  color: PdfColors.blue800,
                  borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'PKKITA - LAPORAN REKAPITULASI DASAWISMA',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Tim Penggerak PKK Kabupaten Tasikmalaya',
                      style: const pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Metadata Table
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Kelompok Dasawisma: ${data.dasawismaName}',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                        pw.Text('Periode: ${data.scopeLabel}',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                      ],
                    ),
                    pw.SizedBox(height: 4),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Desa / Kelurahan: ${data.kelurahan}', style: const pw.TextStyle(fontSize: 10)),
                        pw.Text('Petugas Kader: ${data.cadreName}', style: const pw.TextStyle(fontSize: 10)),
                      ],
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Tanggal Diterbitkan: ${data.generatedAt.day} ${monthNames[data.generatedAt.month - 1]} ${data.generatedAt.year}',
                      style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Summary Statistics Section
              pw.Text('1. Ringkasan Data Utama',
                  style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.TableHelper.fromTextArray(
                headers: ['Indikator Utama', 'Jumlah / Cakupan', 'Keterangan'],
                data: [
                  ['Total Kepala Keluarga (KK)', '${data.totalKk} KK', 'Terdaftar di Melati 01'],
                  ['Total Anggota Warga', '${data.totalWarga} Jiwa', 'Seluruh Anggota KK'],
                  ['Cakupan Rumah Sehat', '${data.rumahSehatPercent}%', 'Kriteria Sanitasi & Ventilasi'],
                  ['Cakupan Jamban Sehat', '${data.jambanSehatPercent}%', 'Fasilitas Sanitasi Layak'],
                ],
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.blue700),
                cellHeight: 24,
                cellStyle: const pw.TextStyle(fontSize: 10),
              ),
              pw.SizedBox(height: 20),

              // Demographics & Vulnerable Groups Section
              pw.Text('2. Demografi & Kelompok Rentan',
                  style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.TableHelper.fromTextArray(
                headers: ['Kategori Populer', 'Jumlah (Jiwa)', 'Persentase / Status'],
                data: [
                  ['Warga Laki-Laki', '${data.maleWargaCount}', '${((data.maleWargaCount / data.totalWarga) * 100).toStringAsFixed(1)}%'],
                  ['Warga Perempuan', '${data.femaleWargaCount}', '${((data.femaleWargaCount / data.totalWarga) * 100).toStringAsFixed(1)}%'],
                  ['Anak Balita (0-5 thn)', '${data.balitaCount}', 'Pemantauan Posyandu Routine'],
                  ['Ibu Hamil (KIA)', '${data.ibuHamilCount}', 'Pemantauan Risiko Tinggi'],
                  ['Warga Lansia (>60 thn)', '${data.lansiaCount}', 'Layanan Posyandu Lansia'],
                ],
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.teal700),
                cellHeight: 24,
                cellStyle: const pw.TextStyle(fontSize: 10),
              ),
              pw.Spacer(),

              // Footer Signature Line
              pw.Divider(color: PdfColors.grey400),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Dokumen Resmi Sistem PKKITA Dasawisma',
                      style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                  pw.Text('Halaman 1 dari 1',
                      style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                ],
              ),
            ],
          );
        },
      ),
    );

    final bytes = await pdf.save();
    final filename = generateFilename('pdf', data.scopeType, data.generatedAt);
    final file = await saveReportFile(filename, bytes);

    return ReportExportResult(
      file: file,
      filename: filename,
      format: 'PDF',
      scopeLabel: data.scopeLabel,
    );
  }

  /// Exports real binary Excel (.xlsx) workbook with multi-sheets
  static Future<ReportExportResult> exportExcel(ReportData data) async {
    final excel = Excel.createExcel();

    // Sheet 1: Ringkasan
    final Sheet summarySheet = excel['Ringkasan'];
    summarySheet.appendRow([
      TextCellValue('LAPORAN REKAPITULASI DASAWISMA PKKITA'),
    ]);
    summarySheet.appendRow([
      TextCellValue('Kabupaten Tasikmalaya - Kelompok ${data.dasawismaName}'),
    ]);
    summarySheet.appendRow([
      TextCellValue('Periode: ${data.scopeLabel}'),
    ]);
    summarySheet.appendRow([]); // Empty row separator

    summarySheet.appendRow([
      TextCellValue('Indikator Utama'),
      TextCellValue('Nilai'),
      TextCellValue('Satuan / Keterangan'),
    ]);
    summarySheet.appendRow([
      TextCellValue('Total Kepala Keluarga (KK)'),
      IntCellValue(data.totalKk),
      TextCellValue('Keluarga'),
    ]);
    summarySheet.appendRow([
      TextCellValue('Total Anggota Warga'),
      IntCellValue(data.totalWarga),
      TextCellValue('Jiwa'),
    ]);
    summarySheet.appendRow([
      TextCellValue('Cakupan Rumah Sehat'),
      DoubleCellValue(data.rumahSehatPercent),
      TextCellValue('%'),
    ]);
    summarySheet.appendRow([
      TextCellValue('Cakupan Jamban Sehat'),
      DoubleCellValue(data.jambanSehatPercent),
      TextCellValue('%'),
    ]);

    // Sheet 2: Demografi
    final Sheet demoSheet = excel['Demografi'];
    demoSheet.appendRow([
      TextCellValue('Kategori Warga'),
      TextCellValue('Jumlah Jiwa'),
      TextCellValue('Keterangan'),
    ]);
    demoSheet.appendRow([
      TextCellValue('Warga Laki-Laki'),
      IntCellValue(data.maleWargaCount),
      TextCellValue('Demografi Gender'),
    ]);
    demoSheet.appendRow([
      TextCellValue('Warga Perempuan'),
      IntCellValue(data.femaleWargaCount),
      TextCellValue('Demografi Gender'),
    ]);
    demoSheet.appendRow([
      TextCellValue('Balita (0-5 Tahun)'),
      IntCellValue(data.balitaCount),
      TextCellValue('Kelompok Rentan KIA'),
    ]);
    demoSheet.appendRow([
      TextCellValue('Ibu Hamil'),
      IntCellValue(data.ibuHamilCount),
      TextCellValue('Kelompok Rentan KIA'),
    ]);
    demoSheet.appendRow([
      TextCellValue('Lansia (>60 Tahun)'),
      IntCellValue(data.lansiaCount),
      TextCellValue('Kelompok Rentan Kesehatan'),
    ]);

    // Sheet 3: Sanitasi
    final Sheet sanitasiSheet = excel['Sanitasi'];
    sanitasiSheet.appendRow([
      TextCellValue('Parameter Lingkungan'),
      TextCellValue('Hasil Evaluasi'),
    ]);
    sanitasiSheet.appendRow([
      TextCellValue('Persentase Rumah Sehat'),
      TextCellValue('${data.rumahSehatPercent}%'),
    ]);
    sanitasiSheet.appendRow([
      TextCellValue('Persentase Jamban Layak'),
      TextCellValue('${data.jambanSehatPercent}%'),
    ]);
    sanitasiSheet.appendRow([
      TextCellValue('Sumber Air Clean/PDAM'),
      TextCellValue('Terdaftar & Terverifikasi'),
    ]);

    // Remove default sheet if present and redundant
    if (excel.sheets.containsKey('Sheet1')) {
      excel.delete('Sheet1');
    }

    final bytes = excel.save();
    final filename = generateFilename('xlsx', data.scopeType, data.generatedAt);
    final file = await saveReportFile(filename, bytes!);

    return ReportExportResult(
      file: file,
      filename: filename,
      format: 'Excel',
      scopeLabel: data.scopeLabel,
    );
  }

  /// Platform-safe file saving logic
  static Future<File> saveReportFile(String filename, List<int> bytes) async {
    Directory directory;
    try {
      directory = await getApplicationDocumentsDirectory();
    } on Object catch (_) {
      directory = Directory.systemTemp;
    }

    final filePath = '${directory.path}${Platform.pathSeparator}$filename';
    final file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  /// Opens generated file using platform-supported handler
  static Future<bool> openFile(File file) async {
    try {
      if (!await file.exists()) return false;
      final result = await OpenFile.open(file.path);
      return result.type == ResultType.done;
    } catch (_) {
      return false;
    }
  }

  /// Shares generated file using native platform share sheet
  static Future<bool> shareFile(File file, String title) async {
    try {
      if (!await file.exists()) return false;
      final xFile = XFile(file.path);
      final result = await Share.shareXFiles(
        [xFile],
        text: 'Laporan Rekapitulasi PKKITA Dasawisma — $title',
      );
      return result.status == ShareResultStatus.success;
    } catch (_) {
      return false;
    }
  }
}
