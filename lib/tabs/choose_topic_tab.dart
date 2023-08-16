import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meus_estudos_app/model/study_model.dart';

// ignore: must_be_immutable
class TopicTab extends StatefulWidget {
  final String grade;
  final String value;
  final FirebaseUser user;

  TopicTab({this.grade, this.value, this.user});

  @override
  _TopicTabState createState() => _TopicTabState();
}

class _TopicTabState extends State<TopicTab> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.lightBlue,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('users')
                    .document(widget.user.uid)
                    .collection(widget.grade)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    );
                  else if (snapshot.data.documents.isEmpty)
                    return Center(
                      child: Text(
                        'Adicione um tópico primeiro!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    );
                  else
                    return ListView(
                      children: snapshot.data.documents
                          .map((doc) => FutureBuilder<DocumentSnapshot>(
                              future: Firestore.instance
                                  .collection(widget.grade)
                                  .document(doc.documentID)
                                  .get(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData)
                                  return Center();
                                else
                                  return ListTile(
                                    onTap: () {
                                      StudyModel.of(context).setTopicValue(
                                          snapshot.data['subject']);

                                      Navigator.pop(context, snapshot.data['subject']);
                                    },
                                    trailing: Icon(
                                      CupertinoIcons.book,
                                      color: Colors.white,
                                    ),
                                    title: Text(
                                      'Tópico: ${snapshot.data['subject']}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  );
                              }))
                          .toList(),
                    );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TopicTile extends StatefulWidget {
  final String grade;
  String value;
  final String docId;

  TopicTile({this.docId, this.value, this.grade});

  @override
  _TopicTileState createState() => _TopicTileState();
}

class _TopicTileState extends State<TopicTile> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: Firestore.instance
            .collection(widget.grade)
            .document(widget.docId)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center();
          else
            return ListTile(
              onTap: () {
                setState(() {
                  widget.value = snapshot.data['subject'];
                });
                Navigator.of(context).pop();
              },
              trailing: Icon(
                CupertinoIcons.book,
                color: Colors.white,
              ),
              title: Text(
                'Tópico: ${snapshot.data['subject']}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            );
        });
  }
}
