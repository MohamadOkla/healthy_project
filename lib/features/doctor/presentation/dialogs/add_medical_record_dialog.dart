import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/patient_detail_cubit.dart';

Future<void> showAddMedicalRecordDialog(
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
        child: _AddMedicalRecordForm(cubit: cubit),
      );
    },
  );
}

class _AddMedicalRecordForm extends StatefulWidget {
  const _AddMedicalRecordForm({required this.cubit});

  final PatientDetailCubit cubit;

  @override
  State<_AddMedicalRecordForm> createState() => _AddMedicalRecordFormState();
}

class _AddMedicalRecordFormState extends State<_AddMedicalRecordForm> {
  final _formKey = GlobalKey<FormState>();
  final _diagnosisController = TextEditingController();
  final _symptomsController = TextEditingController();
  final _notesController = TextEditingController();
  final _medicationsController = TextEditingController();
  final _testsController = TextEditingController();

  @override
  void dispose() {
    _diagnosisController.dispose();
    _symptomsController.dispose();
    _notesController.dispose();
    _medicationsController.dispose();
    _testsController.dispose();
    super.dispose();
  }

  List<String> _splitByComma(String text) {
    return text
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.cubit.addMedicalRecord(
      diagnosis: _diagnosisController.text.trim(),
      symptoms: _symptomsController.text.trim(),
      doctorNotes: _notesController.text.trim(),
      medications: _splitByComma(_medicationsController.text),
      testsRequired: _splitByComma(_testsController.text),
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
            Text('سجل طبي جديد', style: AppTextStyles.titleMedium(context)),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _diagnosisController,
              label: 'التشخيص',
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? 'مطلوب' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _symptomsController,
              label: 'الأعراض',
              maxLines: 2,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _notesController,
              label: 'ملاحظات الطبيب',
              maxLines: 3,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _medicationsController,
              label: 'الأدوية الموصوفة (افصل بينها بفاصلة)',
              hint: 'مثال: Atorvastatin 20mg مساءً, Aspirin 81mg بعد الطعام',
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _testsController,
              label: 'تحاليل مطلوبة (افصل بينها بفاصلة)',
              hint: 'مثال: CBC, Lipid Profile',
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(text: 'حفظ السجل', onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
