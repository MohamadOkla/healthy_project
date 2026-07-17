import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/book_appointment_cubit.dart';
import '../widgets/book_appointment_view.dart';

class BookAppointmentScreen extends StatelessWidget {
  const BookAppointmentScreen({super.key, this.cubit});

  final BookAppointmentCubit? cubit;

  @override
  Widget build(BuildContext context) {
    final existingCubit = cubit;
    if (existingCubit != null) {
      return BlocProvider.value(
        value: existingCubit,
        child: const BookAppointmentView(),
      );
    }

    return BlocProvider(
      create: (_) => BookAppointmentCubit(),
      child: const BookAppointmentView(),
    );
  }
}
