import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healty_app/core/constants/storage_keys.dart';
import 'package:healty_app/core/services/local_storage_service.dart';
import 'package:healty_app/features/doctor/data/repositories/doctor_messaging_repository.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorageService.instance.init();
    await LocalStorageService.instance.clear();
    await LocalStorageService.instance
        .setString(StorageKeys.currentUserRole, 'doctor');
  });

  test('creates a pair conversation only after a non-empty first message',
      () async {
    final repository = DoctorMessagingRepository(currentDoctorId: 'd1');
    expect(
        repository.otherDoctors().any((doctor) => doctor.id == 'd1'), isFalse);
    expect(repository.conversationsFor('d1'), isEmpty);
    expect(
      await repository.sendMessage(
        doctorId: 'd1',
        peerId: 'd1',
        text: 'رسالة لنفسي',
      ),
      DoctorMessageSendResult.invalidRecipient,
    );
    expect(
      await repository.sendMessage(
        doctorId: 'd1',
        peerId: 'd2',
        text: '   ',
      ),
      DoctorMessageSendResult.failed,
    );
    expect(repository.conversationsFor('d1'), isEmpty);

    expect(
      await repository.sendMessage(
        doctorId: 'd1',
        peerId: 'd2',
        text: '  مرحبًا دكتورة  ',
        sentAt: DateTime(2026, 10, 16, 9, 30),
      ),
      DoctorMessageSendResult.sent,
    );
    expect(repository.conversationsFor('d1'), hasLength(1));
    expect(repository.messagesFor('d1', 'd2').single.text, 'مرحبًا دكتورة');
  });

  test('reuses the same conversation and limits visibility to participants',
      () async {
    final doctorOne = DoctorMessagingRepository(currentDoctorId: 'd1');
    final doctorTwo = DoctorMessagingRepository(currentDoctorId: 'd2');
    await doctorOne.sendMessage(
      doctorId: 'd1',
      peerId: 'd2',
      text: 'هل يمكنك مراجعة الحالة؟',
      sentAt: DateTime(2026, 10, 16, 9),
    );
    await doctorTwo.sendMessage(
      doctorId: 'd2',
      peerId: 'd1',
      text: 'نعم، سأراجعها الآن.',
      sentAt: DateTime(2026, 10, 16, 9, 5),
    );

    expect(doctorOne.conversationsFor('d1'), hasLength(1));
    expect(doctorTwo.conversationsFor('d2'), hasLength(1));
    expect(doctorTwo.messagesFor('d2', 'd1').map((message) => message.text), [
      'هل يمكنك مراجعة الحالة؟',
      'نعم، سأراجعها الآن.',
    ]);

    final doctorThree = DoctorMessagingRepository(currentDoctorId: 'd3');
    expect(doctorThree.conversationsFor('d3'), isEmpty);
    expect(doctorThree.messagesFor('d3', 'd1'), isEmpty);
    expect(
      await doctorThree.sendMessage(
        doctorId: 'd1',
        peerId: 'd2',
        text: 'لا ينبغي أن تصل',
      ),
      DoctorMessageSendResult.unauthorized,
    );
  });

  test('search filters by name, specialty, or hospital', () {
    final repository = DoctorMessagingRepository(currentDoctorId: 'd1');
    expect(repository.otherDoctors(query: 'رانيا').single.id, 'd2');
    expect(repository.otherDoctors(query: 'جلدية').single.id, 'd2');
    expect(repository.otherDoctors(query: 'المواساة').length, 2);
  });

  test('local doctor account identity switches without duplicating chats',
      () async {
    await LocalStorageService.instance
        .setString(StorageKeys.currentDoctorAccountId, 'd1');
    final repository = DoctorMessagingRepository();
    await repository.sendMessage(
      doctorId: 'd1',
      peerId: 'd2',
      text: 'رسالة أولى',
    );

    expect(await repository.selectLocalDemoDoctor('d2'), isTrue);
    expect(repository.currentDoctorId, 'd2');
    expect(repository.conversationsFor('d2'), hasLength(1));
    await repository.sendMessage(
      doctorId: 'd2',
      peerId: 'd1',
      text: 'رد',
    );
    expect(repository.conversationsFor('d2'), hasLength(1));
  });
}
