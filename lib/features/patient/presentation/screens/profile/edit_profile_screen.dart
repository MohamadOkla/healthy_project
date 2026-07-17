import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_routes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../cubit/profile_cubit.dart';
import '../../cubit/profile_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _provinceController;
  late final TextEditingController _cityController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileCubit>().state;
    _nameController = TextEditingController(text: state.fullName);
    _phoneController = TextEditingController(text: state.phone);
    _emailController = TextEditingController(text: state.email);
    _provinceController = TextEditingController(text: state.province);
    _cityController = TextEditingController(text: state.city);
    _addressController = TextEditingController(text: state.address);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _provinceController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.go(AppRoutes.patientProfile),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('تعديل الملف الشخصي'),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              AppTextField(
                controller: _nameController,
                label: 'الاسم الكامل',
                prefixIcon: const Icon(Icons.person_outline_rounded),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _phoneController,
                label: 'رقم الهاتف',
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone_outlined),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _emailController,
                label: 'البريد الإلكتروني',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.mail_outline_rounded),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _provinceController,
                label: 'المحافظة',
                prefixIcon: const Icon(Icons.map_outlined),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _cityController,
                label: 'المدينة',
                prefixIcon: const Icon(Icons.location_city_outlined),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _addressController,
                label: 'العنوان',
                prefixIcon: const Icon(Icons.home_outlined),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                text: 'حفظ التعديلات',
                isLoading: state.isLoading,
                onPressed: state.isLoading ? null : _save,
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _save() async {
    await context.read<ProfileCubit>().saveProfile(
          fullName: _nameController.text,
          phone: _phoneController.text,
          email: _emailController.text,
          province: _provinceController.text,
          city: _cityController.text,
          address: _addressController.text,
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ التعديلات بنجاح')),
    );
    context.go(AppRoutes.patientProfile);
  }
}
