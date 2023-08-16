import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meus_estudos_app/model/study_model.dart';
import 'package:meus_estudos_app/widgets/subject_widget.dart';

class WeekWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final FirebaseUser user;
  final String weekDay;
  final String id;
  WeekWidget({this.id, this.weekDay, this.user, this.scaffoldKey});

  @override
  _WeekWidgetState createState() => _WeekWidgetState();
}

class _WeekWidgetState extends State<WeekWidget> {
  @override
  Widget build(BuildContext context) {
    final _style = TextStyle(
      color: Colors.black,
      fontSize: MediaQuery.of(context).size.width * 0.033,
      fontWeight: FontWeight.w900,
    );
    return StreamBuilder(
      stream: Firestore.instance
          .collection('horarios')
          .document(widget.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center();
        else if (snapshot.data['semana'] == widget.weekDay)
          return Dismissible(
            direction: DismissDirection.startToEnd,
            background: Container(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                height: MediaQuery.of(context).size.height * 0.1,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.red)),
                child: Align(
                  alignment: Alignment(-0.9, 0.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                )),
            key: Key(widget.id),
            onDismissed: (direction) {
              StudyModel.of(context).removeHour(
                userId: widget.user.uid,
                timeId: widget.id,
                onSuccess: _onSuccess,
                onFail: _onFail,
              );
            },
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              splashColor: Colors.grey,
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => SubjectAlert(
                          user: widget.user,
                          id: widget.id,
                        ));
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                height: MediaQuery.of(context).size.height * 0.1,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: CupertinoColors.link)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '${snapshot.data['começo']} - ${snapshot.data['final']}:',
                      textAlign: TextAlign.center,
                      style: _style,
                    ),
                    Text(
                      snapshot.data['subject'] == ''
                          ? 'Clique para Definir uma Matéria!'
                          : "${snapshot.data['subject']}",
                      textAlign: TextAlign.center,
                      style: _style,
                    ),
                    Text(
                      snapshot.data['topic'] == ''
                          ? ''
                          : snapshot.data['topic'],
                      textAlign: TextAlign.center,
                      style: _style,
                    ),
                  ],
                ),
              ),
            ),
          );
        else
          return Container();
      },
    );
  }

  _onSuccess() {
    // ignore: deprecated_member_use
    widget.scaffoldKey.currentState.showSnackBar(SnackBar(
      duration: Duration(seconds: 2),
      backgroundColor: Colors.purple,
      content: Text(
        'Horário removido com sucesso!',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    ));
  }

  _onFail() {
    // ignore: deprecated_member_use
    widget.scaffoldKey.currentState.showSnackBar(SnackBar(
      duration: Duration(seconds: 2),
      backgroundColor: Colors.redAccent,
      content: Text(
        'Falha ao remover esse horário!',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    ));
  }
}
