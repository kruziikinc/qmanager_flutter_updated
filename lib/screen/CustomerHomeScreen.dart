import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qmanager_flutter_updated/presentation/custom_icons_icons.dart';
import 'package:qmanager_flutter_updated/screen/HomeListScreen.dart';
import 'package:qmanager_flutter_updated/screen/myBooking.dart';
import 'package:qmanager_flutter_updated/screen/setting.dart';

class CustomerHomeScreen extends StatefulWidget {
  static const routeName = 'customerHome-screen';
  @override
  _CustomerHomeScreenState createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _selectedIndex = 0;
  // static const TextStyle optionStyle =
  //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List<Widget> _widgetOptions = <Widget>[
    HomeListScreen(),
    MyBookingScreen(),
    SettingScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() {
      return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Confirm Exit?',
                  style: new TextStyle(color: Colors.black, fontSize: 18.0)),
              content: new Text('Are you sure you want to exit the app?'),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    // this line exits the app.
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: new Text('Yes', style: new TextStyle(fontSize: 16.0)),
                ),
                new FlatButton(
                  onPressed: () =>
                      Navigator.pop(context), // this line dismisses the dialog
                  child: new Text('No', style: new TextStyle(fontSize: 16.0)),
                )
              ],
            ),
          ) ??
          false;
    }

    // TODO: implement build
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: _widgetOptions[_selectedIndex],
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.white,
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Color(int.parse("FFfc0303", radix: 16)),
            unselectedItemColor: Color(int.parse("FF595856", radix: 16)),
            onTap: _onItemTapped, // this will be set when a new tab is tapped
            items: [
              BottomNavigationBarItem(
                icon: Icon(CustomIcons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today), label: 'My Bookings'),
              BottomNavigationBarItem(
                  icon: Icon(CustomIcons.settings), label: 'Settings')
            ],
          ),
        ),
      ),
    );
  }
}
