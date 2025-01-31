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
    final currentTheme = themeProvider.currentTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 🎨 **Tema'ya Göre Değişen Gradient Renkleri**
    final List<Color> gradientColors = _getGradientColors(currentTheme, isDarkMode);

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
        return [Colors.black, Colors.grey[900]!];
      case 'Light':
        return [const Color.fromARGB(255, 166, 200, 234), const Color.fromARGB(255, 124, 187, 239)];
      case 'Deep Blue':
        return [const Color(0xFF1E3A5F), Colors.blueGrey[800]!];
      case 'Neon Pink':
        return [const Color(0xFFFF007F), Colors.pinkAccent];
      case 'System':
        return isDarkMode ? [Colors.black, Colors.grey[900]!] : [Colors.blue[300]!, Colors.blue[700]!];
      default:
        return [Colors.blue, Colors.blueAccent]; // Default tema
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
        return AlertDialog(
          title: Text(
            'Select Theme',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
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
