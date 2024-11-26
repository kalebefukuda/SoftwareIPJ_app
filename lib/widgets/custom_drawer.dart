import 'package:softwareipj/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../app.dart';

class CustomDrawer extends StatefulWidget {
  final Function(ThemeModeOptions) onThemeToggle;
  final ValueNotifier<ThemeModeOptions> themeModeNotifier;

  const CustomDrawer({
    super.key,
    required this.onThemeToggle,
    required this.themeModeNotifier,
  });

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  void didUpdateWidget(covariant CustomDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void _handleThemeToggle(ThemeModeOptions mode) {
    setState(() {
      widget.themeModeNotifier.value = mode;
      widget.onThemeToggle(mode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeModeOptions>(
      valueListenable: widget.themeModeNotifier,
      builder: (context, themeMode, _) {
        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Drawer(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Column(
              children: [
                _buildMenuHeader(),
                _buildThemeToggle(themeMode),
                _buildLogoutButton(),
                const Spacer(),
                _buildAppVersionInfo(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 50, bottom: 50),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          'Menu',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontSize: 28,
              ),
        ),
      ),
    );
  }

  Widget _buildThemeToggle(ThemeModeOptions themeMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomSwitch(
            value: themeMode,
            onChanged: _handleThemeToggle,
          ),
          const SizedBox(width: 20),
          Text(
            'Tema',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(
                  onThemeToggle: widget.onThemeToggle,
                  themeModeNotifier: widget.themeModeNotifier,
                ),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PhosphorIcon(
                PhosphorIcons.signOut(),
                size: 24,
                color: Colors.white,
              ),
              const SizedBox(width: 50),
              Text(
                'Sair do app',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppVersionInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          'v.0.7.9',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}

// CustomSwitch modificado para ter três estados
class CustomSwitch extends StatelessWidget {
  final ThemeModeOptions value;
  final ValueChanged<ThemeModeOptions> onChanged;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ThemeModeOptions nextMode;
        if (value == ThemeModeOptions.light) {
          nextMode = ThemeModeOptions.system;
        } else if (value == ThemeModeOptions.system) {
          nextMode = ThemeModeOptions.dark;
        } else {
          nextMode = ThemeModeOptions.light;
        }
        onChanged(nextMode);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 70,
        height: 36,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // Indicador circular animado
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              left: value == ThemeModeOptions.light
                  ? 2
                  : value == ThemeModeOptions.system
                      ? 18
                      : 36,
              top: 2,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
                child: Center(
                  child: value == ThemeModeOptions.system
                      ? Text(
                          'AUTO',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Icon(
                          value == ThemeModeOptions.light ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                          color: Theme.of(context).colorScheme.onSecondary,
                          size: 18,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
