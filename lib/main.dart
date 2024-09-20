import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/exercices_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ExercicesProvider(),
      child: const MyApp(),
    ),
  );
}