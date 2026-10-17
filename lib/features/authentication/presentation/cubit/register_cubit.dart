import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/utils/user_role_helper.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({String? selectedRole})
      : super(RegisterState(
            selectedRole: UserRoleHelper.normalize(selectedRole)));

  void nextStep() {
    if (!state.isLastStep) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    }
  }

  void previousStep() {
    if (!state.isFirstStep) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  Future<void> submit({
    required String fullName,
    required String phone,
    required String email,
    String hospitalName = '',
    String jobTitle = '',
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      final storage = LocalStorageService.instance;
      await storage.setString(StorageKeys.profileFullName, fullName.trim());
      await storage.setString(StorageKeys.profilePhone, phone.trim());
      await storage.setString(StorageKeys.profileEmail, email.trim());
      if (state.isHospitalAdminRegistration) {
        await storage.setString(
            StorageKeys.profileHospitalName, hospitalName.trim());
        await storage.setString(StorageKeys.profileJobTitle, jobTitle.trim());
      }
      await storage.setString(StorageKeys.selectedRole, state.selectedRole);
      await storage.setString(StorageKeys.currentUserRole, state.selectedRole);
      await storage.setBool(StorageKeys.isLoggedIn, false);
      if (!isClosed) emit(state.copyWith(isLoading: false));
    } on Object {
      if (!isClosed) emit(state.copyWith(isLoading: false));
      rethrow;
    }
  }
}
