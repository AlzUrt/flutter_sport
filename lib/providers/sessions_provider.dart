import 'package:flutter/foundation.dart';
import '../domain/session.dart';

class SessionsProvider with ChangeNotifier {
  final List<Session> _sessions = [];

  List<Session> get sessions => _sessions;

  void addSession(Session session) {
    _sessions.add(session);
    notifyListeners();
  }

  void deleteSession(int index) {
    _sessions.removeAt(index);
    notifyListeners();
  }
}
