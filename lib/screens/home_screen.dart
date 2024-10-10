import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sport/widgets/custom_button.dart';
import 'package:sport/widgets/session_card.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sport/providers/calendar_provider.dart';
import 'package:sport/providers/sessions_provider.dart';
import 'package:sport/domain/calendar_event.dart';
import 'package:sport/domain/session.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  bool _isRecurring = false;
  int _selectedWeekday = DateTime.now().weekday;
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<CalendarProvider>(
              builder: (context, calendarProvider, child) {
                return TableCalendar(
                  firstDay: DateTime.utc(2000, 1, 1),
                  lastDay: DateTime.utc(2050, 12, 31),
                  locale: 'fr',
                  startingDayOfWeek: StartingDayOfWeek.monday,
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
                    return calendarProvider.getEventsForDay(day);
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            Consumer<CalendarProvider>(
              builder: (context, calendarProvider, child) {
                final eventsForSelectedDay =
                    calendarProvider.getEventsForDay(_selectedDay);
                return Column(
                  children: eventsForSelectedDay.isEmpty
                      ? [
                          SessionCard(
                              name: 'Aucune séance pour ce jour',
                              date: _selectedDay)
                        ]
                      : eventsForSelectedDay
                          .map(
                            (event) => SessionCard(
                              name: event.session.nom,
                              date: event.date,
                              onDelete: () {
                                _showDeleteConfirmationDialog(context, event);
                              },
                            ),
                          )
                          .toList(),
                );
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Ajouter une séance',
              width: 250,
              height: 60,
              onPressed: () {
                _showAddSessionDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSessionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Session? selectedSession;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Ajouter une séance'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Consumer<SessionsProvider>(
                      builder: (context, sessionsProvider, child) {
                        return DropdownButton<Session>(
                          value: selectedSession,
                          hint: const Text('Sélectionner une séance'),
                          items:
                              sessionsProvider.sessions.map((Session session) {
                            return DropdownMenuItem<Session>(
                              value: session,
                              child: Text(session.nom),
                            );
                          }).toList(),
                          onChanged: (Session? newValue) {
                            setState(() {
                              selectedSession = newValue;
                            });
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Text('Récurrent: '),
                        Switch(
                          value: _isRecurring,
                          onChanged: (bool value) {
                            setState(() {
                              _isRecurring = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (_isRecurring)
                      DropdownButton<int>(
                        value: _selectedWeekday,
                        items: const [
                          DropdownMenuItem(
                              child: Text('Lundi'), value: DateTime.monday),
                          DropdownMenuItem(
                              child: Text('Mardi'), value: DateTime.tuesday),
                          DropdownMenuItem(
                              child: Text('Mercredi'),
                              value: DateTime.wednesday),
                          DropdownMenuItem(
                              child: Text('Jeudi'), value: DateTime.thursday),
                          DropdownMenuItem(
                              child: Text('Vendredi'), value: DateTime.friday),
                          DropdownMenuItem(
                              child: Text('Samedi'), value: DateTime.saturday),
                          DropdownMenuItem(
                              child: Text('Dimanche'), value: DateTime.sunday),
                        ],
                        onChanged: (int? newValue) {
                          setState(() {
                            _selectedWeekday = newValue!;
                          });
                        },
                      )
                    else
                      Row(
                        children: [
                          Text(
                              'Date: ${_selectedDate.toString().split(' ')[0]}'),
                          IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                                locale: const Locale('fr'),
                              );
                              if (picked != null && picked != _selectedDate) {
                                setState(() {
                                  _selectedDate = picked;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Annuler'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Ajouter'),
                  onPressed: () {
                    if (selectedSession != null) {
                      if (_isRecurring) {
                        for (int i = 0; i < 52; i++) {
                          DateTime eventDate =
                              _selectedDate.add(Duration(days: i * 7));
                          while (eventDate.weekday != _selectedWeekday) {
                            eventDate = eventDate.add(const Duration(days: 1));
                          }
                          Provider.of<CalendarProvider>(context, listen: false)
                              .addEvent(CalendarEvent(
                                  date: eventDate, session: selectedSession!));
                        }
                      } else {
                        Provider.of<CalendarProvider>(context, listen: false)
                            .addEvent(CalendarEvent(
                                date: _selectedDate,
                                session: selectedSession!));
                      }
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, CalendarEvent event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Supprimer séance'),
          content: const Text(
              'Voulez-vous supprimer uniquement cette séance ou toutes les séances futures ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Supprimer uniquement'),
              onPressed: () {
                Provider.of<CalendarProvider>(context, listen: false)
                    .removeEvent(event);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Supprimer toutes les séances futures'),
              onPressed: () {
                Provider.of<CalendarProvider>(context, listen: false)
                    .removeFutureEvents(event);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
