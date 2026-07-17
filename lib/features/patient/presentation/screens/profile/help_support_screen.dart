import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_routes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_text_field.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.go(AppRoutes.patientProfile),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('المساعدة والدعم'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const ExpansionTile(
            leading: Icon(Icons.question_answer_rounded),
            title: Text('الأسئلة الشائعة'),
            children: [
              ListTile(
                title: Text('كيف أحجز موعداً؟'),
                subtitle:
                    Text('من تبويب الحجز أو شاشة المواعيد اختر حجز موعد جديد.'),
              ),
              ListTile(
                title: Text('أين أجد نتائج التحاليل؟'),
                subtitle:
                    Text('من قسم التحاليل في الصفحة الرئيسية أو القائمة.'),
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.support_agent_rounded),
            title: const Text('التواصل مع الدعم'),
            onTap: () => _showDialog(
              context,
              'التواصل مع الدعم',
              'يمكنك التواصل مع الدعم عبر البريد support@digital-health.example',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.emergency_rounded),
            title: const Text('رقم الطوارئ'),
            onTap: () => _showDialog(context, 'رقم الطوارئ', 'اتصل على 937'),
          ),
          ListTile(
            leading: const Icon(Icons.feedback_rounded),
            title: const Text('إرسال ملاحظة'),
            onTap: _showFeedbackSheet,
          ),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('تم'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppSpacing.md,
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom + AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              controller: _feedbackController,
              label: 'ملاحظتك',
              maxLines: 4,
              prefixIcon: const Icon(Icons.edit_note_rounded),
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              text: 'إرسال',
              onPressed: () {
                sheetContext.pop();
                _feedbackController.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم إرسال الملاحظة')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
