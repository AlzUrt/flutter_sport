import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Providers/navigation_provider.dart';
import 'providers/seances_provider.dart';
import 'providers/exercices_provider.dart';
import 'package:sport/config/custom_themes.dart';
import 'package:sport/screens/setting_screen.dart';
import 'screens/home_screen.dart';
import 'screens/exercices_screen.dart';
import 'screens/seances_screen.dart';
import 'screens/profile_screen.dart';

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
        ChangeNotifierProvider(create: (context) => ExercicesProvider()),
        ChangeNotifierProvider(create: (context) => SeancesProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
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
    ExercicesScreen(),
    const SeancesScreen(),
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
            currentIndex: navigationProvider.currentIndex,
            onTap: (index) => navigationProvider.setIndex(index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Planning',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.fitness_center),
                label: 'Exercices',
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
