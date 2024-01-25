import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      tabBarProvider.initialize();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TabBarProvider tabBarProvider = Provider.of(context);
    return PopScope(
      canPop: false, // Allow popping by default
      onPopInvoked: (value)async{
        if(tabBarProvider.canPop()){
          Navigator.pop(context);
        }else{
          // ignore: use_build_context_synchronously
          final shouldExit = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Do you want to exit?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child:
                  const Text('No', style: TextStyle(color: Colors.green)),
                ),
                TextButton(
                  onPressed: () => SystemNavigator.pop(),
                  child: const Text('Yes', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
          return shouldExit ?? false;
        }
      },
      child: Scaffold(
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
      ),
    );
  }
}
