import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/repositories/doctor_messaging_repository.dart';

class NewDoctorMessageScreen extends StatefulWidget {
  const NewDoctorMessageScreen({super.key});

  @override
  State<NewDoctorMessageScreen> createState() => _NewDoctorMessageScreenState();
}

class _NewDoctorMessageScreenState extends State<NewDoctorMessageScreen> {
  final DoctorMessagingRepository _repository = DoctorMessagingRepository();
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final doctors = _repository.otherDoctors(query: _query);
    return Scaffold(
      appBar: AppBar(title: const Text('اختيار طبيب')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: AppTextField(
              controller: _searchController,
              hint: 'ابحث بالاسم أو الاختصاص أو المشفى',
              prefixIcon: const Icon(Icons.search_rounded),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Expanded(
            child: doctors.isEmpty
                ? const Center(
                    child: AppEmptyState(
                      title: 'لا توجد نتائج',
                      message: 'جرّب اسمًا أو اختصاصًا أو مشفى آخر.',
                      icon: Icons.person_search_rounded,
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      0,
                      AppSpacing.md,
                      AppSpacing.lg,
                    ),
                    itemCount: doctors.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final doctor = doctors[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(child: Icon(doctor.icon)),
                          title: Text(doctor.name),
                          subtitle: Text(
                            '${doctor.specialty} · ${doctor.hospital}',
                          ),
                          trailing: const Icon(Icons.chevron_left_rounded),
                          onTap: () => context.push(
                            AppRoutes.doctorMessageChat.replaceFirst(
                              ':peerId',
                              doctor.id,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
