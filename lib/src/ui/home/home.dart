import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:cupertino_icons/cupertino_icons.dart';

import 'package:lycle/src/ui/nftCardList/nftCardList.dart';
import 'package:lycle/src/ui/questList/questList.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final List<Widget> _widgetOptions = <Widget>[NFTCardListPage(), QuestListPage(), Container()];
  final List<BottomNavigationBarItem> _bottomNavigationBarOptions =
      <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.rectangle_stack),
      label: 'NFT',
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.list_bullet_below_rectangle),
      label: '퀘스트',
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.person_crop_circle),
      label: '내 정보',
    ),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavigationBarOptions,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
