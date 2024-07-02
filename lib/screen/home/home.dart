import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart' as lang;
import '../../theme/theme_constants.dart';
import '../authentication/auth_provider.dart';
import '../authentication/log_in.dart';
import '../brand/brand.dart';
import '../category/search.dart';
import '../profile/favorite.dart';
import '../profile/profile.dart';
import 'home_screen.dart';

class Home extends StatefulWidget {
  final int? bottomNavIndex;

  const Home({
    super.key,
    this.bottomNavIndex,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const Brands(),
    const Search(),
    const Favorite(),
    const Profile(),
  ];

  late int _bottomNavIndex;
  late Widget currentScreen;
  late bool status = false;

  @override
  void initState() {
    super.initState();
    _bottomNavIndex =
        widget.bottomNavIndex == null ? 0 : widget.bottomNavIndex!;
    currentScreen = _widgetOptions.elementAt(_bottomNavIndex);
  }

  @override
  //main檔MaterialApp的context
  Widget build(BuildContext context) {
    final bottomList = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: const Icon(Icons.home_filled),
          label: lang.S.of(context).navHome,
          tooltip: lang.S.of(context).navHome),
      BottomNavigationBarItem(
          icon: const Icon(Icons.store),
          label: lang.S.of(context).navBrands,
          tooltip: lang.S.of(context).navBrands),
      BottomNavigationBarItem(
          icon: const Icon(Icons.shopping_bag),
          label: lang.S.of(context).navShop,
          tooltip: lang.S.of(context).navShop),
      BottomNavigationBarItem(
          icon: const Icon(Icons.favorite),
          label: lang.S.of(context).navWishlist,
          tooltip: lang.S.of(context).navWishlist),
      BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: lang.S.of(context).navMe,
          tooltip: lang.S.of(context).navMe),
    ];

    final authchangeprovider =
        Provider.of<AuthChangeProvider>(context, listen: false);

    return Scaffold(
      //鍵盤出現時，不會將頁面往上推
      resizeToAvoidBottomInset: false,
      backgroundColor: whiteColor,
      body: currentScreen,
      bottomNavigationBar: SafeArea(
        top: false,
        left: false,
        right: false,
        bottom: true,
        child: SizedBox(
          height: 53,
          child: BottomNavigationBar(
            backgroundColor: whiteColor,
            elevation: 0.0,
            selectedItemColor: primaryColor,
            unselectedItemColor: lightGreyTextColor,
            currentIndex: _bottomNavIndex,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            onTap: (index) => setState(
              () {
                status = authchangeprovider.status;
                //已登入
                if (status) {
                  _bottomNavIndex = index;
                  currentScreen = _widgetOptions.elementAt(index);
                } else {
                  if (index == 3) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LogIn(),
                      ),
                    );
                  } else {
                    _bottomNavIndex = index;
                    currentScreen = _widgetOptions.elementAt(index);
                  }
                }
              },
            ),
            items: bottomList,
          ),
        ),
      ),
    );
  }
}
