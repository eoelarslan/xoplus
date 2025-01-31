import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  bool _isSoundOn = true;
  bool _isVibrationOn = true;

  late SharedPreferences _prefs;

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    _initPrefs().then((_) => _loadSettings());
  }

  Future<void> _loadSettings() async {
    setState(() {
      _isSoundOn = _prefs.getBool('isSoundOn') ?? true;
      _isVibrationOn = _prefs.getBool('isVibrationOn') ?? true;
    });
    _applySoundSetting(_isSoundOn);
    _applyVibrationSetting(_isVibrationOn);
  }

  Future<void> _saveSettings() async {
    await _prefs.setBool('isSoundOn', _isSoundOn);
    await _prefs.setBool('isVibrationOn', _isVibrationOn);
  }

  void _applySoundSetting(bool isOn) {
    if (isOn) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  void _applyVibrationSetting(bool isOn) {
    if (isOn) {
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currentTheme = themeProvider.currentTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 🎨 **Tema'ya Göre Değişen Gradient Renkleri**
    final List<Color> gradientColors =
        _getGradientColors(currentTheme, isDarkMode);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Text(
            '⚙️ Settings',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          centerTitle: true,
          elevation: 5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSettingCard(
              icon: Icons.volume_up,
              iconColor: Colors.blueAccent,
              title: 'Sound',
              switchValue: _isSoundOn,
              onChanged: (value) {
                setState(() => _isSoundOn = value);
                _applySoundSetting(value);
                _saveSettings();
              },
            ),
            _buildSettingCard(
              icon: Icons.vibration,
              iconColor: Colors.green,
              title: 'Vibration',
              switchValue: _isVibrationOn,
              onChanged: (value) {
                setState(() => _isVibrationOn = value);
                _applyVibrationSetting(value);
                _saveSettings();
              },
            ),
            _buildThemeCard(context, themeProvider),
          ],
        ),
      ),
    );
  }

  /// 🎨 **Tema'ya Göre Gradient Renklerini Döndüren Fonksiyon**
  List<Color> _getGradientColors(String theme, bool isDarkMode) {
    switch (theme) {
      case 'Dark':
        return [
          Colors.black,
          Colors.grey[850]!,
          Colors.grey[700]!
        ]; // Daha derin geçiş
      case 'Light':
        return [Colors.blue[100]!, Colors.blue[300]!]; // Daha soft bir etki
      case 'Deep Blue':
        return [
          const Color(0xFF0D47A1),
          const Color(0xFF1976D2)
        ]; // Daha dengeli mavi tonları
      case 'Neon Pink':
        return [
          const Color(0xFFFF0066),
          const Color(0xFFFF33AA)
        ]; // Daha parlak neon etkisi
      case 'System':
        return isDarkMode
            ? [Colors.black, Colors.grey[850]!]
            : [Colors.blue[200]!, Colors.blue[600]!];
      default:
        return [Colors.blue, Colors.blueAccent];
    }
  }

  /// 🔧 **Ortak Ayar Kartı Widget'ı**
  Widget _buildSettingCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool switchValue,
    required void Function(bool) onChanged,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        trailing: Switch(
          value: switchValue,
          activeColor: Colors.deepPurple,
          onChanged: onChanged,
        ),
      ),
    );
  }

  /// 🎨 **Tema Seçim Kartı**
  Widget _buildThemeCard(BuildContext context, ThemeProvider themeProvider) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.palette, color: Colors.purple),
        title: Text(
          'Theme',
          style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        trailing: ElevatedButton(
          onPressed: () => _showThemeDialog(context, themeProvider),
          child: Text(themeProvider.currentTheme),
        ),
      ),
    );
  }

  /// 🎨 **Tema Seçim Diyaloğu**
  void _showThemeDialog(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) {
        String selectedTheme = themeProvider.currentTheme;
        return AlertDialog(
          title: Text(
            'Select Theme',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: ['System', 'Light', 'Dark', 'Deep Blue', 'Neon Pink']
                    .map((theme) => RadioListTile<String>(
                          title: Text(theme),
                          value: theme,
                          groupValue: selectedTheme,
                          onChanged: (value) {
                            setState(() => selectedTheme = value!);
                            themeProvider.setTheme(value!);
                            Navigator.pop(context);
                          },
                        ))
                    .toList(),
              );
            },
          ),
        );
      },
    );
  }
}
