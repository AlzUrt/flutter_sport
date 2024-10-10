import 'package:flutter/material.dart';
import 'package:sport/domain/calendar_event.dart';

class CalendarProvider with ChangeNotifier {
  final List<CalendarEvent> _events = [];

  List<CalendarEvent> get events => _events;

  void addEvent(CalendarEvent event) {
    _events.add(event);
    notifyListeners();
  }

  void removeEvent(CalendarEvent event) {
    _events.remove(event);
    notifyListeners();
  }

  void removeFutureEvents(CalendarEvent event) {
    _events.removeWhere((e) =>
        e.session == event.session &&
        (e.date.isAfter(event.date) || isSameDay(e.date, event.date)));
    notifyListeners();
  }

  List<CalendarEvent> getEventsForDay(DateTime day) {
    return _events.where((event) => isSameDay(event.date, day)).toList();
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
