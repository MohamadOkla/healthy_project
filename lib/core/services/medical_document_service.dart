import 'dart:io';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../features/laboratory/domain/entities/lab_result_entry.dart';
import '../../features/medical_records/domain/entities/medical_record_entry.dart';
import '../../features/prescriptions/domain/entities/prescription_entry.dart';

/// Creates PDFs from the currently displayed medical data and keeps them local.
class MedicalDocumentService {
  MedicalDocumentService({Directory? temporaryDirectory})
      : _temporaryDirectory = temporaryDirectory;

  static const _fontAsset = 'assets/fonts/NotoNaskhArabic-Regular.ttf';
  static const _latinFontAsset = 'assets/fonts/NotoSans-Regular.ttf';
  static final _leftToRightRun = RegExp(r'[A-Za-z0-9][A-Za-z0-9._:/+\-]*');
  final Directory? _temporaryDirectory;

  Future<File> createMedicalRecordPdf(MedicalRecordEntry record) => _createPdf(
        prefix: 'medical_record',
        id: record.id,
        title: 'السجل الطبي',
        fields: [
          ('رقم السجل', record.id),
          ('الطبيب', record.doctorName),
          ('الاختصاص', record.specialty),
          ('المشفى', record.hospital),
          ('تاريخ الزيارة', record.visitDate),
          ('التشخيص', record.diagnosis),
          ('الأعراض', record.symptoms),
          ('ملاحظات الطبيب', record.doctorNotes),
          if (record.vitals.isNotEmpty)
            (
              'العلامات الحيوية',
              record.vitals.map((item) => '${item.$1}: ${item.$2}').join('\n')
            ),
          if (record.medications.isNotEmpty)
            ('الأدوية', record.medications.join('\n')),
          if (record.testsRequired.isNotEmpty)
            ('الفحوص المطلوبة', record.testsRequired.join('\n')),
        ],
      );

  Future<File> createPrescriptionPdf(PrescriptionEntry prescription) =>
      _createPdf(
        prefix: 'prescription',
        id: prescription.id,
        title: 'الوصفة الطبية',
        fields: [
          ('رقم الوصفة', prescription.id),
          ('الطبيب', prescription.doctorName),
          ('تاريخ الإصدار', prescription.issueDate),
          ('تاريخ الانتهاء', prescription.expiryDate),
          ('الحالة', prescription.isActive ? 'نشطة' : 'غير نشطة'),
          (
            'الأدوية',
            prescription.medicines
                .map((medicine) => [
                      'الدواء: ${medicine.name}',
                      'الجرعة: ${medicine.dose}',
                      'التكرار: ${medicine.frequency}',
                      'المدة: ${medicine.duration}',
                      'التعليمات: ${medicine.instructions}',
                    ].join('\n'))
                .join('\n\n'),
          ),
          ('ملاحظات', prescription.notes),
          if (prescription.warnings.isNotEmpty)
            ('تحذيرات', prescription.warnings),
        ],
      );

  Future<File> createLabResultPdf(LabResultEntry result) => _createPdf(
        prefix: 'lab_result',
        id: result.id,
        title: 'نتيجة التحليل',
        fields: [
          ('رقم النتيجة', result.id),
          ('اسم التحليل', result.testName),
          ('تاريخ التحليل', result.testDate),
          ('المخبر', result.labName),
          ('الحالة', result.isCompleted ? 'مكتمل' : 'قيد التنفيذ'),
          ('الملخص', result.summary),
          if (result.rows.isNotEmpty)
            (
              'القياسات',
              result.rows
                  .map((row) => [
                        'الفحص: ${row.name}',
                        'النتيجة: ${row.value}',
                        'المجال الطبيعي: ${row.normalRange}',
                        'التقييم: ${row.isNormal ? 'ضمن المجال الطبيعي' : 'خارج المجال الطبيعي'}',
                      ].join('\n'))
                  .join('\n\n'),
            ),
          ('التوصيات', result.recommendation),
          if (result.doctorNotes.isNotEmpty)
            ('ملاحظات الطبيب', result.doctorNotes),
        ],
      );

  Future<String?> saveWithNativePicker(File file, String fileName) {
    final name =
        fileName.replaceFirst(RegExp(r'\.pdf$', caseSensitive: false), '');
    return FileSaver.instance.saveAs(
      name: name,
      file: file,
      fileExtension: 'pdf',
      mimeType: MimeType.pdf,
    );
  }

  Future<ShareResult> shareFile(File file, {required String title}) =>
      Share.shareXFiles(
        [
          XFile(file.path,
              mimeType: 'application/pdf', name: file.uri.pathSegments.last)
        ],
        subject: title,
        sharePositionOrigin: null,
      );

  Future<File> _createPdf({
    required String prefix,
    required String id,
    required String title,
    required List<(String, String)> fields,
  }) async {
    final fontBytes = await rootBundle.load(_fontAsset);
    final font = pw.Font.ttf(fontBytes);
    final latinFont = pw.Font.ttf(await rootBundle.load(_latinFontAsset));
    final document = pw.Document(
      theme: pw.ThemeData.withFont(
        base: font,
        bold: font,
        fontFallback: [latinFont],
      ),
    );
    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (context) => [
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                pw.Text(
                  title,
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(
                    font: font,
                    fontFallback: [latinFont],
                    fontSize: 24,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Divider(),
                for (final (label, value) in fields)
                  if (value.trim().isNotEmpty) ...[
                    pw.SizedBox(height: 10),
                    pw.Text(
                      label,
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(
                        font: font,
                        fontFallback: [latinFont],
                        fontSize: 15,
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      _preserveLeftToRightRuns(value),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(
                        font: font,
                        fontFallback: [latinFont],
                        fontSize: 13,
                      ),
                    ),
                    pw.Divider(),
                  ],
              ],
            ),
          ),
        ],
      ),
    );

    final tempDirectory = _temporaryDirectory ?? Directory.systemTemp;
    await tempDirectory.create(recursive: true);
    final file = File(
        '${tempDirectory.path}${Platform.pathSeparator}${safeFileName(prefix, id)}');
    await file.writeAsBytes(await document.save(), flush: true);
    return file;
  }

  static String safeFileName(String prefix, String id) {
    final safeId = id.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');
    return '${prefix}_${safeId.isEmpty ? 'item' : safeId}.pdf';
  }

  static String _preserveLeftToRightRuns(String value) =>
      value.replaceAllMapped(
        _leftToRightRun,
        (match) => '\u200E${match.group(0)}\u200E',
      );
}
