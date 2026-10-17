import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text_field.dart';

class RegisterProfileInfoForm extends StatelessWidget {
  const RegisterProfileInfoForm({
    super.key,
    this.isDoctorRegistration = false,
    this.isHospitalAdminRegistration = false,
    this.hospitalNameController,
    this.jobTitleController,
  });

  final bool isDoctorRegistration;
  final bool isHospitalAdminRegistration;
  final TextEditingController? hospitalNameController;
  final TextEditingController? jobTitleController;

  @override
  Widget build(BuildContext context) {
    if (isDoctorRegistration) {
      return Column(
        children: [
          const AppTextField(
            label: 'الرقم الطبي أو رقم الترخيص',
            prefixIcon: Icon(Icons.badge_outlined, color: AppColors.primary),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            decoration: _inputDecoration(
              context,
              'الاختصاص',
              Icons.medical_services_rounded,
            ),
            items: const [
              DropdownMenuItem(value: 'cardiology', child: Text('قلبية')),
              DropdownMenuItem(value: 'dermatology', child: Text('جلدية')),
              DropdownMenuItem(value: 'orthopedics', child: Text('عظمية')),
              DropdownMenuItem(value: 'pediatrics', child: Text('أطفال')),
            ],
            onChanged: (_) {},
          ),
          const SizedBox(height: AppSpacing.md),
          const AppTextField(
            label: 'سنوات الخبرة',
            prefixIcon:
                Icon(Icons.work_history_outlined, color: AppColors.primary),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            decoration: _inputDecoration(
              context,
              'المشفى المرتبط',
              Icons.local_hospital_rounded,
            ),
            items: const [
              DropdownMenuItem(
                value: 'damascus',
                child: Text('مشفى دمشق الجامعي'),
              ),
              DropdownMenuItem(value: 'mouwasat', child: Text('مشفى المواساة')),
              DropdownMenuItem(
                  value: 'assad', child: Text('مشفى الأسد الجامعي')),
            ],
            onChanged: (_) {},
          ),
        ],
      );
    }

    if (isHospitalAdminRegistration) {
      return Column(
        children: [
          AppTextField(
            controller: hospitalNameController,
            label: 'اسم المشفى',
            prefixIcon:
                Icon(Icons.local_hospital_outlined, color: AppColors.primary),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: jobTitleController,
            label: 'المسمى الوظيفي',
            prefixIcon: Icon(Icons.badge_outlined, color: AppColors.primary),
            textInputAction: TextInputAction.next,
          ),
        ],
      );
    }

    return Column(
      children: [
        DropdownButtonFormField<String>(
          decoration: _inputDecoration(context, 'الجنس', Icons.wc_rounded),
          items: const [
            DropdownMenuItem(value: 'male', child: Text('ذكر')),
            DropdownMenuItem(value: 'female', child: Text('أنثى')),
          ],
          onChanged: (_) {},
        ),
        const SizedBox(height: AppSpacing.md),
        const AppTextField(
          label: 'تاريخ الميلاد',
          hint: 'YYYY/MM/DD',
          prefixIcon:
              Icon(Icons.calendar_today_outlined, color: AppColors.primary),
          keyboardType: TextInputType.datetime,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          decoration: _inputDecoration(
            context,
            'المحافظة',
            Icons.location_city_rounded,
          ),
          items: const [
            DropdownMenuItem(value: 'riyadh', child: Text('الرياض')),
            DropdownMenuItem(value: 'jeddah', child: Text('جدة')),
            DropdownMenuItem(value: 'dammam', child: Text('الدمام')),
            DropdownMenuItem(value: 'other', child: Text('أخرى')),
          ],
          onChanged: (_) {},
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(
    BuildContext context,
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.primary),
      filled: true,
      fillColor: context.colors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
    );
  }
}
