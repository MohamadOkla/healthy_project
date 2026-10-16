import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/doctor_messaging_cubit.dart';

class DoctorChatScreen extends StatefulWidget {
  const DoctorChatScreen({super.key, required this.peerId});

  final String peerId;

  @override
  State<DoctorChatScreen> createState() => _DoctorChatScreenState();
}

class _DoctorChatScreenState extends State<DoctorChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  late final DoctorMessagingCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = DoctorMessagingCubit()..openConversation(widget.peerId);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _cubit.close();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _messageController.text;
    if (text.trim().isEmpty) return;
    final sent = await _cubit.send(text);
    if (sent && mounted) _messageController.clear();
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
        value: _cubit,
        child: BlocBuilder<DoctorMessagingCubit, DoctorMessagingState>(
          builder: (context, state) {
            final peer = _cubit.doctorById(widget.peerId);
            return Scaffold(
              appBar: AppBar(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(peer?.name ?? 'محادثة الطبيب'),
                    if (peer != null)
                      Text(
                        '${peer.specialty} · ${peer.hospital}',
                        style: AppTextStyles.bodyMedium(context).copyWith(
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              body: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state.error != null && state.messages.isEmpty
                      ? AppErrorState(
                          title: 'تعذر فتح المحادثة',
                          message: state.error,
                          onRetry: () => _cubit.openConversation(widget.peerId),
                        )
                      : Column(
                          children: [
                            Expanded(
                              child: state.messages.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'ابدأ المحادثة بإرسال أول رسالة.',
                                      ),
                                    )
                                  : ListView.builder(
                                      reverse: true,
                                      padding: const EdgeInsets.all(
                                        AppSpacing.md,
                                      ),
                                      itemCount: state.messages.length,
                                      itemBuilder: (context, index) {
                                        final message = state.messages[
                                            state.messages.length - 1 - index];
                                        final isMine = message.senderId ==
                                            _cubit.currentDoctorId;
                                        return Align(
                                          alignment: isMine
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                          child: Container(
                                            constraints: BoxConstraints(
                                              maxWidth:
                                                  MediaQuery.sizeOf(context)
                                                          .width *
                                                      0.78,
                                            ),
                                            margin: const EdgeInsets.only(
                                              bottom: AppSpacing.sm,
                                            ),
                                            padding: const EdgeInsets.all(
                                              AppSpacing.md,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isMine
                                                  ? AppColors.primary
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .surfaceContainerHighest,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                AppRadius.lg,
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  message.text,
                                                  style:
                                                      AppTextStyles.bodyMedium(
                                                              context)
                                                          .copyWith(
                                                    color: isMine
                                                        ? Colors.white
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .onSurface,
                                                  ),
                                                ),
                                                const SizedBox(
                                                    height: AppSpacing.xs),
                                                Text(
                                                  _formatTime(message.sentAt),
                                                  style:
                                                      AppTextStyles.bodyMedium(
                                                              context)
                                                          .copyWith(
                                                    fontSize: 11,
                                                    color: isMine
                                                        ? Colors.white70
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .onSurfaceVariant,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                            if (state.sendError && state.error != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        state.error!,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ),
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: state.isSending ? null : _send,
                                      icon: const Icon(Icons.refresh_rounded),
                                      label: const Text('إعادة المحاولة'),
                                    ),
                                  ],
                                ),
                              ),
                            SafeArea(
                              top: false,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  AppSpacing.md,
                                  AppSpacing.sm,
                                  AppSpacing.md,
                                  AppSpacing.md,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: AppTextField(
                                        controller: _messageController,
                                        hint: 'اكتب رسالة للطبيب',
                                        maxLines: 4,
                                        textInputAction:
                                            TextInputAction.newline,
                                        onChanged: (_) =>
                                            _cubit.clearSendError(),
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    IconButton.filled(
                                      tooltip: 'إرسال',
                                      onPressed: state.isSending ||
                                              _messageController.text
                                                  .trim()
                                                  .isEmpty
                                          ? null
                                          : _send,
                                      icon: state.isSending
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const Icon(Icons.send_rounded),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
            );
          },
        ),
      );

  String _formatTime(DateTime date) => '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')} '
      '${date.hour.toString().padLeft(2, '0')}:'
      '${date.minute.toString().padLeft(2, '0')}';
}
