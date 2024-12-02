import 'package:softwareipj/screens/create_members.dart';
import 'package:softwareipj/widgets/screen_scale_wrapper.dart';
import 'package:softwareipj/screens/members.dart';
import 'package:softwareipj/screens/report.dart';
import 'package:flutter/material.dart';
import '../widgets/card_register.dart';
import '../widgets/card_members.dart';
import '../widgets/card_report_home.dart';
import '../widgets/card_count_members.dart';
import '../widgets/custom_drawer.dart';
import 'package:softwareipj/app.dart';

class HomeScreen extends StatefulWidget {
  final Function(ThemeModeOptions) onThemeToggle;
  final ValueNotifier<ThemeModeOptions> themeModeNotifier;

  const HomeScreen({
    super.key,
    required this.onThemeToggle,
    required this.themeModeNotifier,
  });

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenScaleWrapper(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: AppBar(
              toolbarHeight: 90,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              scrolledUnderElevation: 0,
              leading: Builder(
                builder: (context) {
                  return IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: Icon(
                      Icons.menu_rounded,
                      size: 40,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  );
                },
              ),
              centerTitle: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  Image.asset(
                    'assets/images/Logo_IPB.png',
                    height: 80,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ],
              ),
            ),
          ),
        ),
        drawer: CustomDrawer(
          onThemeToggle: widget.onThemeToggle,
          themeModeNotifier: widget.themeModeNotifier,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateMembersScreen(
                        onThemeToggle: widget.onThemeToggle,
                        themeModeNotifier: widget.themeModeNotifier,
                      ),
                    ),
                  );
                },
                child: const CardRegister(),
              ),
              const SizedBox(height: 29),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Members(
                              onThemeToggle: widget.onThemeToggle,
                              themeModeNotifier: widget.themeModeNotifier,
                            ),
                          ),
                        );
                      },
                      child: const CardMembers(),
                    ),
                  ),
                  const SizedBox(width: 29),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Report(
                              onThemeToggle: widget.onThemeToggle,
                              themeModeNotifier: widget.themeModeNotifier,
                            ),
                          ),
                        );
                      },
                      child: const CardReport(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 29),
              MembersCountCard(),
            ],
          ),
        ),
      ),
    );
  }
}