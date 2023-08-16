import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meus_estudos_app/model/study_model.dart';

// ignore: must_be_immutable
class GradeAlert extends StatefulWidget {
  FirebaseUser user;
  String grade;
  GradeAlert({this.grade, this.user});

  @override
  _GradeAlertState createState() => _GradeAlertState();
}

class _GradeAlertState extends State<GradeAlert> {
  final _subjectController = TextEditingController();

  void _clear() {
    _subjectController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
            if (_subjectController.text.isNotEmpty) {
              Map<String, dynamic> data = {
                'subject': _subjectController.text,
                'grade': widget.grade,
                'status': 0,
              };

              StudyModel.of(context).addSubject(
                  grade: widget.grade, userId: widget.user.uid, data: data);
                  _clear();
            }
          },
          child: Text(
            'Adicionar',
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.purple,
      title: Text(
        'Escolha um novo tópico para ${widget.grade}:',
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      content: Container(
        child: TextField(
          controller: _subjectController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              labelText: 'Digite o novo tópico',
              labelStyle: TextStyle(color: Colors.white),
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white))),
        ),
      ),
    );
  }
}
