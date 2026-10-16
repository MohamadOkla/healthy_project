import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healty_app/features/patient/presentation/widgets/profile_section_card.dart';

void main() {
  testWidgets('profile ListTiles have a Material surface for ink',
      (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: ProfileSectionCard(
          title: 'الحساب',
          items: [
            ProfileSectionItem(
              icon: Icons.person,
              title: 'حسابي',
              onTap: () => tapped = true,
            ),
          ],
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    await tester.tap(find.text('حسابي'));
    expect(tapped, isTrue);
    expect(tester.takeException(), isNull);
  });
}
