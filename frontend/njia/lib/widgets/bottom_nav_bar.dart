import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavBar extends StatefulWidget {
  const MyBottomNavBar({Key? key}) : super(key: key);

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  int selectedIndex = 0;

  void changeIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
        child: GNav(
          gap: 8,
          backgroundColor: Colors.black,
          color: Colors.white,
          activeColor: Colors.white,
          // tabBackgroundColor: Colors.grey.shade800,
          padding: const EdgeInsets.all(16),
          haptic: true,
          selectedIndex: selectedIndex,
          // onTabChange: changeIndex,
          tabs: [
            GButton(
                icon: Icons.home,
                text: 'Home',
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/map');
                  setState(() {
                    selectedIndex = 0;
                  });
                }),
            GButton(
              icon: Icons.person,
              text: 'Suspects',
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/all_suspect');
                setState(() {
                  selectedIndex = 1;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
