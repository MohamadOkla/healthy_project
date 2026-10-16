import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healty_app/app/cubit/app_settings_cubit.dart';
import 'package:healty_app/features/patient/presentation/screens/medical_records_screen.dart';

void main() {
  testWidgets('timeline expansion tile paints inside a Material surface',
      (tester) async {
    await tester.pumpWidget(BlocProvider(
      create: (_) => AppSettingsCubit(),
      child: const MaterialApp(home: MedicalRecordsScreen()),
    ));
    await tester.pumpAndSettle();

    expect(find.text('أحداثك الطبية'), findsOneWidget);
    expect(find.text('معلومات إضافية'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
