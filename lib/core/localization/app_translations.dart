import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/cubit/app_settings_cubit.dart';

/// A small, hand-written translation table (no code generation step, since
/// this environment can't run `flutter gen-l10n` to verify generated code
/// compiles). Covers the primary navigation spine - splash, onboarding,
/// role selection, login, and the main dashboards/navigation for each role -
/// so switching language actually re-renders the first, most-visible part
/// of the app in both Arabic and English. Deeper screens not yet covered
/// here keep their existing Arabic text.
abstract final class AppTranslations {
  static const Map<String, Map<String, String>> _strings = {
    // Onboarding
    'onboarding_title_1': {
      'ar': 'رؤية صحية واضحة',
      'en': 'A clear view of your health',
    },
    'onboarding_desc_1': {
      'ar': 'منصة موحدة تساعدك على الوصول إلى الخدمات الطبية ومتابعة بياناتك بسهولة',
      'en': 'One platform to reach medical services and track your data easily',
    },
    'onboarding_title_2': {
      'ar': 'خدمات طبية متكاملة',
      'en': 'Complete medical services',
    },
    'onboarding_desc_2': {
      'ar': 'إدارة المواعيد والسجلات والوصفات والتحاليل في تجربة رقمية موحدة',
      'en': 'Manage appointments, records, prescriptions and labs, all in one app',
    },
    'onboarding_title_3': {
      'ar': 'وصول أسهل وأسرع',
      'en': 'Easier, faster access',
    },
    'onboarding_desc_3': {
      'ar': 'تابع خدماتك الصحية من أي مكان بواجهة واضحة وسريعة وآمنة',
      'en': 'Access your health services anywhere with a clear, fast, secure app',
    },
    'skip': {'ar': 'تخطي', 'en': 'Skip'},
    'next': {'ar': 'التالي', 'en': 'Next'},
    'get_started': {'ar': 'ابدأ الآن', 'en': 'Get started'},

    // Role selection
    'choose_role_title': {'ar': 'من أنت؟', 'en': 'Who are you?'},
    'choose_role_subtitle': {
      'ar': 'اختر نوع الحساب المناسب للمتابعة',
      'en': 'Choose the account type to continue',
    },
    'role_patient': {'ar': 'مريض', 'en': 'Patient'},
    'role_doctor': {'ar': 'طبيب', 'en': 'Doctor'},
    'role_hospital_admin': {'ar': 'مدير مشفى', 'en': 'Hospital Admin'},
    'role_patient_desc': {
      'ar': 'إدارة ملفك الطبي وحجز المواعيد ومتابعة نتائجك',
      'en': 'Manage your medical file, book appointments, track results',
    },
    'role_doctor_desc': {
      'ar': 'متابعة المرضى، المواعيد، التشخيصات والوصفات الطبية',
      'en': 'Manage patients, appointments, diagnoses and prescriptions',
    },
    'role_hospital_admin_desc': {
      'ar': 'إدارة الأقسام، الأطباء، المواعيد وتقارير المشفى',
      'en': 'Manage departments, doctors, appointments and hospital reports',
    },
    'continue_button': {'ar': 'متابعة', 'en': 'Continue'},
    'back_to_role_selection': {
      'ar': 'الرجوع لاختيار الدور',
      'en': 'Back to role selection',
    },

    // Login
    'welcome_back': {'ar': 'أهلاً بعودتك', 'en': 'Welcome back'},
    'login_subtitle': {
      'ar': 'سجل دخولك للوصول إلى خدماتك الطبية بسهولة وأمان.',
      'en': 'Sign in to access your medical services, safely and easily.',
    },
    'email_label': {
      'ar': 'البريد الإلكتروني أو رقم الهاتف',
      'en': 'Email or phone number',
    },
    'email_field_label': {'ar': 'البريد الإلكتروني', 'en': 'Email'},
    'password_label': {'ar': 'كلمة المرور', 'en': 'Password'},
    'forgot_password': {'ar': 'نسيت كلمة المرور؟', 'en': 'Forgot password?'},
    'login_button': {'ar': 'تسجيل الدخول', 'en': 'Sign in'},
    'or_continue_with': {'ar': 'أو تابع عبر', 'en': 'Or continue with'},
    'no_account': {
      'ar': 'ليس لديك حساب؟',
      'en': "Don't have an account?",
    },
    'create_account': {'ar': 'إنشاء حساب', 'en': 'Create one'},
    'account_type_label': {'ar': 'نوع الحساب', 'en': 'Account type'},

    // Bottom navigation - patient
    'nav_home': {'ar': 'الرئيسية', 'en': 'Home'},
    'nav_appointments': {'ar': 'مواعيدي', 'en': 'Appointments'},
    'nav_book': {'ar': 'حجز', 'en': 'Book'},
    'nav_notifications': {'ar': 'الإشعارات', 'en': 'Notifications'},
    'nav_profile': {'ar': 'حسابي', 'en': 'Profile'},

    // Bottom navigation - doctor
    'nav_dashboard': {'ar': 'الرئيسية', 'en': 'Dashboard'},
    'nav_patients': {'ar': 'المرضى', 'en': 'Patients'},
    'nav_schedule': {'ar': 'الجدول', 'en': 'Schedule'},

    // Bottom navigation - hospital admin
    'nav_doctors': {'ar': 'الأطباء', 'en': 'Doctors'},

    // Dashboard greetings
    'welcome_greeting': {'ar': 'مرحبًا', 'en': 'Welcome'},
    'good_morning_greeting': {'ar': 'صباح الخير،', 'en': 'Good morning,'},

    // Settings
    'language': {'ar': 'اللغة', 'en': 'Language'},
    'dark_mode': {'ar': 'الوضع الليلي', 'en': 'Dark mode'},
    'arabic': {'ar': 'العربية', 'en': 'Arabic'},
    'english': {'ar': 'الإنجليزية', 'en': 'English'},
  };

  static String resolve(String key, bool isArabic) {
    final entry = _strings[key];
    if (entry == null) return key;
    return entry[isArabic ? 'ar' : 'en'] ?? entry['ar'] ?? key;
  }
}

extension AppTranslateX on BuildContext {
  /// Looks up [key] in the active language. Falls back to Arabic, then to
  /// the key itself, if a translation is missing - so a missing key is
  /// visible (and therefore easy to notice and add) rather than crashing.
  String tr(String key) {
    final isArabic = watch<AppSettingsCubit>().state.isArabic;
    return AppTranslations.resolve(key, isArabic);
  }

  /// Same lookup without subscribing to rebuilds - for use outside build()
  /// (e.g. inside callbacks) where `watch` isn't appropriate.
  String trRead(String key) {
    final isArabic = read<AppSettingsCubit>().state.isArabic;
    return AppTranslations.resolve(key, isArabic);
  }
}
