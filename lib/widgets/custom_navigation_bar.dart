import 'package:bai3/models/navigation_item.dart';
import 'package:bai3/widgets/navigation_bar_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

List<NavigationItem> tabs = [
  NavigationItem(label: 'Home', icon: 'assets/icons/home.svg'),
  NavigationItem(label: 'Trend', icon: 'assets/icons/fire.svg'),
  NavigationItem(label: 'Explore', icon: 'assets/icons/compass.svg'),
  NavigationItem(label: 'Chat', icon: 'assets/icons/message-circle.svg'),
  NavigationItem(label: 'Profile', icon: 'assets/icons/person.svg'),
];

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CustomPaint(
          painter: NavigationBarPainter(),
          size: const Size(double.infinity, 70),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 91),
          child: Row(
            children: tabs
                .map(
                  (tab) => Container(
                    height: 84,
                    width: 60,
                    alignment: tab.label == 'Home'
                        ? Alignment.topCenter
                        : Alignment.bottomCenter,
                    padding:
                        EdgeInsets.only(bottom: tab.label == 'Home' ? 12 : 18),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          tab.icon,
                          width: tab.label == 'Home' ? 28 : 20,
                        ),
                        SizedBox(
                          height: tab.label == 'Home' ? 24 : 4,
                        ),
                        Text(
                          tab.label,
                          style: TextStyle(
                            color: tab.label == 'Home'
                                ? const Color(0xFFFF3D71)
                                : Colors.white.withOpacity(0.5),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
