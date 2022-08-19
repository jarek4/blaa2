import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'blaa_router.gr.dart';

const List<PageRouteInfo<dynamic>> bottomTabs = [
  HomeRouter(),
  StudyRouter(),
  SettingsRouter(),

];
const List<BottomNavigationBarItem> bottomBarItems = [
  BottomNavigationBarItem(
    label: "  Home",
    // padding is for notched bottom bar - place for FAB
    icon: Padding(
      padding: EdgeInsets.only(left: 8.0, top: 4.0),
      child: Icon(Icons.home),
    ),

  ),
  BottomNavigationBarItem(
    label: "Study",
    icon: Icon(Icons.search),
  ),
  BottomNavigationBarItem(
    label: "Settings",
    icon: Icon(Icons.grid_view),
  ),
];