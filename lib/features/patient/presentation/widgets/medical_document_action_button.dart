import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/services/medical_document_service.dart';
import '../../../../core/widgets/app_button.dart';

enum MedicalDocumentAction { save, share }

class MedicalDocumentActionButton extends StatefulWidget {
  const MedicalDocumentActionButton({
    super.key,
    required this.service,
    required this.createPdf,
    required this.fileName,
    required this.title,
    required this.action,
    required this.buttonText,
    required this.icon,
    this.isOutlined = false,
  });

  final MedicalDocumentService service;
  final Future<File> Function() createPdf;
  final String fileName;
  final String title;
  final MedicalDocumentAction action;
  final String buttonText;
  final IconData icon;
  final bool isOutlined;

  @override
  State<MedicalDocumentActionButton> createState() =>
      _MedicalDocumentActionButtonState();
}

class _MedicalDocumentActionButtonState
    extends State<MedicalDocumentActionButton> {
  bool _isWorking = false;

  Future<void> _runAction() async {
    if (_isWorking) return;
    setState(() => _isWorking = true);
    var message = 'تعذر إنشاء الملف. حاول مرة أخرى.';
    try {
      final file = await widget.createPdf();
      if (widget.action == MedicalDocumentAction.save) {
        final savedPath =
            await widget.service.saveWithNativePicker(file, widget.fileName);
        message = savedPath == null
            ? 'أُلغيت عملية حفظ الملف.'
            : 'تم حفظ ملف PDF على الجهاز.';
      } else {
        final result =
            await widget.service.shareFile(file, title: widget.title);
        message = switch (result.status) {
          ShareResultStatus.success => 'تم فتح نافذة مشاركة الملف.',
          ShareResultStatus.dismissed => 'أُلغيت مشاركة الملف.',
          ShareResultStatus.unavailable =>
            'فُتحت المشاركة، لكن تعذر التحقق من نتيجتها.',
        };
      }
    } on Object {
      message = widget.action == MedicalDocumentAction.save
          ? 'تعذر إنشاء الملف أو حفظه. حاول مرة أخرى.'
          : 'تعذر إنشاء الملف أو فتح نافذة المشاركة. حاول مرة أخرى.';
    } finally {
      if (mounted) {
        setState(() => _isWorking = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => AppButton(
        text: widget.buttonText,
        icon: widget.icon,
        isOutlined: widget.isOutlined,
        isLoading: _isWorking,
        onPressed: _runAction,
      );
}
