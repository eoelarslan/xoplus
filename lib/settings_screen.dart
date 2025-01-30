import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  bool _isSoundOn = true;
  bool _isVibrationOn = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSoundOn = prefs.getBool('isSoundOn') ?? true;
      _isVibrationOn = prefs.getBool('isVibrationOn') ?? true;
    });
    _applySoundSetting(_isSoundOn);
    _applyVibrationSetting(_isVibrationOn);
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSoundOn', _isSoundOn);
    await prefs.setBool('isVibrationOn', _isVibrationOn);
  }

  void _applySoundSetting(bool isOn) {
    if (isOn) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  void _applyVibrationSetting(bool isOn) {
    if (isOn) {
      HapticFeedback.mediumImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: themeProvider.themeData.appBarTheme.backgroundColor, // **Doğrudan ThemeProvider'dan al**
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// 🔊 Ses Ayarı
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: const Icon(Icons.volume_up, color: Colors.blueAccent),
                title: const Text('Sound'),
                trailing: Switch(
                  value: _isSoundOn,
                  onChanged: (value) {
                    setState(() => _isSoundOn = value);
                    _applySoundSetting(value);
                    _saveSettings();
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),

            /// 📳 Titreşim Ayarı
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: const Icon(Icons.vibration, color: Colors.green),
                title: const Text('Vibration'),
                trailing: Switch(
                  value: _isVibrationOn,
                  onChanged: (value) {
                    setState(() => _isVibrationOn = value);
                    _applyVibrationSetting(value);
                    _saveSettings();
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),

            /// 🎨 Tema Seçimi
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: const Icon(Icons.palette, color: Colors.purple),
                title: const Text('Theme'),
                trailing: ElevatedButton(
                  onPressed: () => _showThemeDialog(context, themeProvider),
                  child: Text(themeProvider.currentTheme),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🎨 Tema Seçim Diyaloğu
  void _showThemeDialog(BuildContext context, ThemeProvider themeProvider) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['System', 'Light', 'Dark', 'Deep Blue', 'Neon Pink']
              .map((theme) => ListTile(
                    title: Text(theme),
                    onTap: () {
                      themeProvider.setTheme(theme);
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
          ),
        );
      },
    );
  }
}
