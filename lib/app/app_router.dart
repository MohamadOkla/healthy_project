import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_routes.dart';
import '../core/constants/storage_keys.dart';
import '../core/services/local_storage_service.dart';
import '../core/theme/app_radius.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../core/widgets/app_button.dart';
import '../core/utils/route_persistence_helper.dart';
import '../features/appointments/presentation/cubit/book_appointment_cubit.dart';
import '../features/appointments/presentation/cubit/book_appointment_state.dart';
import '../features/appointments/presentation/models/appointment_ui_model.dart';
import '../features/appointments/presentation/screens/appointment_details_screen.dart';
import '../features/appointments/presentation/screens/book_appointment_screen.dart';
import '../features/appointments/presentation/screens/booking_success_screen.dart';
import '../features/appointments/presentation/screens/date_time_selection_screen.dart';
import '../features/laboratory/domain/entities/lab_result_entry.dart';
import '../features/medical_records/domain/entities/medical_record_entry.dart';
import '../features/notifications/domain/entities/app_notification.dart';
import '../features/prescriptions/domain/entities/prescription_entry.dart';
import '../features/appointments/presentation/screens/doctor_selection_screen.dart';
import '../features/appointments/presentation/screens/my_appointments_screen.dart';
import '../features/authentication/presentation/screens/account_created_screen.dart';
import '../features/authentication/presentation/screens/forgot_password_screen.dart';
import '../features/authentication/presentation/screens/login_screen.dart';
import '../features/authentication/presentation/screens/otp_verification_screen.dart';
import '../features/authentication/presentation/screens/password_changed_screen.dart';
import '../features/authentication/presentation/screens/register_screen.dart';
import '../features/authentication/presentation/screens/reset_password_screen.dart';
import '../features/doctor/presentation/screens/doctor_appointments_screen.dart';
import '../features/doctor/presentation/screens/doctor_consultations_screen.dart';
import '../features/doctor/presentation/screens/doctor_dashboard_screen.dart';
import '../features/doctor/presentation/screens/doctor_patient_detail_screen.dart';
import '../features/doctor/presentation/screens/doctor_patients_screen.dart';
import '../features/doctor/presentation/screens/doctor_profile_screen.dart';
import '../features/hospital_admin/presentation/screens/hospital_admin_dashboard_screen.dart';
import '../features/hospital_admin/presentation/screens/hospital_admin_profile_screen.dart';
import '../features/hospital_admin/presentation/screens/hospital_doctor_detail_screen.dart';
import '../features/hospital_admin/presentation/screens/hospital_doctors_screen.dart';
import '../features/reports/presentation/screens/hospital_reports_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/patient/presentation/screens/medical_records_screen.dart';
import '../features/patient/presentation/screens/medical_record_details_screen.dart';
import '../features/patient/presentation/screens/consultation_request_screen.dart';
import '../features/patient/presentation/screens/my_consultations_screen.dart';
import '../features/patient/presentation/screens/notification_details_screen.dart';
import '../features/patient/presentation/screens/notifications_screen.dart';
import '../features/patient/presentation/screens/patient_dashboard_screen.dart';
import '../features/patient/presentation/screens/prescription_details_screen.dart';
import '../features/patient/presentation/screens/laboratory_result_details_screen.dart';
import '../features/patient/presentation/screens/profile/about_app_screen.dart';
import '../features/patient/presentation/screens/profile/change_password_screen.dart';
import '../features/patient/presentation/screens/profile/edit_profile_screen.dart';
import '../features/patient/presentation/screens/profile/health_info_screen.dart';
import '../features/patient/presentation/screens/profile/help_support_screen.dart';
import '../features/patient/presentation/screens/profile/language_settings_screen.dart';
import '../features/patient/presentation/screens/profile/notification_settings_screen.dart';
import '../features/patient/presentation/screens/profile/privacy_policy_screen.dart';
import '../features/patient/presentation/screens/profile_screen.dart';
import '../features/patient/presentation/screens/settings_screen.dart';
import '../features/patient/presentation/widgets/patient_bottom_navigation.dart';
import '../features/role_selection/presentation/screens/role_selection_screen.dart';
import '../features/splash/presentation/screens/splash_screen.dart';

