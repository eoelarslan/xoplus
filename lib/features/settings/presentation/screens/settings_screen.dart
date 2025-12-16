import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(context, "Appearance"),
          Card(
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: const Text("System Default"),
                  value: ThemeMode.system,
                  groupValue: settings.themeMode,
                  onChanged: (val) => controller.toggleTheme(val!),
                ),
                RadioListTile<ThemeMode>(
                  title: const Text("Light Mode"),
                  value: ThemeMode.light,
                  groupValue: settings.themeMode,
                  onChanged: (val) => controller.toggleTheme(val!),
                ),
                RadioListTile<ThemeMode>(
                  title: const Text("Dark Mode"),
                  value: ThemeMode.dark,
                  groupValue: settings.themeMode,
                  onChanged: (val) => controller.toggleTheme(val!),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, "Gameplay"),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text("Sound Effects"),
                  subtitle: const Text("Play sounds during game"),
                  value: settings.isSoundEnabled,
                  onChanged: (val) => controller.toggleSound(val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text("Haptic Feedback"),
                  subtitle: const Text("Vibrate on moves and win"),
                  value: settings.isHapticsEnabled,
                  onChanged: (val) => controller.toggleHaptics(val),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
      ),
    );
  }
}
