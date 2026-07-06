import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/patient_detail_cubit.dart';

Future<void> showAddLabResultDialog(
  BuildContext context,
  PatientDetailCubit cubit,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom + AppSpacing.lg,
        ),
        child: _AddLabResultForm(cubit: cubit),
      );
    },
  );
}

class _AddLabResultForm extends StatefulWidget {
  const _AddLabResultForm({required this.cubit});

  final PatientDetailCubit cubit;

  @override
  State<_AddLabResultForm> createState() => _AddLabResultFormState();
}

class _AddLabResultFormState extends State<_AddLabResultForm> {
  final _formKey = GlobalKey<FormState>();
  final _testNameController = TextEditingController();
  final _labNameController = TextEditingController(
    text: 'مخبر مشفى دمشق الجامعي',
  );
  final _summaryController = TextEditingController();
  final _recommendationController = TextEditingController();
  final _doctorNotesController = TextEditingController();

  @override
  void dispose() {
    _testNameController.dispose();
    _labNameController.dispose();
    _summaryController.dispose();
    _recommendationController.dispose();
    _doctorNotesController.dispose();
    super.dispose();
  }

  String? _required(String? value) =>
      (value == null || value.trim().isEmpty) ? 'مطلوب' : null;

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.cubit.addLabResult(
      testName: _testNameController.text.trim(),
      labName: _labNameController.text.trim(),
      summary: _summaryController.text.trim(),
      recommendation: _recommendationController.text.trim(),
      doctorNotes: _doctorNotesController.text.trim(),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('نتيجة تحليل جديدة', style: AppTextStyles.titleMedium),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _testNameController,
              label: 'اسم التحليل',
              hint: 'مثال: CBC + Vitamin D',
              validator: _required,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _labNameController,
              label: 'المخبر أو المشفى',
              validator: _required,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _summaryController,
              label: 'ملخص النتيجة',
              maxLines: 2,
              validator: _required,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _recommendationController,
              label: 'التوصية',
              maxLines: 2,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _doctorNotesController,
              label: 'ملاحظات الطبيب (اختياري)',
              maxLines: 2,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(text: 'حفظ النتيجة', onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
