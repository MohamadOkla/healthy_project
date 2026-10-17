import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/role_ui_model.dart';
import 'role_selection_state.dart';

class RoleSelectionCubit extends Cubit<RoleSelectionState> {
  RoleSelectionCubit() : super(const RoleSelectionState());

  static const List<RoleUiModel> roles = [
    RoleUiModel(
      id: 'patient',
      englishTitle: 'Patient',
      arabicTitle: 'مريض',
      description: 'إدارة ملفك الطبي وحجز المواعيد ومتابعة نتائجك',
      icon: Icons.person_rounded,
    ),
    RoleUiModel(
      id: 'doctor',
      englishTitle: 'Doctor',
      arabicTitle: 'طبيب',
      description: 'متابعة المرضى، المواعيد، التشخيصات والوصفات الطبية',
      icon: Icons.medical_services_rounded,
    ),
    RoleUiModel(
      id: 'hospital_admin',
      englishTitle: 'Hospital Admin',
      arabicTitle: 'مدير مشفى',
      description: 'إدارة الأقسام، الأطباء، المواعيد وتقارير المشفى',
      icon: Icons.local_hospital_rounded,
    ),
  ];

  List<RoleUiModel> get availableRoles => roles;

  void selectRole(RoleUiModel role) {
    emit(state.copyWith(selectedRole: role));
  }
}
