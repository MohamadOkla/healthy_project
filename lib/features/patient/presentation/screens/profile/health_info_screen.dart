import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_routes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../cubit/profile_cubit.dart';
import '../../cubit/profile_state.dart';

class HealthInfoScreen extends StatelessWidget {
  const HealthInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.go(AppRoutes.patientProfile),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('المعلومات الصحية'),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final items = [
            ('فصيلة الدم', state.bloodType, Icons.bloodtype_rounded),
            ('العمر', state.age, Icons.cake_rounded),
            ('الجنس', state.gender, Icons.wc_rounded),
            ('الطول', state.height, Icons.height_rounded),
            ('الوزن', state.weight, Icons.monitor_weight_rounded),
            ('الحساسية', state.allergies, Icons.warning_amber_rounded),
            (
              'الأمراض المزمنة',
              state.chronicDiseases,
              Icons.health_and_safety_rounded
            ),
          ];
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              AppCard(
                child: Column(
                  children: items
                      .map(
                        (item) => ListTile(
                          leading: Icon(item.$3, color: AppColors.primary),
                          title: Text(item.$1),
                          subtitle: Text(item.$2),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                text: 'تعديل المعلومات الصحية',
                icon: Icons.edit_rounded,
                onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (sheetContext) => BlocProvider.value(
                    value: context.read<ProfileCubit>(),
                    child: const _EditHealthInfoSheet(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EditHealthInfoSheet extends StatefulWidget {
  const _EditHealthInfoSheet();

  @override
  State<_EditHealthInfoSheet> createState() => _EditHealthInfoSheetState();
}

class _EditHealthInfoSheetState extends State<_EditHealthInfoSheet> {
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
