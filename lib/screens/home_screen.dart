import 'package:flutter/material.dart';
import 'package:sport/widgets/custom_button.dart';
import 'package:sport/widgets/session_card.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final List<String> _availableSessions = [
    'Yoga du matin',
    'Nom spécial',
    'Crossfit',
  ];

  final Map<DateTime, List<String>> _events = {
    DateTime.utc(2024, 10, 20): ['Séance spéciale : Yoga du matin'],
    DateTime.utc(2024, 10, 1): ['Séance spéciale : Crossfit'],
  };

  List<String> _getSessionsForDay(DateTime date) {
    return _events[date] ?? [];
  }

  void _showAddEventDialog() {
    String? selectedSession;
    bool isRecurring = false;
    DateTime? selectedDate;
    String? selectedWeekday;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ajouter une séance'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Sélectionnez une séance'),
                      items: _availableSessions.map((session) {
                        return DropdownMenuItem(
                          value: session,
                          child: Text(session),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSession = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    CheckboxListTile(
                      title: const Text('Séance récurrente'),
                      value: isRecurring,
                      onChanged: (value) {
                        setState(() {
                          isRecurring = value!;
                        });
                      },
                    ),
                    if (isRecurring)
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Jour de la semaine'),
                        items: [
                          'Lundi',
                          'Mardi',
                          'Mercredi',
                          'Jeudi',
                          'Vendredi',
                          'Samedi',
                          'Dimanche'
                        ].map((day) {
                          return DropdownMenuItem(
                            value: day,
                            child: Text(day),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedWeekday = value;
                          });
                        },
                      )
                    else
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Date de l’événement'),
                        readOnly: true,
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2050),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                        controller: TextEditingController(
                          text: selectedDate != null
                              ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                              : '',
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedSession != null) {
                  setState(() {
                    if (isRecurring && selectedWeekday != null) {
                      // Ajouter un événement récurrent
                      for (int i = 0; i < 365; i++) {
                        DateTime potentialDate = DateTime.now().add(Duration(days: i));
                        if (_getWeekdayName(potentialDate) == selectedWeekday) {
                          if (_events[DateTime(potentialDate.year, potentialDate.month, potentialDate.day)] == null) {
                            _events[DateTime(potentialDate.year, potentialDate.month, potentialDate.day)] = [];
                          }
                          _events[DateTime(potentialDate.year, potentialDate.month, potentialDate.day)]?.add(selectedSession!);
                        }
                      }
                    } else if (selectedDate != null) {
                      // Ajouter un événement ponctuel
                      DateTime eventDate = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day);
                      if (_events[eventDate] == null) {
                        _events[eventDate] = [];
                      }
                      _events[eventDate]?.add(selectedSession!);
                    }
                    // Mise à jour de l'état pour forcer la mise à jour du calendrier
                    _focusedDay = DateTime.now();
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  String _getWeekdayName(DateTime date) {
    switch (date.weekday) {
      case 1:
        return 'Lundi';
      case 2:
        return 'Mardi';
      case 3:
        return 'Mercredi';
      case 4:
        return 'Jeudi';
      case 5:
        return 'Vendredi';
      case 6:
        return 'Samedi';
      case 7:
        return 'Dimanche';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2000, 1, 1),
              lastDay: DateTime.utc(2050, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarFormat: CalendarFormat.month,
              eventLoader: (day) {
                return _events[DateTime(day.year, day.month, day.day)] ?? [];
              },
            ),
            const SizedBox(height: 20),
            if (_events.containsKey(DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day)))
              ..._getSessionsForDay(DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day)).map((session) =>
                  SessionCard(name: session, date: _selectedDay))
            else
              SessionCard(name: 'Aucun événement pour ce jour', date: _selectedDay),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Ajouter une séance',
              width: 250,
              height: 60,
              onPressed: _showAddEventDialog,
            ),
          ],
        ),
      ),
    );
  }
}
