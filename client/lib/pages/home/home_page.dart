import 'package:client/pages/activities/activities_page.dart';
import 'package:client/pages/aichat/ai_chat.dart';
import 'package:client/pages/support_group/group_list_page.dart';
import 'package:client/pages/therapy/therapy_page.dart';
import 'package:client/utils/theme_notifier.dart';
import 'package:client/utils/navigation.dart';
import 'package:client/pages/home/home_content.dart';
import 'package:client/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0; // Store the current index of the bottom navigation bar
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthentication(); // Check authentication only once during init
  }

  Future<void> _checkAuthentication() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, Routes.loginScreen);
      }
    } else {
      setState(() {
        _isLoading = false; // Set loading to false only if authenticated
      });
    }
  }

  void _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      final GoogleSignIn googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.loginScreen, (Route<dynamic> route) => false);
      }
    } catch (e) {
      print("Error during logout: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text('An error occurred during logout. Please try again.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
          child:
              CircularProgressIndicator()); // Show a loader while checking authentication
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Theme.of(context).colorScheme.primary),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person,
                color: Theme.of(context).colorScheme.primary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: _screens[_currentIndex], // Keep the current index
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildFloatingBottomAppBar(),
    );
  }

  List<Widget> get _screens => [
        const HomeContent(),
        const ActivitiesScreen(),
        const AiChat(),
        const MentalHealthSpecialistsScreen(),
        const SupportGroupScreen(),
      ];

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Text(
              'MPower',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              _logout();
            },
          ),
          ListTile(
            leading: const Icon(Icons.sunny),
            title: const Text('Theme'),
            onTap: () => Provider.of<ThemeNotifier>(context, listen: false)
                .toggleTheme(),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingBottomAppBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: BottomAppBar(
            elevation: 0,
            color: Theme.of(context).colorScheme.secondary,
            child: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.home),
                    onPressed: () => setState(() => _currentIndex = 0),
                    color: _currentIndex == 0
                        ? Theme.of(context).colorScheme.onPrimary
                        : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.games_outlined),
                    onPressed: () => setState(() => _currentIndex = 1),
                    color: _currentIndex == 1
                        ? Theme.of(context).colorScheme.onPrimary
                        : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.chat_outlined),
                    onPressed: () => setState(() => _currentIndex = 2),
                    color: _currentIndex == 2
                        ? Theme.of(context).colorScheme.onPrimary
                        : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.healing),
                    onPressed: () => setState(() => _currentIndex = 3),
                    color: _currentIndex == 3
                        ? Theme.of(context).colorScheme.onPrimary
                        : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.group),
                    onPressed: () => setState(() => _currentIndex = 4),
                    color: _currentIndex == 4
                        ? Theme.of(context).colorScheme.onPrimary
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
