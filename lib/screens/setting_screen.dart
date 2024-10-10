import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sport/app.dart';
import 'package:sport/config/custom_themes.dart';
import 'package:sport/widgets/custom_button.dart';
import 'package:sport/widgets/session_card.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Changer le thème',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.color_lens, color: CustomThemes.blueTheme.primaryColor),
            title: const Text('Bleu'),
            onTap: () {
              Provider.of<ThemeProvider>(context, listen: false)
                  .setTheme(CustomThemes.blueTheme);
            },
          ),
          ListTile(
            leading: Icon(Icons.color_lens, color: CustomThemes.redTheme.primaryColor),
            title: const Text('Rouge'),
            onTap: () {
              Provider.of<ThemeProvider>(context, listen: false)
                  .setTheme(CustomThemes.redTheme);
            },
          ),
          ListTile(
            leading: Icon(Icons.color_lens, color: CustomThemes.greenTheme.primaryColor),
            title: const Text('Vert'),
            onTap: () {
              Provider.of<ThemeProvider>(context, listen: false)
                  .setTheme(CustomThemes.greenTheme);
            },
          ),
          ListTile(
            leading: Icon(Icons.color_lens, color: CustomThemes.yellowTheme.primaryColor),
            title: const Text('Jaune'),
            onTap: () {
              Provider.of<ThemeProvider>(context, listen: false)
                  .setTheme(CustomThemes.yellowTheme);
            },
          ),
        ],
      ),
    );
  }
}
