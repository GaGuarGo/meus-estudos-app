import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meus_estudos_app/tabs/grade_tab.dart';
import 'package:meus_estudos_app/widgets/grade_widget.dart';

// ignore: must_be_immutable
class GradeScreen extends StatefulWidget {
  FirebaseUser user;
  GradeScreen({this.user});

  @override
  _GradeScreenState createState() => _GradeScreenState();
}

class _GradeScreenState extends State<GradeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              tileMode: TileMode.mirror,
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [CupertinoColors.systemPurple, CupertinoColors.activeBlue])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          margin: EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _subtitle(subtitle: 'Exatas e Biológicas:'),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _grade('Matemática'),
                    _grade('Física'),
                    _grade('Química'),
                    _grade('Biologia'),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              _subtitle(subtitle: 'Humanas e Linguagens:'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _grade('Português'),
                      _grade('Literatura'),
                      _grade('Inglês'),
                      _grade('Redação'),
                      _grade('História'),
                      _grade('Geografia'),
                      _grade('Filosofia'),
                      _grade('Sociologia'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _subtitle({String subtitle}) => Container(
      margin: EdgeInsets.all(8),
      alignment: Alignment.centerLeft,
      child: Text(subtitle,
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)));

  Widget _grade(String gradeT) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 0.75,
      alignment: Alignment.center,
      child: Card(
        elevation: 8.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: ListTile(
                title: Text(
                  '$gradeT:',
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: MediaQuery.of(context).size.height * 0.022,
                      fontWeight: FontWeight.w500),
                ),
                trailing: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: MediaQuery.of(context).size.height * 0.05,
                  // ignore: deprecated_member_use
                  child: OutlineButton(
                    splashColor: Colors.grey,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => GradeAlert(
                                grade: gradeT,
                                user: widget.user,
                              ));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    highlightElevation: 0,
                    borderSide: BorderSide(color: Colors.purple),
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Novo Tópico',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.add,
                            color: Colors.purple,
                            size: MediaQuery.of(context).size.height * 0.025,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('users')
                    .document(widget.user.uid)
                    .collection(gradeT)
                    .orderBy('subjectId')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    );
                  else
                    return ListView(
                      padding: EdgeInsets.all(4),
                      children: snapshot.data.documents
                          .map((grade) => GradeTab(
                                gradeId: grade.documentID,
                                grade: gradeT,
                                user: widget.user,
                              ))
                          .toList(),
                    );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
