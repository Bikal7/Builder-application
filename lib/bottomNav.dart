
import 'package:builder/dashboard.dart';
import 'package:builder/settings.dart';
import 'package:flutter/material.dart';

class bottomNav extends StatefulWidget {
  const bottomNav({super.key});

  @override
  State<bottomNav> createState() => _bottomNavState();
}

class _bottomNavState extends State<bottomNav> {
  int selectedTab = 0;
  List<Widget> pages = [
   const Dashboard(),
   const Settings()
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          
          return false;
        },
        child: pages[selectedTab]),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedTab,
          selectedItemColor: const Color(0xff1777AB,),
          unselectedItemColor: const Color(0xffa9a9a9),
          onTap: (index) {
            setState(() {
              selectedTab = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Setting")
          ]),
    );
  }
}