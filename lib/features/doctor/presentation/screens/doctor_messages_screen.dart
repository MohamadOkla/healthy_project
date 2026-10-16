import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../cubit/doctor_messaging_cubit.dart';

class DoctorMessagesScreen extends StatelessWidget {
  const DoctorMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => DoctorMessagingCubit()..loadInbox(),
        child: const _DoctorMessagesView(),
      );
}

class _DoctorMessagesView extends StatelessWidget {
  const _DoctorMessagesView();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('مراسلة الأطباء'),
          leading: IconButton(
            tooltip: 'العودة إلى لوحة الطبيب',
            onPressed: () => context.go(AppRoutes.doctor),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          actions: [
            IconButton(
              tooltip: 'تبديل طبيب التجربة',
              onPressed: () => _selectLocalDoctor(context),
              icon: const Icon(Icons.switch_account_rounded),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push(AppRoutes.doctorMessageNew),
          icon: const Icon(Icons.person_add_alt_1_rounded),
          label: const Text('محادثة جديدة'),
        ),
        body: BlocBuilder<DoctorMessagingCubit, DoctorMessagingState>(
          builder: (context, state) {
            final cubit = context.read<DoctorMessagingCubit>();
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null) {
              return AppErrorState(
                title: 'تعذر تحميل المحادثات',
                message: state.error,
                onRetry: cubit.loadInbox,
              );
            }
            if (state.conversations.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: AppEmptyState(
                    title: 'لا توجد محادثات بعد',
                    message:
                        'ابدأ محادثة مع طبيب آخر. لن تُنشأ المحادثة إلا عند إرسال أول رسالة.',
                    icon: Icons.forum_outlined,
                  ),
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: cubit.loadInbox,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  96,
                ),
                itemCount: state.conversations.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final conversation = state.conversations[index];
                  final peerId = conversation.doctorIds.firstWhere(
                    (id) => id != cubit.currentDoctorId,
                  );
                  final doctor = cubit.doctorById(peerId);
                  if (doctor == null) return const SizedBox.shrink();
                  final last = conversation.lastMessage;
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.12),
                        child: Icon(doctor.icon, color: AppColors.primary),
                      ),
                      title: Text(
                        doctor.name,
                        style: AppTextStyles.titleMedium(context)
                            .copyWith(fontSize: 16),
                      ),
                      subtitle: Text(
                        last.text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(_formatTime(last.sentAt)),
                      onTap: () => context.push(
                        AppRoutes.doctorMessageChat.replaceFirst(
                          ':peerId',
                          peerId,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      );

  String _formatTime(DateTime date) => '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')} '
      '${date.hour.toString().padLeft(2, '0')}:'
      '${date.minute.toString().padLeft(2, '0')}';

  Future<void> _selectLocalDoctor(BuildContext context) async {
    final cubit = context.read<DoctorMessagingCubit>();
    final current = cubit.doctorById(cubit.currentDoctorId);
    final doctors = [
      ...cubit.otherDoctors(),
      if (current != null) current,
    ]..sort((left, right) => left.name.compareTo(right.name));
    final selectedId = await showDialog<String>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('تبديل طبيب التجربة'),
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: Text(
              'هذه النسخة لا تحفظ هوية الطبيب من تسجيل الدخول. اختر هوية محلية لتجربة المحادثة بين الأطباء على هذا الجهاز.',
            ),
          ),
          ...doctors.map(
            (doctor) => SimpleDialogOption(
              onPressed: () => Navigator.pop(dialogContext, doctor.id),
              child: Text('${doctor.name} · ${doctor.specialty}'),
            ),
          ),
        ],
      ),
    );
    if (selectedId == null || !context.mounted) return;
    await cubit.selectLocalDemoDoctor(selectedId);
  }
}
