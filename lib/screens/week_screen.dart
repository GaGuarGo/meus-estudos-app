import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:hidden_drawer_menu/model/item_hidden_menu.dart';
import 'package:hidden_drawer_menu/model/screen_hidden_drawer.dart';
import 'package:meus_estudos_app/tabs/week_tab.dart';
import 'package:meus_estudos_app/widgets/week_button.dart';

class WeekScreen extends StatefulWidget {
  final Function signOut;
  final FirebaseUser user;
  WeekScreen({this.user, this.signOut});

  @override
  _WeekScreenState createState() => _WeekScreenState();
}

class _WeekScreenState extends State<WeekScreen> {
  var isExtended = false;

  List<ScreenHiddenDrawer> _itens = [];

  @override
  void initState() {
    super.initState();
    _itens.add(new ScreenHiddenDrawer(
      new ItemHiddenMenu(
        name: "Segunda-Feira",
        baseStyle:
            TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 28.0),
        colorLineSelected: Colors.teal,
      ),
      WeekTab(
        weekDay: 'Segunda',
        user: widget.user,
      ),
    ));

    _itens.add(new ScreenHiddenDrawer(
      new ItemHiddenMenu(
        name: "Terça-Feira",
        baseStyle:
            TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 28.0),
        colorLineSelected: Colors.teal,
      ),
      WeekTab(
        weekDay: 'Terça',
        user: widget.user,
      ),
    ));
    _itens.add(new ScreenHiddenDrawer(
      new ItemHiddenMenu(
        name: "Quarta-Feira",
        baseStyle:
            TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 28.0),
        colorLineSelected: Colors.teal,
      ),
      WeekTab(
        weekDay: 'Quarta',
        user: widget.user,
      ),
    ));
    _itens.add(new ScreenHiddenDrawer(
      new ItemHiddenMenu(
        name: "Quinta-Feira",
        baseStyle:
            TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 28.0),
        colorLineSelected: Colors.teal,
      ),
      WeekTab(
        weekDay: 'Quinta',
        user: widget.user,
      ),
    ));
    _itens.add(new ScreenHiddenDrawer(
      new ItemHiddenMenu(
        name: "Sexta-Feira",
        baseStyle:
            TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 28.0),
        colorLineSelected: Colors.teal,
      ),
      WeekTab(
        weekDay: 'Sexta',
        user: widget.user,
      ),
    ));
    _itens.add(new ScreenHiddenDrawer(
      new ItemHiddenMenu(
        name: "Sábado",
        baseStyle:
            TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 28.0),
        colorLineSelected: Colors.teal,
      ),
      WeekTab(
        weekDay: 'Sábado',
        user: widget.user,
      ),
    ));
    _itens.add(new ScreenHiddenDrawer(
      new ItemHiddenMenu(
        name: "Domingo",
        baseStyle:
            TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 28.0),
        colorLineSelected: Colors.teal,
      ),
      WeekTab(
        weekDay: 'Domingo',
        user: widget.user,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: WeekButton(
        user: widget.user,
      ),
      backgroundColor: Colors.grey[850],
      body: HiddenDrawerMenu(
        
        actionsAppBar: [
          IconButton(
            icon: Icon(Icons.exit_to_app_rounded),
            onPressed: () {
              widget.signOut();
            },
          ),
        ],
        backgroundColorMenu: CupertinoColors.link,
        isTitleCentered: true,
        backgroundColorAppBar: Colors.cyan,
        elevationAppBar: 0.0,
        screens: _itens,
        typeOpen: TypeOpen.FROM_LEFT,
        disableAppBarDefault: false,
        slidePercent: 80.0,
        verticalScalePercent: 80.0,
        contentCornerRadius: 10.0,
         whithAutoTittleName: true,
        backgroundMenu: DecorationImage(
            image: ExactAssetImage('assets/estudos.jpeg'), fit: BoxFit.cover),
      ),
    );
  }
}

/*
Row(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  tileMode: TileMode.mirror,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.lightBlue,
                    Colors.purple,
                  ],
                ),
              ),
              child: NavigationRail(
                backgroundColor: Colors.transparent,
                groupAlignment: 0.0,
                minWidth: MediaQuery.of(context).size.width * 0.16,
                minExtendedWidth: MediaQuery.of(context).size.width * 0.5,
                extended: isExtended,
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(
                          isExtended == false
                              ? Icons.menu_rounded
                              : Icons.close,
                          color: isExtended == true
                              ? Colors.white54
                              : Colors.white),
                      onPressed: () {
                        setState(() {
                          isExtended = !isExtended;
                        });
                      },
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: IconButton(
                          onPressed: widget.signOut,
                          icon: Icon(
                            Icons.exit_to_app_rounded,
                            color: Colors.red,
                            size: MediaQuery.of(context).size.height * 0.04,
                          ),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: ClipOval(
                        child: Image.network(
                          widget.user.photoUrl,
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.height * 0.05,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                selectedIndex: _selectedIndex,
                onDestinationSelected: (int index) {
                  _pageController.animateToPage(index,
                      duration: Duration(milliseconds: 450),
                      curve: Curves.easeInQuad);
                },
                selectedIconTheme: IconThemeData(
                    color: Colors.white,
                    size: MediaQuery.of(context).size.height * 0.035),
                unselectedIconTheme: IconThemeData(
                    color: Colors.grey,
                    size: MediaQuery.of(context).size.height * 0.03),
                selectedLabelTextStyle: TextStyle(
                    color: Colors.white54, fontWeight: FontWeight.bold),
                unselectedLabelTextStyle: TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.normal),
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.calendar_today),
                    selectedIcon: Icon(CupertinoIcons.calendar),
                    label: Text('Segunda-feira'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.calendar_today),
                    selectedIcon: Icon(CupertinoIcons.calendar),
                    label: Text('Terça-feira'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.calendar_today),
                    selectedIcon: Icon(CupertinoIcons.calendar),
                    label: Text('Quarta-feira'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.calendar_today),
                    selectedIcon: Icon(CupertinoIcons.calendar),
                    label: Text('Quinta-feira'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.calendar_today),
                    selectedIcon: Icon(CupertinoIcons.calendar),
                    label: Text('Sexta-feira'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.calendar_today),
                    selectedIcon: Icon(CupertinoIcons.calendar),
                    label: Text('Sábado'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.calendar_today),
                    selectedIcon: Icon(CupertinoIcons.calendar),
                    label: Text('Domingo'),
                  ),
                ],
              ),
            ),
            Expanded(
                child: PageView(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              controller: _pageController,
              onPageChanged: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: [
                WeekTab(
                  weekDay: 'Segunda',
                  user: widget.user,
                ),
                WeekTab(
                  weekDay: 'Terça',
                  user: widget.user,
                ),
                WeekTab(
                  weekDay: 'Quarta',
                  user: widget.user,
                ),
                WeekTab(
                  weekDay: 'Quinta',
                  user: widget.user,
                ),
                WeekTab(
                  weekDay: 'Sexta',
                  user: widget.user,
                ),
                WeekTab(
                  weekDay: 'Sábado',
                  user: widget.user,
                ),
                WeekTab(
                  weekDay: 'Domingo',
                  user: widget.user,
                ),
              ],
            )),
          ],
        ),
*/
