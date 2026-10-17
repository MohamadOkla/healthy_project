import 'package:equatable/equatable.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.selectedRole = 'patient',
    this.currentStep = 0,
    this.isLoading = false,
  });

  final String selectedRole;
  final int currentStep;
  final bool isLoading;

  bool get isFirstStep => currentStep == 0;
  bool get isLastStep => currentStep == 2;
  bool get canGoNext => !isLoading;
  bool get isPatientRegistration => selectedRole == 'patient';
  bool get isDoctorRegistration => selectedRole == 'doctor';
  bool get isHospitalAdminRegistration => selectedRole == 'hospitalAdmin';

  RegisterState copyWith({
    String? selectedRole,
    int? currentStep,
    bool? isLoading,
  }) {
    return RegisterState(
      selectedRole: selectedRole ?? this.selectedRole,
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [selectedRole, currentStep, isLoading];
}
