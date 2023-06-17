import 'package:flutter/material.dart';
import 'package:gest_payement/Cours.dart';
import 'package:gest_payement/Matiere.dart';
import 'package:gest_payement/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cours_periode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(token: prefs.getString('token'),));
}
class MyApp extends StatefulWidget {

  final token;
  const MyApp({
    @required this.token,
    Key? key,
  }): super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    Profs(),
    // Types(),
    Cours(),
    Matieres(),
    CoursPeriode(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primaryColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.green[150],
                ),
                child: Center(
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.groups_sharp),
                title: Text('Profs'),
                onTap: () {
                  _onItemTapped(0);
                },
              ),
              ListTile(
                leading: Icon(Icons.school_outlined),
                title: Text('Cours'),
                onTap: () {
                  _onItemTapped(1);
                },
              ),
              ListTile(
                leading: Icon(Icons.subject),
                title: Text('Matieres'),
                onTap: () {
                  _onItemTapped(2);
                },
              ),
              ListTile(
                leading: Icon(Icons.calendar_today_outlined),
                title: Text('CoursPeriode'),
                onTap: () {
                  _onItemTapped(3);
                },
              ),
            ],
          ),
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(unselectedItemColor: Colors.blue,
          showUnselectedLabels: true,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.groups_sharp),
              label: 'Profs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined),
              label: 'Cours',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.collections_bookmark_outlined),
              label: 'Matieres',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit_calendar_rounded),
              label: 'CoursPeriode',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
