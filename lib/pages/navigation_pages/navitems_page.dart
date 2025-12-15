import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marine_trust/pages/navigation_pages/notifier_page.dart';

class Navitems extends StatefulWidget {
  const Navitems({super.key});

  @override
  State<Navitems> createState() => _NavitemsState();
}

class _NavitemsState extends State<Navitems> {
  final Color mainBlue = const Color(0xFF09B1EC);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isTablet = width > 600;

    final double iconSize = isTablet ? 30 : 24;
    final double navHeight = isTablet ? 80 : 70;

    return ValueListenableBuilder(
      valueListenable: selectPageNotifier,
      builder: (context, selectedIndex, child) {
        return Container(
          height: navHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 12,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            child: BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: (index) {
                selectPageNotifier.value = index;
              },
              backgroundColor: Colors.white,
              elevation: 0,
              type: BottomNavigationBarType.fixed,

              selectedItemColor: mainBlue,
              unselectedItemColor: Colors.grey.shade600,

              showSelectedLabels: true,
              showUnselectedLabels: true,

              selectedLabelStyle: TextStyle(
                fontSize: isTablet ? 14 : 12,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: isTablet ? 13 : 11,
              ),

              items: [
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.house, size: iconSize),
                  activeIcon: Icon(CupertinoIcons.house_fill, size: iconSize),
                  label: "Home",
                ),

                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.info_circle, size: iconSize),
                  activeIcon: Icon(CupertinoIcons.info_circle_fill, size: iconSize),
                  label: "About",
                ),

                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.tortoise, size: iconSize),
                  activeIcon: Icon(CupertinoIcons.tortoise_fill, size: iconSize),
                  label: "Species",
                ),

                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.briefcase, size: iconSize),
                  activeIcon: Icon(CupertinoIcons.briefcase_fill, size: iconSize),
                  label: "Projects",
                ),

                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.phone, size: iconSize),
                  activeIcon: Icon(CupertinoIcons.phone_fill, size: iconSize),
                  label: "Contact",
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
