import 'package:flutter/material.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import 'package:e_commerce_flutter/core/app_data.dart';
import 'package:e_commerce_flutter/src/view/screen/cart_screen.dart';
import 'package:e_commerce_flutter/src/view/screen/profile_screen.dart';
import 'package:e_commerce_flutter/src/view/screen/favorite_screen.dart';
import 'package:e_commerce_flutter/src/view/screen/product_list_screen.dart';
import 'package:e_commerce_flutter/src/view/animation/page_transition_switcher_wrapper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const List<Widget> screens = [
    ProductListScreen(),
    FavoriteScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final Color rojoYaVaz = const Color(0xFFE30613);
  final Color azulYaVaz = const Color(0xFF004A98);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: PageTransitionSwitcherWrapper(
            child: HomeScreen.screens[currentIndex],
          ),
          bottomNavigationBar: StylishBottomBar(
            currentIndex: currentIndex,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            items: AppData.bottomNavBarItems.map((item) {
              final isSelected =
                  currentIndex == AppData.bottomNavBarItems.indexOf(item);
              return BottomBarItem(
                icon: item.icon,
                title: Text(
                  item.title,
                  style: TextStyle(
                    color: isSelected ? rojoYaVaz : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
            option: BubbleBarOptions(
              opacity: 0.2,
              unselectedIconColor: Colors.grey,
              borderRadius: BorderRadius.circular(12),
              barStyle: BubbleBarStyle.horizontal,
            ),
          ),
        ),
      ),
    );
  }
}
