import 'package:sport/domain/session.dart';

class CalendarEvent {
  final DateTime date;
  final Session session;

  CalendarEvent({required this.date, required this.session});
}
