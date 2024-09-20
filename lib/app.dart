import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Providers/navigation_provider.dart';
import 'providers/seances_provider.dart';
import 'providers/exercices_provider.dart';
import 'screens/home_screen.dart';
import 'screens/exercices_screen.dart';
import 'screens/seances_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
        ChangeNotifierProvider(create: (context) => ExercicesProvider()),
        ChangeNotifierProvider(create: (context) => SeancesProvider()),
      ],
      child: MaterialApp(
        home: MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {

  final List<Widget> _screens = [
    const HomeScreen(),
    ExercicesScreen(),
    const SeancesScreen(),
  ];

  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        return Scaffold(
          body: _screens[navigationProvider.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: navigationProvider.currentIndex,
            onTap: (index) => navigationProvider.setIndex(index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.fitness_center),
                label: 'Exercices',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.schedule),
                label: 'Séances',
              ),
            ],
          ),
        );
      },
    );
  }
}