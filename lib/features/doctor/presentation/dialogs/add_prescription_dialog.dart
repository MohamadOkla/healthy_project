import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/patient_detail_cubit.dart';

Future<void> showAddPrescriptionDialog(
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
        child: _AddPrescriptionForm(cubit: cubit),
      );
    },
  );
}

class _AddPrescriptionForm extends StatefulWidget {
  const _AddPrescriptionForm({required this.cubit});

  final PatientDetailCubit cubit;

  @override
  State<_AddPrescriptionForm> createState() => _AddPrescriptionFormState();
}

class _AddPrescriptionFormState extends State<_AddPrescriptionForm> {
  final _formKey = GlobalKey<FormState>();
  final _medicineController = TextEditingController();
  final _doseController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _durationController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _expiryController = TextEditingController();
  final _notesController = TextEditingController();
  final _warningsController = TextEditingController();

  @override
  void dispose() {
    _medicineController.dispose();
    _doseController.dispose();
    _frequencyController.dispose();
    _durationController.dispose();
    _instructionsController.dispose();
    _expiryController.dispose();
    _notesController.dispose();
    _warningsController.dispose();
    super.dispose();
  }

  String? _required(String? value) =>
      (value == null || value.trim().isEmpty) ? 'مطلوب' : null;

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.cubit.addPrescription(
      medicineName: _medicineController.text.trim(),
      dose: _doseController.text.trim(),
      frequency: _frequencyController.text.trim(),
      duration: _durationController.text.trim(),
      instructions: _instructionsController.text.trim(),
      expiryDate: _expiryController.text.trim(),
      notes: _notesController.text.trim(),
      warnings: _warningsController.text.trim(),
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
            Text('وصفة طبية جديدة', style: AppTextStyles.titleMedium(context)),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _medicineController,
              label: 'اسم الدواء',
              validator: _required,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _doseController,
                    label: 'الجرعة',
                    validator: _required,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppTextField(
                    controller: _frequencyController,
                    label: 'عدد المرات',
                    validator: _required,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _durationController,
                    label: 'مدة الاستخدام',
                    validator: _required,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppTextField(
                    controller: _expiryController,
                    label: 'تاريخ انتهاء الوصفة',
                    hint: 'مثال: 5 أغسطس 2026',
                    validator: _required,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _instructionsController,
              label: 'تعليمات الاستخدام',
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _notesController,
              label: 'ملاحظات',
              maxLines: 2,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _warningsController,
              label: 'تحذيرات (اختياري)',
              maxLines: 2,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(text: 'حفظ الوصفة', onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
