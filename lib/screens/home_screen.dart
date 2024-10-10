import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sport/widgets/custom_button.dart';
import 'package:sport/widgets/session_card.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sport/providers/calendar_provider.dart';
import 'package:sport/providers/seances_provider.dart';
import 'package:sport/domain/calendar_event.dart';
import 'package:sport/domain/seance.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

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
                final eventsForSelectedDay = calendarProvider.getEventsForDay(_selectedDay);
                return Column(
                  children: eventsForSelectedDay.isEmpty
                    ? [SessionCard(name: 'Aucun événement pour ce jour', date: _selectedDay)]
                    : eventsForSelectedDay.map((event) => 
                        SessionCard(name: event.seance.nom, date: event.date)
                      ).toList(),
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
        Seance? selectedSeance;
        return AlertDialog(
          title: Text('Ajouter une séance'),
          content: Consumer<SeancesProvider>(
            builder: (context, seancesProvider, child) {
              return DropdownButton<Seance>(
                value: selectedSeance,
                hint: Text('Sélectionner une séance'),
                items: seancesProvider.seances.map((Seance seance) {
                  return DropdownMenuItem<Seance>(
                    value: seance,
                    child: Text(seance.nom),
                  );
                }).toList(),
                onChanged: (Seance? newValue) {
                  setState(() {
                    selectedSeance = newValue;
                  });
                },
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Ajouter'),
              onPressed: () {
                if (selectedSeance != null) {
                  Provider.of<CalendarProvider>(context, listen: false).addEvent(
                    CalendarEvent(date: _selectedDay, seance: selectedSeance!)
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}