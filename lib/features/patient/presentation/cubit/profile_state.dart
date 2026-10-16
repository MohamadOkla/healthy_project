import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.fullName = 'محمد أحمد',
    this.phone = '+966 55 123 4567',
    this.email = 'mohammad.health@example.com',
    this.province = 'الرياض',
    this.city = 'الرياض',
    this.address = 'حي النخيل',
    this.bloodType = 'O+',
    this.age = '32 سنة',
    this.gender = 'ذكر',
    this.height = '176 سم',
    this.weight = '78 كغ',
    this.allergies = 'لم تُسجل معلومات الحساسية',
    this.chronicDiseases = 'لا توجد أمراض مزمنة',
    this.language = 'العربية',
    this.appointmentNotifications = true,
    this.laboratoryNotifications = true,
    this.prescriptionNotifications = true,
    this.generalNotifications = true,
    this.appointmentReminder = true,
    this.isCurrentPasswordVisible = false,
    this.isNewPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.isLoading = false,
  });

  final String fullName;
  final String phone;
  final String email;
  final String province;
  final String city;
  final String address;
  final String bloodType;
  final String age;
  final String gender;
  final String height;
  final String weight;
  final String allergies;
  final String chronicDiseases;
  final String language;
  final bool appointmentNotifications;
  final bool laboratoryNotifications;
  final bool prescriptionNotifications;
  final bool generalNotifications;
  final bool appointmentReminder;
  final bool isCurrentPasswordVisible;
  final bool isNewPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isLoading;

  ProfileState copyWith({
    String? fullName,
    String? phone,
    String? email,
    String? province,
    String? city,
    String? address,
    String? bloodType,
    String? age,
    String? gender,
    String? height,
    String? weight,
    String? allergies,
    String? chronicDiseases,
    String? language,
    bool? appointmentNotifications,
    bool? laboratoryNotifications,
    bool? prescriptionNotifications,
    bool? generalNotifications,
    bool? appointmentReminder,
    bool? isCurrentPasswordVisible,
    bool? isNewPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? isLoading,
  }) {
    return ProfileState(
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      province: province ?? this.province,
      city: city ?? this.city,
      address: address ?? this.address,
      bloodType: bloodType ?? this.bloodType,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      allergies: allergies ?? this.allergies,
      chronicDiseases: chronicDiseases ?? this.chronicDiseases,
      language: language ?? this.language,
      appointmentNotifications:
          appointmentNotifications ?? this.appointmentNotifications,
      laboratoryNotifications:
          laboratoryNotifications ?? this.laboratoryNotifications,
      prescriptionNotifications:
          prescriptionNotifications ?? this.prescriptionNotifications,
      generalNotifications: generalNotifications ?? this.generalNotifications,
      appointmentReminder: appointmentReminder ?? this.appointmentReminder,
      isCurrentPasswordVisible:
          isCurrentPasswordVisible ?? this.isCurrentPasswordVisible,
      isNewPasswordVisible: isNewPasswordVisible ?? this.isNewPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        fullName,
        phone,
        email,
        province,
        city,
        address,
        bloodType,
        age,
        gender,
        height,
        weight,
        allergies,
        chronicDiseases,
        language,
        appointmentNotifications,
        laboratoryNotifications,
        prescriptionNotifications,
        generalNotifications,
        appointmentReminder,
        isCurrentPasswordVisible,
        isNewPasswordVisible,
        isConfirmPasswordVisible,
        isLoading,
      ];
}
