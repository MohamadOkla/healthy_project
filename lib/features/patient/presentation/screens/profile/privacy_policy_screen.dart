import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_routes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ProfileTextScreen(
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

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ProfileTextScreen(
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

class _ProfileTextScreen extends StatelessWidget {
  const _ProfileTextScreen({
    required this.title,
    required this.sections,
  });

  final String title;
  final List<(String, String)> sections;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.go(AppRoutes.patientProfile),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(title),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: sections.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.lg),
        itemBuilder: (context, index) {
          final section = sections[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(section.$1, style: AppTextStyles.titleMedium(context)),
              const SizedBox(height: AppSpacing.sm),
              Text(section.$2, style: AppTextStyles.bodyMedium(context)),
            ],
          );
        },
      ),
    );
  }
}
