import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meus_estudos_app/model/study_model.dart';

// ignore: must_be_immutable
class GradeTab extends StatefulWidget {
  FirebaseUser user;
  String gradeId;
  String grade;
  GradeTab({this.gradeId, this.grade, this.user});

  @override
  _GradeTabState createState() => _GradeTabState();
}

class _GradeTabState extends State<GradeTab> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection(widget.grade)
          .document(widget.gradeId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Container();
        else
          return InkWell(
            onTap: () async {
              await Firestore.instance
                  .collection(widget.grade)
                  .document(widget.gradeId)
                  .get()
                  .then((grade) {
                if (grade.data['status'] == 0) {
                  Firestore.instance
                      .collection(widget.grade)
                      .document(widget.gradeId)
                      .updateData({
                    'status': 1,
                  });
                } else {
                  Firestore.instance
                      .collection(widget.grade)
                      .document(widget.gradeId)
                      .updateData({
                    'status': 0,
                  });
                }
              });
            },
            onLongPress: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        backgroundColor: Colors.purple,
                        title: Text(
                          'Deseja realmente remover este Tópico:\n - ${snapshot.data['subject']}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.023),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Cancelar',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              StudyModel.of(context).removeSubject(
                                  userId: widget.user.uid,
                                  grade: widget.grade,
                                  gradeId: widget.gradeId);

                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Excluir',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ));
            },
            child: Container(
              margin: EdgeInsets.only(left: 12, top: 2),
              child: snapshot.data['status'] == 1
                  ? Row(
                      children: [
                        Text(
                          '- ${snapshot.data['subject']}',
                          style: TextStyle(
                              color: Colors.green,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.025),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 20,
                        ),
                      ],
                    )
                  : Text(
                      '- ${snapshot.data['subject']}',
                      style: TextStyle(
                          color: Colors.purple,
                          fontSize: MediaQuery.of(context).size.height * 0.025),
                    ),
            ),
          );
      },
    );
  }
}
