import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(const OtpState()) {
    _startTimer();
  }

  Timer? _timer;

  void codeChanged(String code) {
    emit(state.copyWith(code: code));
  }

  Future<void> verify() async {
    if (!state.isComplete || state.isVerifying) {
      return;
    }

    emit(state.copyWith(isVerifying: true));
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!isClosed) {
      emit(state.copyWith(isVerifying: false));
    }
  }

  void resend() {
    if (!state.canResend) {
      return;
    }

    emit(state.copyWith(code: '', remainingSeconds: 30));
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }
      if (state.remainingSeconds <= 1) {
        timer.cancel();
        emit(state.copyWith(remainingSeconds: 0));
        return;
      }
      emit(state.copyWith(remainingSeconds: state.remainingSeconds - 1));
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
