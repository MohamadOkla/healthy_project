import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healty_app/app/cubit/app_settings_cubit.dart';
import 'package:healty_app/features/patient/presentation/cubit/profile_cubit.dart';
import 'package:healty_app/features/patient/presentation/models/health_summary_model.dart';
import 'package:healty_app/features/patient/presentation/widgets/dashboard_header.dart';
import 'package:healty_app/features/patient/presentation/widgets/health_summary_card.dart';

void main() {
  testWidgets('summary and greeting fit a narrow screen at larger text size',
      (tester) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final profileCubit = ProfileCubit();
    addTearDown(profileCubit.close);
    final profileSave = profileCubit.saveProfile(
      fullName: 'Alexander A Very Long Patient Name For Layout Validation',
      phone: '',
      email: '',
      province: '',
      city: '',
      address: '',
    );
    await tester.pump(const Duration(milliseconds: 500));
    await profileSave;

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: profileCubit),
          BlocProvider(create: (_) => AppSettingsCubit()),
        ],
        child: MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              textScaler: TextScaler.linear(1.6),
            ),
            child: const Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        DashboardHeader(),
                        SizedBox(height: 16),
                        HealthSummaryCard(
                          summary: HealthSummaryModel(
                            lastVisit: 'منذ 123 يومًا',
                            upcomingAppointments: 123,
                            activePrescriptions: 45,
                            newResults: 6789,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.textContaining('مرحبًا،'), findsOneWidget);
    expect(find.text('123'), findsOneWidget);
    expect(find.text('45'), findsOneWidget);
    expect(find.text('6789'), findsOneWidget);
    expect(find.text('92%'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
