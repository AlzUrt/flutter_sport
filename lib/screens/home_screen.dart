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
  
  // Map des événements associés à des dates spécifiques
  final Map<DateTime, List<String>> _events = {
    DateTime.utc(2024, 9, 20): ['Séance spéciale : Yoga du matin'],
    DateTime.utc(2024, 9, 20): ['Séance spéciale : Nom spécial'],
    DateTime.utc(2024, 9, 1): ['Séance spéciale : Crossfit'],
    // Ajoute ici d'autres événements
  };

  // Méthode pour récupérer les sessions pour une date donnée
  List<String> _getSessionsForDay(DateTime date) {
    return _events[date] ?? ['Séance standard : Nom de séance'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Intégration du calendrier
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

              // Indication des événements dans le calendrier
              eventLoader: (day) {
                return _events[day] ?? [];
              },
            ),
            
            const SizedBox(height: 20),
            
            // Vérification si la date sélectionnée possède des événements
            if (_events.containsKey(_selectedDay))
              ..._getSessionsForDay(_selectedDay).map((session) => 
                SessionCard(name: session, date: _selectedDay)
              )
            else
              SessionCard(name: 'Aucun événement pour ce jour', date: _selectedDay),

            const SizedBox(height: 20),

            // Bouton pour ajouter une nouvelle séance
            CustomButton(
              text: 'Ajouter une séance',
              width: 250,
              height: 60,
              onPressed: () {
                print('Bouton cliqué !');
              },
            ),
          ],
        ),
      ),
    );
  }
}
