import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListEvents extends StatefulWidget {
  final FirebaseUser user;
  ListEvents({this.user});

  @override
  _ListEventsState createState() => _ListEventsState();
}

class _ListEventsState extends State<ListEvents> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('users')
                    .document(widget.user.uid)
                    .collection('events')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                        child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation(CupertinoColors.activeBlue),
                    ));
                  else if (snapshot.data.documents.isEmpty)
                    return Container(
                      alignment: Alignment.center,
                      child: Center(
                        child: Text(
                          'Adicione um evento primeiro!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.04,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  else
                    return ListView(
                        padding: EdgeInsets.all(8),
                        children: snapshot.data.documents
                            .map((doc) => EventWidget(
                                user: widget.user, id: doc.documentID))
                            .toList());
                },
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              alignment: Alignment.bottomCenter,
              // ignore: deprecated_member_use
              child: RaisedButton(
                color: Colors.red,
                child: Text(
                  'Fechar',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class EventWidget extends StatelessWidget {
  String id;
  FirebaseUser user;
  EventWidget({this.user, this.id});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('users')
          .document(user.uid)
          .collection('events')
          .document(id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(CupertinoColors.activeBlue),
          ));
        else {
          DateTime from = snapshot.data['from'].toDate();
          DateTime to = snapshot.data['to'].toDate();

          return Dismissible(
            direction: DismissDirection.startToEnd,
            background: Container(
                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                height: MediaQuery.of(context).size.height * 0.1,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red)),
                child: Align(
                  alignment: Alignment(-0.9, 0.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                )),
            key: Key(id),
            onDismissed: (direction) async {
              await Firestore.instance
                  .collection('users')
                  .document(user.uid)
                  .collection('events')
                  .document(id)
                  .delete();
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 4),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${snapshot.data['eventName']}",
                      style: TextStyle(color: Colors.white)),
                  SizedBox(height: 2),
                  Text("${from.toString()} - ${to.toString()}", style: TextStyle(color: Colors.white))
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