abstract final class AppRouter {
  static final BookAppointmentCubit _bookingCubit = BookAppointmentCubit();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: _persistLastRoute,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splashName,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: AppRoutes.onboardingName,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.roleSelection,
        name: AppRoutes.roleSelectionName,
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.auth,
        name: AppRoutes.authName,
        redirect: _redirectToLogin,
      ),
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.loginName,
        builder: (context, state) {
          return LoginScreen(selectedRole: state.uri.queryParameters['role']);
        },
      ),
      GoRoute(
        path: AppRoutes.register,
        name: AppRoutes.registerName,
        builder: (context, state) {
          final role = state.uri.queryParameters['role'] ??
              LocalStorageService.instance.getString(StorageKeys.selectedRole);
          return RegisterScreen(selectedRole: role);
        },
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: AppRoutes.forgotPasswordName,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.otp,
        name: AppRoutes.otpName,
        builder: (context, state) {
          return OtpVerificationScreen(
            purpose: state.uri.queryParameters['purpose'] ?? 'reset',
            selectedRole: state.uri.queryParameters['role'],
          );
        },
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        name: AppRoutes.resetPasswordName,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.accountCreated,
        name: AppRoutes.accountCreatedName,
        builder: (context, state) {
          return AccountCreatedScreen(
            selectedRole: state.uri.queryParameters['role'],
          );
        },
      ),
      GoRoute(
        path: AppRoutes.passwordChanged,
        name: AppRoutes.passwordChangedName,
        builder: (context, state) => const PasswordChangedScreen(),
      ),
      GoRoute(
        path: AppRoutes.patient,
        name: AppRoutes.patientName,
        redirect: _redirectToPatientDashboard,
      ),
      GoRoute(
        path: AppRoutes.patientDashboard,
        name: AppRoutes.patientDashboardName,
        builder: (context, state) => const PatientDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.patientAppointments,
        name: AppRoutes.patientAppointmentsName,
        builder: (context, state) => const MyAppointmentsScreen(),
      ),
      GoRoute(
        path: AppRoutes.patientAppointmentDetails,
        name: AppRoutes.patientAppointmentDetailsName,
        builder: (context, state) {
          final appointment = state.extra;
          return AppointmentDetailsScreen(
            appointment:
                appointment is AppointmentUiModel ? appointment : null,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.patientBookAppointment,
        name: AppRoutes.patientBookAppointmentName,
        builder: (context, state) {
          final cubit = state.extra;
          if (cubit is! BookAppointmentCubit) {
            // Fresh entry into the booking wizard (not a continuation of an
            // in-progress flow) - clear out any selections left over from a
            // previous, abandoned booking attempt.
            _bookingCubit.resetBooking();
          }
          return BookAppointmentScreen(
            cubit: cubit is BookAppointmentCubit ? cubit : _bookingCubit,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.patientSelectDoctor,
        name: AppRoutes.patientSelectDoctorName,
        builder: (context, state) {
          final cubit = state.extra;
          return DoctorSelectionScreen(
            cubit: cubit is BookAppointmentCubit ? cubit : _bookingCubit,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.patientSelectDateTime,
        name: AppRoutes.patientSelectDateTimeName,
        builder: (context, state) {
          final cubit = state.extra;
          return DateTimeSelectionScreen(
            cubit: cubit is BookAppointmentCubit ? cubit : _bookingCubit,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.patientBookingSuccess,
        name: AppRoutes.patientBookingSuccessName,
        builder: (context, state) {
          final booking = state.extra;
          return BlocProvider.value(
            value: _bookingCubit,
            child: BookingSuccessScreen(
              booking: booking is BookAppointmentState
                  ? booking
                  : _bookingCubit.state,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.patientMedicalRecords,
        name: AppRoutes.patientMedicalRecordsName,
        builder: (context, state) => const MedicalRecordsScreen(),
      ),
      GoRoute(
        path: AppRoutes.patientMedicalRecordDetails,
        name: AppRoutes.patientMedicalRecordDetailsName,
        builder: (context, state) {
          final record = state.extra;
          return MedicalRecordDetailsScreen(
            record: record is MedicalRecordEntry ? record : null,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.patientPrescriptions,
        name: AppRoutes.patientPrescriptionsName,
        builder: (context, state) => const PrescriptionsScreen(),
      ),
      GoRoute(
        path: AppRoutes.patientPrescriptionDetails,
        name: AppRoutes.patientPrescriptionDetailsName,
        builder: (context, state) {
          final prescription = state.extra;
          return PrescriptionDetailsScreen(
            prescription:
                prescription is PrescriptionEntry ? prescription : null,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.patientLaboratory,
        name: AppRoutes.patientLaboratoryName,
        builder: (context, state) => const LaboratoryResultsScreen(),
      ),
      GoRoute(
        path: AppRoutes.patientLaboratoryDetails,
        name: AppRoutes.patientLaboratoryDetailsName,
        builder: (context, state) {
          final result = state.extra;
          return LaboratoryResultDetailsScreen(
            result: result is LabResultEntry ? result : null,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.patientRequestConsultation,
        name: AppRoutes.patientRequestConsultationName,
        builder: (context, state) {
          final labResult = state.extra;
          return ConsultationRequestScreen(
            labResult: labResult is LabResultEntry ? labResult : null,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.patientConsultations,
        name: AppRoutes.patientConsultationsName,
        builder: (context, state) => const MyConsultationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.patientNotifications,
        name: AppRoutes.patientNotificationsName,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.patientNotificationDetails,
        name: AppRoutes.patientNotificationDetailsName,
        builder: (context, state) {
          final notification = state.extra;
          return NotificationDetailsScreen(
            notification: notification is AppNotification ? notification : null,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.patientProfile,
        name: AppRoutes.patientProfileName,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.patientEditProfile,
        name: AppRoutes.patientEditProfileName,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.patientChangePassword,
        name: AppRoutes.patientChangePasswordName,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.patientNotificationSettings,
        name: AppRoutes.patientNotificationSettingsName,
        builder: (context, state) => const NotificationSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.patientLanguage,
        name: AppRoutes.patientLanguageName,
        builder: (context, state) => const LanguageSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.patientHealthInfo,
        name: AppRoutes.patientHealthInfoName,
        builder: (context, state) => const HealthInfoScreen(),
      ),
      GoRoute(
        path: AppRoutes.patientHelp,
        name: AppRoutes.patientHelpName,
        builder: (context, state) => const HelpSupportScreen(),
      ),
      GoRoute(
        path: AppRoutes.patientAbout,
        name: AppRoutes.patientAboutName,
        builder: (context, state) => const AboutAppScreen(),
      ),
      GoRoute(
        path: AppRoutes.patientProfilePrivacy,
        name: AppRoutes.patientProfilePrivacyName,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: AppRoutes.patientProfileTerms,
        name: AppRoutes.patientProfileTermsName,
        builder: (context, state) => const TermsConditionsScreen(),
      ),
      GoRoute(
        path: AppRoutes.patientSettings,
        name: AppRoutes.patientSettingsName,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.doctor,
        name: AppRoutes.doctorName,
        builder: (context, state) => const DoctorDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.doctorPatients,
        name: AppRoutes.doctorPatientsName,
        builder: (context, state) => const DoctorPatientsScreen(),
      ),
      GoRoute(
        path: AppRoutes.doctorPatientDetail,
        name: AppRoutes.doctorPatientDetailName,
        builder: (context, state) {
          final patientId = state.extra;
          return DoctorPatientDetailScreen(
            patientId: patientId is String ? patientId : '',
          );
        },
      ),
      GoRoute(
        path: AppRoutes.doctorAppointments,
        name: AppRoutes.doctorAppointmentsName,
        builder: (context, state) => const DoctorAppointmentsScreen(),
      ),
      GoRoute(
        path: AppRoutes.doctorConsultations,
        name: AppRoutes.doctorConsultationsName,
        builder: (context, state) => const DoctorConsultationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.doctorProfile,
        name: AppRoutes.doctorProfileName,
        builder: (context, state) => const DoctorProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.hospitalAdmin,
        name: AppRoutes.hospitalAdminName,
        builder: (context, state) => const HospitalAdminDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.hospitalAdminDoctors,
        name: AppRoutes.hospitalAdminDoctorsName,
        builder: (context, state) => const HospitalDoctorsScreen(),
      ),
      GoRoute(
        path: AppRoutes.hospitalAdminDoctorDetail,
        name: AppRoutes.hospitalAdminDoctorDetailName,
        builder: (context, state) {
          final doctorId = state.extra;
          return HospitalDoctorDetailScreen(
            doctorId: doctorId is String ? doctorId : '',
          );
        },
      ),
      GoRoute(
        path: AppRoutes.hospitalAdminProfile,
        name: AppRoutes.hospitalAdminProfileName,
        builder: (context, state) => const HospitalAdminProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.hospitalAdminReports,
        name: AppRoutes.hospitalAdminReportsName,
        builder: (context, state) => const HospitalReportsScreen(),
      ),
      GoRoute(
        path: AppRoutes.appointments,
        name: AppRoutes.appointmentsName,
        redirect: _redirectToOnboarding,
      ),
      GoRoute(
        path: AppRoutes.medicalRecords,
        name: AppRoutes.medicalRecordsName,
        redirect: _redirectToOnboarding,
      ),
      GoRoute(
        path: AppRoutes.prescriptions,
        name: AppRoutes.prescriptionsName,
        redirect: _redirectToOnboarding,
      ),
      GoRoute(
        path: AppRoutes.laboratory,
        name: AppRoutes.laboratoryName,
        redirect: _redirectToOnboarding,
      ),
      GoRoute(
        path: AppRoutes.reports,
        name: AppRoutes.reportsName,
        redirect: _redirectToOnboarding,
      ),
      GoRoute(
        path: AppRoutes.notifications,
        name: AppRoutes.notificationsName,
        redirect: _redirectToOnboarding,
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: AppRoutes.settingsName,
        redirect: _redirectToOnboarding,
      ),
    ],
  );

  static String _redirectToOnboarding(
    BuildContext context,
    GoRouterState state,
  ) {
    return AppRoutes.onboarding;
  }

  static String _redirectToLogin(
    BuildContext context,
    GoRouterState state,
  ) {
    return AppRoutes.login;
  }

  static String _redirectToPatientDashboard(
    BuildContext context,
    GoRouterState state,
  ) {
    return AppRoutes.patientDashboard;
  }

  static String? _persistLastRoute(
    BuildContext context,
    GoRouterState state,
  ) {
    final route = state.uri.path;
    final isLoggedIn =
        LocalStorageService.instance.getBool(StorageKeys.isLoggedIn) == true;
    final currentRole = LocalStorageService.instance.getString(
      StorageKeys.currentUserRole,
    );

    if (isLoggedIn &&
        currentRole == 'patient' &&
        RoutePersistenceHelper.isPersistableRoute(route)) {
      unawaited(
        LocalStorageService.instance.saveString(StorageKeys.lastRoute, route),
      );
    }

    return null;
  }
}

class PatientPlaceholderScreen extends StatelessWidget {
  const PatientPlaceholderScreen({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.selectedIndex,
  });

  final String title;
  final String description;
  final IconData icon;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.go(AppRoutes.patientDashboard),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(title),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    blurRadius: 24,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.10),
                    child: Icon(icon, color: AppColors.primary, size: 34),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.headlineLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    text: 'العودة للرئيسية',
                    icon: Icons.home_rounded,
                    onPressed: () => context.go(AppRoutes.patientDashboard),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar:
          PatientBottomNavigation(selectedIndex: selectedIndex),
    );
  }
}
