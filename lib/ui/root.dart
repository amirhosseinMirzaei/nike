import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nike/data/rep/auth_repository.dart';
import 'package:nike/ui/Home/home.dart';
import 'package:nike/ui/cart/cart.dart';
import 'package:nike/ui/widgets/badge.dart';

const int homeIndex = 0;
const int cartIndex = 1;
const int profileIndex = 2;

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int selectedScreenIndex = homeIndex;
  GlobalKey<NavigatorState> _homeKey = GlobalKey();
  GlobalKey<NavigatorState> _cartKey = GlobalKey();
  GlobalKey<NavigatorState> _profileKey = GlobalKey();

  final List<int> _history = [];
  late final map = {
    homeIndex: _homeKey,
    cartIndex: _cartKey,
    profileIndex: _profileKey,
  };
  Future<bool> _onWillPop() async {
    final NavigatorState currentSelectedTabNavigatorState =
        map[selectedScreenIndex]!.currentState!;
    if (currentSelectedTabNavigatorState.canPop()) {
      currentSelectedTabNavigatorState.pop();
      return false;
    } else if (_history.isNotEmpty) {
      setState(() {
        selectedScreenIndex = _history.last;
        _history.removeLast();
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: IndexedStack(
            index: selectedScreenIndex,
            children: [
              _navigator(_homeKey, homeIndex, const HomeScreen()),
              _navigator(
                _cartKey,
                cartIndex,
                const CartScreen(),
              ),
              _navigator(
                  _profileKey,
                  profileIndex,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('profile'),
                      ElevatedButton(
                          onPressed: () {
                            authRepository.signOut();
                          },
                          child: Text('خروج'))
                    ],
                  )),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home), label: 'خانه'),
              BottomNavigationBarItem(
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(CupertinoIcons.cart),
                      Positioned(right: -10, child: CustomBadge(value: 3))
                    ],
                  ),
                  label: 'سبدخرید'),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person), label: 'پروفایل')
            ],
            currentIndex: selectedScreenIndex,
            onTap: (selectedIndex) {
              setState(() {
                _history.remove(selectedScreenIndex);
                _history.add(selectedScreenIndex);
                selectedScreenIndex = selectedIndex;
              });
            },
          ),
        ),
        onWillPop: _onWillPop);
  }

  Widget _navigator(GlobalKey key, int index, Widget child) {
    return key.currentState == null && selectedScreenIndex != index
        ? Container()
        : Navigator(
            key: key,
            onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (context) => Offstage(
                    offstage: selectedScreenIndex != index, child: child)));
  }
}
