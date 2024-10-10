import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Providers/navigation_provider.dart';
import 'providers/sessions_provider.dart';
import 'providers/calendar_provider.dart';
import 'providers/exercises_provider.dart';
import 'package:sport/config/custom_themes.dart';
import 'package:sport/screens/setting_screen.dart';
import 'screens/home_screen.dart';
import 'screens/exercises_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/sessions_screen.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _currentTheme = CustomThemes.blueTheme;

  ThemeData get currentTheme => _currentTheme;

  void setTheme(ThemeData theme) {
    _currentTheme = theme;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
        ChangeNotifierProvider(create: (context) => ExercisesProvider()),
        ChangeNotifierProvider(create: (context) => SessionsProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CalendarProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('fr'), // Ajouter le français
            ],
            debugShowCheckedModeBanner: false,
            theme: themeProvider.currentTheme,
            home: MainScreen(),
          );
        },
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  final List<Widget> _screens = [
    const HomeScreen(),
    ExercisesScreen(),
    const SessionsScreen(),
    const SettingScreen(),
  ];

  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('SportApp'),
          ),
          body: _screens[navigationProvider.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: navigationProvider.currentIndex,
            onTap: (index) => navigationProvider.setIndex(index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Planning',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.fitness_center),
                label: 'Exercises',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.workspace_premium_sharp),
                label: 'Séances',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Paramètres',
              ),
            ],
          ),
        );
      },
    );
  }
}
