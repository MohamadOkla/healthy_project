import 'package:flutter/material.dart';
import '../../widgets/profile_text_view.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileTextView(
      title: 'سياسة الخصوصية',
      sections: [
        (
          'حماية البيانات الطبية',
          'نلتزم بحماية بياناتك الصحية وعدم عرضها إلا ضمن الخدمات الطبية المصرح بها.'
        ),
        (
          'خصوصية الحساب',
          'تتم حماية بيانات الحساب ومعلومات التواصل باستخدام ضوابط وصول داخلية.'
        ),
        (
          'صلاحيات الوصول',
          'تُستخدم الصلاحيات فقط لتقديم الخدمات المطلوبة داخل التطبيق.'
        ),
        (
          'استخدام المعلومات',
          'تُستخدم المعلومات لتحسين تجربة الخدمات الصحية ومتابعة الطلبات.'
        ),
      ],
    );
  }
}
