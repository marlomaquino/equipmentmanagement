import 'package:equipmentapp/screens/equipmentList.dart';
import 'package:equipmentapp/screens/equipmentAssigned.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPages(),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  _bottomNavigationBar(){
    return BottomNavigationBar(items: const[
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.list), label: 'List'),
    ],
    currentIndex: selectedPage,
    onTap: (tappedPage){
      setState(() {
          selectedPage = tappedPage;
      });
    },
    );
  }

  _getPages(){
    switch(selectedPage) {
      case 0:
        return EquipmentList();
      case 1:
        return SecondPage();
    }

  }
}