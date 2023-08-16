import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meus_estudos_app/model/study_model.dart';
import 'package:meus_estudos_app/tabs/choose_topic_tab.dart';

class SubjectAlert extends StatefulWidget {
  final FirebaseUser user;
  final String id;

  SubjectAlert({this.user, this.id});

  @override
  _SubjectAlertState createState() => _SubjectAlertState();
}

class _SubjectAlertState extends State<SubjectAlert> {
  String _subjectValue;
  String _topicValue;
  String _myTopic;

  String _errorText = '';

  List<String> _subjects = [
    'Matemática',
    'Física',
    'Química',
    'Biologia',
    'Português',
    'Literatura',
    'Inglês',
    'Redação',
    'História',
    'Geografia',
    'Filosofia',
    'Sociologia',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.lightBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        'Adicionar Matéria:',
        style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width * 0.05,
            fontWeight: FontWeight.bold),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            StudyModel.of(context).topicValue = null;
          },
          child: Text(
            'Cancelar',
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () {
            if (StudyModel.of(context).topicValue == null &&
                    _topicValue == null ||
                _subjectValue == null ||
                StudyModel.of(context).topicValue == null) {
              setState(() {
                _errorText = 'Defina todos os campos!';
              });
            } else {
              Map<String, dynamic> data = {
                'subject': _subjectValue,
                'topic': StudyModel.of(context).topicValue,
              };

              StudyModel.of(context).setSubject(
                id: widget.id,
                data: data,
              );
              StudyModel.of(context).topicValue = null;
              Navigator.of(context).pop();
            }
          },
          child: Text(
            'Adicionar',
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButton(
                  dropdownColor: Colors.lightBlue,
                  style: TextStyle(color: Colors.white),
                  isExpanded: true,
                  value: _subjectValue,
                  hint: Text(
                    _subjectValue == null
                        ? 'Selecione uma Matéria:'
                        : _subjectValue,
                    style: TextStyle(color: Colors.white),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _subjectValue = value;
                    });
                  },
                  items: _subjects
                      .map((String subject) => DropdownMenuItem(
                          value: subject,
                          child: Text(
                            subject,
                            style: TextStyle(color: Colors.white),
                          )))
                      .toList(),
                ),
              ),
              SizedBox(
                width: 6,
              ),
              _subjectValue != null
                  ? InkWell(
                      onTap: () async {
                        final String received = await showDialog(
                          context: context,
                          builder: (context) => TopicTab(
                            grade: _subjectValue,
                            value: _topicValue,
                            user: widget.user,
                          ),
                        );
                        setState(() {
                          _myTopic = received;
                        });
                      },
                      child: Text(
                        _myTopic != null
                            ? 'Tópico: $_myTopic'
                            : 'Selecione um tópico:',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          _errorText == ''
              ? Container()
              : Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(6),
                  child: Text(
                    '$_errorText',
                    style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                )
        ],
      ),
    );
  }
}
