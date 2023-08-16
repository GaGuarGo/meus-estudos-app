import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meus_estudos_app/widgets/week_widget.dart';

class WeekTab extends StatefulWidget {
  final FirebaseUser user;
  final String weekDay;
  WeekTab({this.weekDay, this.user});

  @override
  _WeekTabState createState() => _WeekTabState();
}

class _WeekTabState extends State<WeekTab> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        /*
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text(
            widget.weekDay == 'Sábado'
                ? '${widget.weekDay}'
                : widget.weekDay == 'Domingo'
                    ? '${widget.weekDay}'
                    : '${widget.weekDay}-feira',
            style: TextStyle(
                color: Colors.lightBlue,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
        */
        body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('users')
                .document(widget.user.uid)
                .collection('horarios')
                .orderBy('começo')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.deepPurple),
                  ),
                );
              else if (snapshot.data.documents.isEmpty)
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.deepPurple)),
                  alignment: Alignment.center,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Você ainda não tem nenhum horário definido \n Clique no botão azul para adicionar um!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              textBaseline: TextBaseline.alphabetic,
                              color: Colors.deepPurple,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.02,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Icon(
                          Icons.addchart,
                          size: MediaQuery.of(context).size.height * 0.05,
                          color: Colors.deepPurple,
                        ),
                      ],
                    ),
                  ),
                );
              else
                return Container(
                    child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 12),
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.height * 0.1,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.cyan,
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(color: Colors.transparent)),
                            child: Text(
                              'Horário',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.032,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.height * 0.1,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.cyan,
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(color: Colors.transparent)),
                            child: Text(
                              'Matéria',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.032,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.height * 0.1,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.cyan,
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(color: Colors.transparent)),
                            child: Text(
                              'Tópico',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.032,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Expanded(
                      child: ListView(
                        children: snapshot.data.documents
                            .map((doc) => WeekWidget(
                                  id: doc.documentID,
                                  weekDay: widget.weekDay,
                                  user: widget.user,
                                  scaffoldKey: _scaffoldKey,
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ));
            }));
  }
}
