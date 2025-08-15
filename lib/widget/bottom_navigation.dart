import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loan_project/helper/color_helper.dart';
import 'package:loan_project/screen/home_screen.dart';
import 'package:loan_project/screen/loan/my_loan_screen.dart';
import 'package:loan_project/screen/notification/notification_screen.dart';
import 'package:loan_project/screen/profile/profile_screen.dart';
import 'package:loan_project/screen/repayment/repayment_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class BottomNavigation extends StatefulWidget {
  final int index;
  const BottomNavigation({super.key, required this.index});

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late PersistentTabController _controller;

  int _currentIndex = 0;
  final List<Widget> _children = [
    const HomeScreen(),
    const RepaymentScreen(),
    const MyLoanScreen(),
    const NotificationScreen(),
    const ProfileScreen(),
  ];

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        iconSize: 33,
        icon: SvgPicture.asset(
          'assets/svg/ic_home.svg',
          width: 38,
          height: 38,
          color: baseColor,
        ),
        inactiveIcon: SvgPicture.asset(
          'assets/svg/ic_home.svg',
          width: 38,
          height: 38,
          color: const Color(0xff7D8998),
        ),
        activeColorPrimary: baseColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          'assets/svg/ic_receipt.svg',
          width: 38,
          height: 38,
          color: baseColor,
        ),
        inactiveIcon: SvgPicture.asset(
          'assets/svg/ic_receipt.svg',
          width: 38,
          height: 38,
          color: const Color(0xff7D8998),
        ),
        activeColorPrimary: baseColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          'assets/svg/ic_money.svg',
          width: 38,
          height: 38,
          color: Colors.white,
        ),
        inactiveIcon: SvgPicture.asset(
          'assets/svg/ic_money.svg',
          width: 38,
          height: 38,
          color: Colors.white,
        ),
        activeColorPrimary: const Color(0xFFF77F00),
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          'assets/svg/ic_notification.svg',
          width: 38,
          height: 38,
          color: baseColor,
        ),
        inactiveIcon: SvgPicture.asset(
          'assets/svg/ic_notification.svg',
          width: 38,
          height: 38,
          color: const Color(0xff7D8998),
        ),
        activeColorPrimary: baseColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          'assets/svg/ic_user.svg',
          width: 38,
          height: 38,
          color: baseColor,
        ),
        inactiveIcon: SvgPicture.asset(
          'assets/svg/ic_user.svg',
          width: 38,
          height: 38,
          color: const Color(0xff7D8998),
        ),
        activeColorPrimary: baseColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _currentIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(children: [
        Visibility(visible: true, child: _children.elementAt(_currentIndex))
      ]),
      bottomNavigationBar: PersistentTabView(
        context,
        controller: _controller,
        onItemSelected: (value) {
          setState(() {
            _currentIndex = value;
            if (_currentIndex == 2) {
              // _distanceBloc.add(GetDistanceEvent(
              //     _currentPosition?.longitude,
              //     _currentPosition?.latitude));
            }

            log("indexes");
          });
        },
        screens: _children,
        items: _navBarsItems(),
        confineInSafeArea: true,
        navBarHeight: 70,
        bottomScreenMargin: 20,
        backgroundColor: const Color(0xff252422), // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows:
            true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties(
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.style15, // Choose the nav bar style with this property.
      ),
    );
  }
}
