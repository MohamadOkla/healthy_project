import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/services/local_storage_service.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({LocalStorageService? storage})
      : _storage = storage ?? LocalStorageService.instance,
        super(const ProfileState()) {
    _loadSavedProfile();
  }

  final LocalStorageService _storage;

  // Reload any previously saved profile fields. ProfileCubit is re-created
  // every time its route is opened (see AppRouter._withProfileCubit), so
  // without this, edits would appear to succeed but be lost as soon as the
  // user navigated away and back.
  void _loadSavedProfile() {
    const defaults = ProfileState();
    emit(
      state.copyWith(
        fullName: _storage.getString(StorageKeys.profileFullName) ??
            defaults.fullName,
        phone: _storage.getString(StorageKeys.profilePhone) ??
            defaults.phone,
        email: _storage.getString(StorageKeys.profileEmail) ??
            defaults.email,
        province: _storage.getString(StorageKeys.profileProvince) ??
            defaults.province,
        city: _storage.getString(StorageKeys.profileCity) ?? defaults.city,
        address: _storage.getString(StorageKeys.profileAddress) ??
            defaults.address,
        bloodType: _storage.getString(StorageKeys.profileBloodType) ??
            defaults.bloodType,
        age: _storage.getString(StorageKeys.profileAge) ?? defaults.age,
        gender:
            _storage.getString(StorageKeys.profileGender) ?? defaults.gender,
        height:
            _storage.getString(StorageKeys.profileHeight) ?? defaults.height,
        weight:
            _storage.getString(StorageKeys.profileWeight) ?? defaults.weight,
        allergies: _storage.getString(StorageKeys.profileAllergies) ??
            defaults.allergies,
        chronicDiseases:
            _storage.getString(StorageKeys.profileChronicDiseases) ??
                defaults.chronicDiseases,
        language: _storage.getString(StorageKeys.profileLanguage) ??
            defaults.language,
        appointmentNotifications: _storage.getBool(
              StorageKeys.profileAppointmentNotifications,
            ) ??
            defaults.appointmentNotifications,
        laboratoryNotifications: _storage.getBool(
              StorageKeys.profileLaboratoryNotifications,
            ) ??
            defaults.laboratoryNotifications,
        prescriptionNotifications: _storage.getBool(
              StorageKeys.profilePrescriptionNotifications,
            ) ??
            defaults.prescriptionNotifications,
        generalNotifications: _storage.getBool(
              StorageKeys.profileGeneralNotifications,
            ) ??
            defaults.generalNotifications,
        appointmentReminder: _storage.getBool(
              StorageKeys.profileAppointmentReminder,
            ) ??
            defaults.appointmentReminder,
      ),
    );
  }

  Future<void> saveProfile({
    required String fullName,
    required String phone,
    required String email,
    required String province,
    required String city,
    required String address,
  }) async {
    emit(state.copyWith(isLoading: true));
    await Future<void>.delayed(const Duration(milliseconds: 450));
    await Future.wait([
      _storage.saveString(StorageKeys.profileFullName, fullName),
      _storage.saveString(StorageKeys.profilePhone, phone),
      _storage.saveString(StorageKeys.profileEmail, email),
      _storage.saveString(StorageKeys.profileProvince, province),
      _storage.saveString(StorageKeys.profileCity, city),
      _storage.saveString(StorageKeys.profileAddress, address),
    ]);
    if (isClosed) return;
    emit(
      state.copyWith(
        fullName: fullName,
        phone: phone,
        email: email,
        province: province,
        city: city,
        address: address,
        isLoading: false,
      ),
    );
  }

  Future<void> saveHealthInfo({
    required String bloodType,
    required String age,
    required String gender,
    required String height,
    required String weight,
    required String allergies,
    required String chronicDiseases,
  }) async {
    emit(state.copyWith(isLoading: true));
    await Future<void>.delayed(const Duration(milliseconds: 350));
    await Future.wait([
      _storage.saveString(StorageKeys.profileBloodType, bloodType),
      _storage.saveString(StorageKeys.profileAge, age),
      _storage.saveString(StorageKeys.profileGender, gender),
      _storage.saveString(StorageKeys.profileHeight, height),
      _storage.saveString(StorageKeys.profileWeight, weight),
      _storage.saveString(StorageKeys.profileAllergies, allergies),
      _storage.saveString(
        StorageKeys.profileChronicDiseases,
        chronicDiseases,
      ),
    ]);
    if (isClosed) return;
    emit(
      state.copyWith(
        bloodType: bloodType,
        age: age,
        gender: gender,
        height: height,
        weight: weight,
        allergies: allergies,
        chronicDiseases: chronicDiseases,
        isLoading: false,
      ),
    );
  }

  Future<void> updatePassword() async {
    emit(state.copyWith(isLoading: true));
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!isClosed) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void toggleAppointmentNotifications(bool value) {
    unawaited(
      _storage.saveBool(StorageKeys.profileAppointmentNotifications, value),
    );
    emit(state.copyWith(appointmentNotifications: value));
  }

  void toggleLaboratoryNotifications(bool value) {
    unawaited(
      _storage.saveBool(StorageKeys.profileLaboratoryNotifications, value),
    );
    emit(state.copyWith(laboratoryNotifications: value));
  }

  void togglePrescriptionNotifications(bool value) {
    unawaited(
      _storage.saveBool(StorageKeys.profilePrescriptionNotifications, value),
    );
    emit(state.copyWith(prescriptionNotifications: value));
  }

  void toggleGeneralNotifications(bool value) {
    unawaited(
      _storage.saveBool(StorageKeys.profileGeneralNotifications, value),
    );
    emit(state.copyWith(generalNotifications: value));
  }

  void toggleAppointmentReminder(bool value) {
    unawaited(
      _storage.saveBool(StorageKeys.profileAppointmentReminder, value),
    );
    emit(state.copyWith(appointmentReminder: value));
  }

  void changeLanguage(String language) {
    unawaited(_storage.saveString(StorageKeys.profileLanguage, language));
    emit(state.copyWith(language: language));
  }

  void toggleCurrentPasswordVisibility() {
    emit(
      state.copyWith(
        isCurrentPasswordVisible: !state.isCurrentPasswordVisible,
      ),
    );
  }

  void toggleNewPasswordVisibility() {
    emit(state.copyWith(isNewPasswordVisible: !state.isNewPasswordVisible));
  }

  void toggleConfirmPasswordVisibility() {
    emit(
      state.copyWith(
        isConfirmPasswordVisible: !state.isConfirmPasswordVisible,
      ),
    );
  }
}
