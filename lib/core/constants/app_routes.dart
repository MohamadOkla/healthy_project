abstract final class AppRoutes {
  static const String splash = '/splash';
  static const String splashName = 'splash';

  static const String onboarding = '/onboarding';
  static const String onboardingName = 'onboarding';

  static const String roleSelection = '/role-selection';
  static const String roleSelectionName = 'role-selection';

  static const String auth = '/auth';
  static const String authName = 'auth';

  static const String login = '/auth/login';
  static const String loginName = 'login';

  static const String register = '/auth/register';
  static const String registerName = 'register';

  static const String forgotPassword = '/auth/forgot-password';
  static const String forgotPasswordName = 'forgot-password';

  static const String otp = '/auth/otp';
  static const String otpName = 'otp';

  static const String resetPassword = '/auth/reset-password';
  static const String resetPasswordName = 'reset-password';

  static const String accountCreated = '/auth/account-created';
  static const String accountCreatedName = 'account-created';

  static const String passwordChanged = '/auth/password-changed';
  static const String passwordChangedName = 'password-changed';

  static const String patient = '/patient';
  static const String patientName = 'patient';

  static const String patientDashboard = '/patient/dashboard';
  static const String patientDashboardName = 'patient-dashboard';

  static const String patientAppointments = '/patient/appointments';
  static const String patientAppointmentsName = 'patient-appointments';

  static const String patientAppointmentDetails =
      '/patient/appointments/details';
  static const String patientAppointmentDetailsName =
      'patient-appointment-details';

  static const String patientBookAppointment = '/patient/appointments/book';
  static const String patientBookAppointmentName = 'patient-book-appointment';

  static const String patientSelectDoctor =
      '/patient/appointments/select-doctor';
  static const String patientSelectDoctorName = 'patient-select-doctor';

  static const String patientSelectDateTime =
      '/patient/appointments/select-date-time';
  static const String patientSelectDateTimeName = 'patient-select-date-time';

  static const String patientBookingSuccess = '/patient/appointments/success';
  static const String patientBookingSuccessName = 'patient-booking-success';
  static const String patientBookingReview = '/patient/appointments/review';
  static const String patientBookingReviewName = 'patient-booking-review';

  static const String patientMedicalRecords = '/patient/medical-records';
  static const String patientMedicalRecordsName = 'patient-medical-records';

  static const String patientMedicalRecordDetails =
      '/patient/medical-records/details';
  static const String patientMedicalRecordDetailsName =
      'patient-medical-record-details';

  static const String patientPrescriptions = '/patient/prescriptions';
  static const String patientPrescriptionsName = 'patient-prescriptions';

  static const String patientPrescriptionDetails =
      '/patient/prescriptions/details';
  static const String patientPrescriptionDetailsName =
      'patient-prescription-details';

  static const String patientLaboratory = '/patient/laboratory';
  static const String patientLaboratoryName = 'patient-laboratory';

  static const String patientLaboratoryDetails = '/patient/laboratory/details';
  static const String patientLaboratoryDetailsName =
      'patient-laboratory-details';

  static const String patientRequestConsultation =
      '/patient/laboratory/request-consultation';
  static const String patientRequestConsultationName =
      'patient-request-consultation';

  static const String patientConsultations = '/patient/consultations';
  static const String patientConsultationsName = 'patient-consultations';

  static const String patientNotifications = '/patient/notifications';
  static const String patientNotificationsName = 'patient-notifications';

  static const String patientNotificationDetails =
      '/patient/notifications/details';
  static const String patientNotificationDetailsName =
      'patient-notification-details';

  static const String patientProfile = '/patient/profile';
  static const String patientProfileName = 'patient-profile';

  static const String patientEditProfile = '/patient/profile/edit';
  static const String patientEditProfileName = 'patient-edit-profile';

  static const String patientChangePassword =
      '/patient/profile/change-password';
  static const String patientChangePasswordName = 'patient-change-password';

  static const String patientNotificationSettings =
      '/patient/profile/notification-settings';
  static const String patientNotificationSettingsName =
      'patient-notification-settings';

  static const String patientLanguage = '/patient/profile/language';
  static const String patientLanguageName = 'patient-language';

  static const String patientHelp = '/patient/profile/help';
  static const String patientHelpName = 'patient-help';

  static const String patientAbout = '/patient/profile/about';
  static const String patientAboutName = 'patient-about';

  static const String patientProfilePrivacy = '/patient/profile/privacy';
  static const String patientProfilePrivacyName = 'patient-profile-privacy';

  static const String patientProfileTerms = '/patient/profile/terms';
  static const String patientProfileTermsName = 'patient-profile-terms';

  static const String patientHealthInfo = '/patient/profile/health-info';
  static const String patientHealthInfoName = 'patient-health-info';

  static const String patientSettings = '/patient/settings';
  static const String patientSettingsName = 'patient-settings';

  static const String doctor = '/doctor';
  static const String doctorName = 'doctor';

  static const String doctorPatients = '/doctor/patients';
  static const String doctorPatientsName = 'doctor-patients';

  static const String doctorPatientDetail = '/doctor/patients/detail';
  static const String doctorPatientDetailName = 'doctor-patient-detail';

  static const String doctorAppointments = '/doctor/appointments';
  static const String doctorAppointmentsName = 'doctor-appointments';

  static const String doctorConsultations = '/doctor/consultations';
  static const String doctorConsultationsName = 'doctor-consultations';

  static const String doctorProfile = '/doctor/profile';
  static const String doctorProfileName = 'doctor-profile';

  static const String hospitalAdmin = '/hospital-admin';
  static const String hospitalAdminName = 'hospital-admin';

  static const String hospitalAdminDoctors = '/hospital-admin/doctors';
  static const String hospitalAdminDoctorsName = 'hospital-admin-doctors';

  static const String hospitalAdminDoctorDetail =
      '/hospital-admin/doctors/detail';
  static const String hospitalAdminDoctorDetailName =
      'hospital-admin-doctor-detail';

  static const String hospitalAdminProfile = '/hospital-admin/profile';
  static const String hospitalAdminProfileName = 'hospital-admin-profile';

  static const String hospitalAdminReports = '/hospital-admin/reports';
  static const String hospitalAdminReportsName = 'hospital-admin-reports';

  static const String appointments = '/appointments';
  static const String appointmentsName = 'appointments';

  static const String medicalRecords = '/medical-records';
  static const String medicalRecordsName = 'medical-records';

  static const String prescriptions = '/prescriptions';
  static const String prescriptionsName = 'prescriptions';

  static const String laboratory = '/laboratory';
  static const String laboratoryName = 'laboratory';

  static const String reports = '/reports';
  static const String reportsName = 'reports';

  static const String notifications = '/notifications';
  static const String notificationsName = 'notifications';

  static const String settings = '/settings';
  static const String settingsName = 'settings';
}
