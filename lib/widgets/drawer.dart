/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final PageController pageController;
  final int page;
  final FirebaseUser user;
  CustomDrawer({this.pageController, this.page, this.user});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ClipRRect(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(40)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Drawer(
            child: Stack(
              children: [
                Container(
                  color: Colors.grey[850],
                ),
                ListView(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width * 0.5,
                      color: Colors.deepPurple,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.13,
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                child: ClipOval(
                                    child: Image.network(
                                  '${user.photoUrl}',
                                  fit: BoxFit.fill,
                                )),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Text(
                                      '${user.displayName}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    DrawerTile(
                      icon: CupertinoIcons.calendar,
                      text: 'Segunda-feira',
                      controller: pageController,
                      page: 0,
                    ),
                    DrawerTile(
                      icon: CupertinoIcons.calendar,
                      text: 'Terça-feira',
                      controller: pageController,
                      page: 1,
                    ),
                    DrawerTile(
                      icon: CupertinoIcons.calendar,
                      text: 'Quarta-feira',
                      controller: pageController,
                      page: 2,
                    ),
                    DrawerTile(
                      icon: CupertinoIcons.calendar,
                      text: 'Quinta-feira',
                      controller: pageController,
                      page: 3,
                    ),
                    DrawerTile(
                      icon: CupertinoIcons.calendar,
                      text: 'Sexta-feira',
                      controller: pageController,
                      page: 4,
                    ),
                    DrawerTile(
                      icon: CupertinoIcons.calendar,
                      text: 'Sábado',
                      controller: pageController,
                      page: 5,
                    ),
                    DrawerTile(
                      icon: CupertinoIcons.calendar,
                      text: 'Domingo',
                      controller: pageController,
                      page: 6,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final PageController controller;
  final int page;

  DrawerTile({this.icon, this.text, this.controller, this.page});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          controller.jumpToPage(page);
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          height: 60.0,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: MediaQuery.of(context).size.height * 0.03,
                color: controller.page.round() == page
                    ? Colors.deepPurple
                    : Colors.grey[700],
              ),
              SizedBox(
                width: 42.0,
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.025,
                  color: controller.page.round() == page
                      ? Colors.deepPurple
                      : Colors.grey[700],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
*/