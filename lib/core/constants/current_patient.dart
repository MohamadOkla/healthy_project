/// This demo supports logging in as exactly one patient account. Every
/// patient-side screen that needs "my records" and every doctor-side screen
/// that looks up "this particular patient" both key off this same id, so
/// data entered from either side of the app shows up on the other.
const String currentPatientId = 'p1';
