import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pkk_dasawisma_app/models/report_data.dart';
import 'package:pkk_dasawisma_app/services/report_export_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    const channel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return Directory.systemTemp.path;
    });
  });

  group('ReportExportService Period & Filename Logic Tests', () {
    test('calculateScopeLabel handles month, triwulan, and year correctly', () {
      final augustDate = DateTime(2026, 8, 12);

      final monthLabel =
          ReportExportService.calculateScopeLabel('bulan', augustDate);
      expect(monthLabel, equals('Agustus 2026'));

      final quarterLabel =
          ReportExportService.calculateScopeLabel('triwulan', augustDate);
      expect(quarterLabel, equals('Triwulan 3 (Q3 2026)'));

      final yearLabel =
          ReportExportService.calculateScopeLabel('tahun', augustDate);
      expect(yearLabel, equals('Tahun 2026'));
    });

    test('calculateScopeLabel calculates quarters Q1, Q2, Q3, Q4 dynamically', () {
      final q1Date = DateTime(2026, 2, 15);
      final q2Date = DateTime(2026, 5, 20);
      final q3Date = DateTime(2026, 9, 1);
      final q4Date = DateTime(2026, 11, 30);

      expect(ReportExportService.calculateScopeLabel('triwulan', q1Date),
          contains('Q1 2026'));
      expect(ReportExportService.calculateScopeLabel('triwulan', q2Date),
          contains('Q2 2026'));
      expect(ReportExportService.calculateScopeLabel('triwulan', q3Date),
          contains('Q3 2026'));
      expect(ReportExportService.calculateScopeLabel('triwulan', q4Date),
          contains('Q4 2026'));
    });

    test('generateFilename formats platform-safe PDF and XLSX filenames', () {
      final testDate = DateTime(2026, 8, 12);

      final pdfName =
          ReportExportService.generateFilename('PDF', 'bulan', testDate);
      expect(pdfName, equals('PKKITA_Rekapitulasi_Agustus_2026.pdf'));

      final excelName =
          ReportExportService.generateFilename('Excel', 'triwulan', testDate);
      expect(excelName, equals('PKKITA_Rekapitulasi_Q3_2026.xlsx'));

      final yearExcelName =
          ReportExportService.generateFilename('Excel', 'tahun', testDate);
      expect(yearExcelName, equals('PKKITA_Rekapitulasi_Tahun_2026.xlsx'));
    });
  });

  group('ReportExportService Real PDF & Excel File Generation Tests', () {
    late ReportData sampleReportData;

    setUp(() {
      sampleReportData = ReportData.fromDasawisma(
        cadreName: 'Siti Aminah, S.Pd',
        scopeType: 'bulan',
        scopeLabel: 'Agustus 2026',
      );
    });

    test('exportPdf generates valid binary PDF file on disk', () async {
      final result = await ReportExportService.exportPdf(sampleReportData);

      expect(result.format, equals('PDF'));
      expect(result.filename, equals('PKKITA_Rekapitulasi_Agustus_2026.pdf'));
      expect(result.file.existsSync(), isTrue);

      final bytes = await result.file.readAsBytes();
      expect(bytes.length, greaterThan(1000));

      // PDF specification header check
      final header = String.fromCharCodes(bytes.sublist(0, 5));
      expect(header, equals('%PDF-'));
    });

    test('exportExcel generates valid binary XLSX workbook on disk', () async {
      final result = await ReportExportService.exportExcel(sampleReportData);

      expect(result.format, equals('Excel'));
      expect(result.filename, equals('PKKITA_Rekapitulasi_Agustus_2026.xlsx'));
      expect(result.file.existsSync(), isTrue);

      final bytes = await result.file.readAsBytes();
      expect(bytes.length, greaterThan(1000));

      // ZIP / OpenXML header check (PK..)
      expect(bytes[0], equals(0x50)); // 'P'
      expect(bytes[1], equals(0x4B)); // 'K'
    });

    test('openFile and shareFile return false gracefully when file does not exist', () async {
      final dummyFile = File('non_existent_file.pdf');
      final openSuccess = await ReportExportService.openFile(dummyFile);
      expect(openSuccess, isFalse);

      final shareSuccess = await ReportExportService.shareFile(dummyFile, 'Test Title');
      expect(shareSuccess, isFalse);
    });
  });
}
