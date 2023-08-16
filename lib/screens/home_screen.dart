import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meus_estudos_app/screens/grades_screen.dart';
import 'package:meus_estudos_app/screens/login_screen.dart';
import 'package:meus_estudos_app/screens/week_screen.dart';
import 'package:meus_estudos_app/tabs/review_tab.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  FirebaseUser user;
  HomeScreen({this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  int page = 0; 
  bool isLoading = false;
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      WeekScreen(
        user: _currentUser,
        signOut: _signOut,
      ),
      GradeScreen(
        user: _currentUser,
      ),
      ReviewTab(
        user: _currentUser,
      )
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.calendar_today,
        ),
        title: ("Semana"), 
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.grading,
        ),
        title: ("Matérias"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          CupertinoIcons.book_fill,
        ),
        title: ("Cronograma"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  FirebaseUser _currentUser;

  Future<FirebaseUser> signInWithGoogle() async {
    if (_currentUser != null) return _currentUser;

    try {
      setState(() {
        isLoading = true;
      });
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      final AuthResult authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      _currentUser = authResult.user;

      setState(() {
        isLoading = false;
      });
      return _currentUser;
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      return null;
    }
  }

  void _signOut() {
    FirebaseAuth.instance.signOut();
    googleSignIn.signOut();
  }

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      setState(() {
        _currentUser = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null)
      return LoginScreen(
        googleSignIn: signInWithGoogle,
        isLoading: isLoading,
      );
    else
      return Scaffold(
        backgroundColor: Colors.grey[850],
        body: PersistentTabView(
          context,
          screens: _buildScreens(),
          controller: _controller,
          items: _navBarsItems(),
          confineInSafeArea: true,
          backgroundColor: Colors.white, // Default is Colors.white.
          handleAndroidBackButtonPress: true, // Default is true.
          resizeToAvoidBottomInset:
              true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
          stateManagement: true, // Default is true.
          hideNavigationBarWhenKeyboardShows:
              true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(12.0),
            colorBehindNavBar: Colors.white,
          ),
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,
          itemAnimationProperties: ItemAnimationProperties(
            // Navigation Bar's items animation properties.
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: ScreenTransitionAnimation(
            // Screen transition animation on change of selected tab.
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
          navBarStyle: NavBarStyle.style1, //
        ),
      );
  }
}
