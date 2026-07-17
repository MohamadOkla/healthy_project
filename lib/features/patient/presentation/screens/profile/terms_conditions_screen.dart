import 'package:flutter/material.dart';
import '../../widgets/profile_text_view.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileTextView(
      title: 'شروط الاستخدام',
      sections: [
        (
          'شروط استخدام التطبيق',
          'استخدامك للتطبيق يعني الموافقة على قواعد الاستخدام والخدمات المتاحة.'
        ),
        (
          'مسؤولية المستخدم',
          'يتحمل المستخدم مسؤولية صحة البيانات المدخلة في حسابه.'
        ),
        (
          'حدود الخدمة',
          'الخدمات الحالية واجهات تجريبية قابلة للربط لاحقاً بالأنظمة الفعلية.'
        ),
        ('الموافقة على الشروط', 'استمرار الاستخدام يعني قبول هذه الشروط.'),
      ],
    );
  }
}
