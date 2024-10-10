import 'package:sport/domain/seance.dart';

class CalendarEvent {
  final DateTime date;
  final Seance seance;

  CalendarEvent({required this.date, required this.seance});
}