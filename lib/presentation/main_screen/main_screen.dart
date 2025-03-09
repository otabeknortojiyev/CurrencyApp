import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:currency_app/presentation/main_screen/profile_page/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';

import 'crypto_page/view.dart';
import 'currency_page/view.dart';
import 'favorite_page/view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  var _bottomNavIndex = 0;
  var addedToFavorite = false;

  late AnimationController _hideBottomBarAnimationController;
  late AnimationController _favoriteIconAnimationController;
  late Animation<double> _favoriteIconAnimation;

  final iconListActive = ['assets/dollar_active.svg', 'assets/bitcoin_active.svg', 'assets/library_active.svg', 'assets/profile_active.svg'];
  final iconListNotActive = [
    'assets/dollar_not_active.svg',
    'assets/bitcoin_not_active.svg',
    'assets/library_not_active.svg',
    'assets/profile_not_active.svg',
  ];
  final textList = <String>["Currency", "Crypto", "Favorite", "Profile"];

  @override
  void initState() {
    super.initState();
    _hideBottomBarAnimationController = AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    _favoriteIconAnimationController = AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _favoriteIconAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _favoriteIconAnimationController, curve: Curves.easeInOut));
    _favoriteIconAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          addedToFavorite = false;
        });
      }
    });
  }

  void _toggleFavorite() {
    setState(() {
      addedToFavorite = true;
    });
    _favoriteIconAnimationController.reset();
    _favoriteIconAnimationController.forward();
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification && notification.metrics.axis == Axis.vertical) {
      switch (notification.direction) {
        case ScrollDirection.forward:
          _hideBottomBarAnimationController.reverse();
          break;
        case ScrollDirection.reverse:
          _hideBottomBarAnimationController.forward();
          break;
        case ScrollDirection.idle:
          break;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: NotificationListener<ScrollNotification>(
        onNotification: onScrollNotification,
        child:
            _bottomNavIndex == 0
                ? CurrencyPage(onScrollNotification: onScrollNotification, addedToFavorite: _toggleFavorite)
                : _bottomNavIndex == 1
                ? CryptoPage(onScrollNotification: onScrollNotification, addedToFavorite: _toggleFavorite)
                : _bottomNavIndex == 2
                ? FavoritePage(
                  onScrollNotification: onScrollNotification,
                  popFromCurrency: () {
                    setState(() {
                      _bottomNavIndex = 0;
                    });
                  },
                  popFromCrypto: () {
                    setState(() {
                      _bottomNavIndex = 1;
                    });
                  },
                )
                : ProfilePage(onScrollNotification: onScrollNotification),
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconListActive.length,
        tabBuilder: (int index, bool isActive) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (index == 2)
                AnimatedBuilder(
                  animation: _favoriteIconAnimation,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow:
                            addedToFavorite
                                ? [
                                  BoxShadow(
                                    color: Colors.green.withValues(alpha: _favoriteIconAnimation.value),
                                    blurRadius: 10.0 * _favoriteIconAnimation.value,
                                    spreadRadius: 2.0 * _favoriteIconAnimation.value,
                                  ),
                                ]
                                : [],
                      ),
                      child: SvgPicture.asset(isActive ? iconListActive[index] : iconListNotActive[index], width: 24, height: 24),
                    );
                  },
                )
              else
                SvgPicture.asset(isActive ? iconListActive[index] : iconListNotActive[index], width: 24, height: 24),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  textList[index],
                  maxLines: 1,
                  style: TextStyle(color: isActive ? Color(0xFFF26B6C) : Colors.grey, fontWeight: FontWeight.w500, fontSize: 12),
                ),
              ),
            ],
          );
        },
        backgroundColor: Colors.white,
        activeIndex: _bottomNavIndex,
        splashColor: Color(0xFFF26B6C),
        splashSpeedInMilliseconds: 300,
        notchSmoothness: NotchSmoothness.defaultEdge,
        gapLocation: GapLocation.center,
        gapWidth: 0,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        hideAnimationController: _hideBottomBarAnimationController,
        shadow: BoxShadow(offset: Offset(0, 1), blurRadius: 12, spreadRadius: 0.5, color: Colors.grey),
      ),
    );
  }

  @override
  void dispose() {
    _hideBottomBarAnimationController.dispose();
    _favoriteIconAnimationController.dispose();
    super.dispose();
  }
}
