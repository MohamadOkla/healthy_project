import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../../../../core/theme/app_spacing.dart';

class EditHealthInfoSheet extends StatefulWidget {
  const EditHealthInfoSheet();

  @override
  State<EditHealthInfoSheet> createState() => _EditHealthInfoSheetState();
}

class _EditHealthInfoSheetState extends State<EditHealthInfoSheet> {
  late final ProfileState _initialState = context.read<ProfileCubit>().state;
  late final _bloodController = TextEditingController(
    text: _initialState.bloodType,
  );
  late final _heightController = TextEditingController(
    text: _initialState.height,
  );
  late final _weightController = TextEditingController(
    text: _initialState.weight,
  );
  late final _allergiesController = TextEditingController(
    text: _initialState.allergies,
  );

  @override
  void dispose() {
    _bloodController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await context.read<ProfileCubit>().saveHealthInfo(
          bloodType: _bloodController.text,
          age: _initialState.age,
          gender: _initialState.gender,
          height: _heightController.text,
          weight: _weightController.text,
          allergies: _allergiesController.text,
          chronicDiseases: _initialState.chronicDiseases,
        );
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم تحديث المعلومات الصحية')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.md,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(controller: _bloodController, label: 'فصيلة الدم'),
            const SizedBox(height: AppSpacing.md),
            AppTextField(controller: _heightController, label: 'الطول'),
            const SizedBox(height: AppSpacing.md),
            AppTextField(controller: _weightController, label: 'الوزن'),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _allergiesController,
              label: 'الحساسية',
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(text: 'حفظ', onPressed: _save),
          ],
        ),
      ),
    );
  }
}
