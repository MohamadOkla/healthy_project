/// Stable local identifiers for the booking catalog. Display labels can change
/// without affecting filtering or selection validity.
enum HospitalId { damascusUniversity, alMouwasat, alAssadUniversity }

enum SpecialtyId { cardiology, dermatology, orthopedics, pediatrics }

extension HospitalIdLabel on HospitalId {
  String get label => switch (this) {
        HospitalId.damascusUniversity => 'مشفى دمشق الجامعي',
        HospitalId.alMouwasat => 'مشفى المواساة',
        HospitalId.alAssadUniversity => 'مشفى الأسد الجامعي',
      };
}

extension SpecialtyIdLabel on SpecialtyId {
  String get label => switch (this) {
        SpecialtyId.cardiology => 'قلبية',
        SpecialtyId.dermatology => 'جلدية',
        SpecialtyId.orthopedics => 'عظمية',
        SpecialtyId.pediatrics => 'أطفال',
      };
}
