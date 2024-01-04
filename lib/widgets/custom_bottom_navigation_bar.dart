import 'package:bai3/models/navigation_item.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

List<NavigationItem> tabs = [
  NavigationItem(label: 'Home', icon: 'assets/icons/home.svg'),
  NavigationItem(label: 'Trend', icon: 'assets/icons/fire.svg'),
  NavigationItem(label: 'Explore', icon: 'assets/icons/compass.svg'),
  NavigationItem(label: 'Chat', icon: 'assets/icons/message-circle.svg'),
  NavigationItem(label: 'Profile', icon: 'assets/icons/person.svg'),
];

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.selectedTab,
    this.onTap,
  });

  final int selectedTab;
  final void Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      buttonBackgroundColor: const Color(0xFFB81D5B),
      color: const Color(0xFF222B45),
      index: selectedTab,
      items: tabs
          .map(
            (tab) => CurvedNavigationBarItem(
              child: SvgPicture.asset(
                tab.icon,
                width: 20,
                color: selectedTab == tabs.indexOf(tab)
                    ? Colors.white
                    : Colors.white.withOpacity(0.5),
              ),
              label: tab.label,
              labelStyle: TextStyle(
                color: selectedTab == tabs.indexOf(tab)
                    ? const Color(0xFFFF3D71)
                    : Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          )
          .toList(),
      onTap: onTap,
    );
  }
}
