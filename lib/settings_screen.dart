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
    // Uygulama başladığında ayarları uygula
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Sound'),
              value: _isSoundOn,
              onChanged: (value) {
                setState(() => _isSoundOn = value);
                _applySoundSetting(value);
                _saveSettings();
              },
            ),
            SwitchListTile(
              title: const Text('Vibration'),
              value: _isVibrationOn,
              onChanged: (value) {
                setState(() => _isVibrationOn = value);
                _applyVibrationSetting(value);
                _saveSettings();
              },
            ),
            DropdownButtonFormField<String>(
              value: themeProvider.currentTheme,
              items: ['Light', 'Dark', 'Blue', 'Green']
                  .map((theme) => DropdownMenuItem(
                        value: theme,
                        child: Text(theme),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  themeProvider.setTheme(value);
                }
              },
              decoration: const InputDecoration(labelText: 'Theme'),
            ),
          ],
        ),
      ),
    );
  }
}