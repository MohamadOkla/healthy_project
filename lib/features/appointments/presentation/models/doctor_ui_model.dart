import 'package:flutter/material.dart';
import 'booking_ids.dart';

class DoctorUiModel {
  const DoctorUiModel({
    required this.id,
    required this.name,
    required this.specialtyId,
    required this.hospitalId,
    required this.specialty,
    required this.hospital,
    required this.rating,
    required this.experience,
    required this.icon,
    this.phone = '—',
    this.email = '—',
  });

  final String id;
  final String name;
  final SpecialtyId specialtyId;
  final HospitalId hospitalId;
  final String specialty;
  final String hospital;
  final double rating;
  final String experience;
  final IconData icon;
  final String phone;
  final String email;
}
