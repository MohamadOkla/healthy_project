import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../cubit/profile_cubit.dart';
import '../../cubit/profile_state.dart';
import '../../widgets/edit_health_info_sheet.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_routes.dart';
import '../../../../../core/theme/app_spacing.dart';

class HealthInfoScreen extends StatelessWidget {
  const HealthInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: const EditHealthInfoSheet(),
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
