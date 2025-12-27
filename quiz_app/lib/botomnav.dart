import 'package:flutter/material.dart';
import 'sports.dart';
import 'generalknowledge.dart';
import 'history.dart';
import 'politics.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int selectedindex = 0;
  PageController pageController = PageController();

  void onTapped(int index) {
    setState(() {
      selectedindex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: [
          SportsPage(),
          Generalknowledge(),
          Historypage(),
          PoliticsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.sports), label: 'Sports'),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'General knowledge',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.policy), label: 'Politics'),
        ],
        currentIndex: selectedindex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: onTapped,
      ),
    );
  }
}
