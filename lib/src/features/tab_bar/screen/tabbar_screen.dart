import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/tab_bar_provider.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({super.key});

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  @override
  void initState() {
    final TabBarProvider tabBarProvider = Provider.of(context, listen: false);
    tabBarProvider.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TabBarProvider tabBarProvider = Provider.of(context);
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: IndexedStack(
            index: tabBarProvider.tabIndex,
            children: tabBarProvider.getTabBarChild),
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) => tabBarProvider.changeTabIndex(index),
          elevation: 0,
          currentIndex: tabBarProvider.tabIndex,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.view_list), label: 'Menu'),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.shopping_cart), label: 'Order'),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person_fill), label: 'Profile'),
          ]),
    );
  }
}
