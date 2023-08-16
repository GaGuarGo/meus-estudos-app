import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meus_estudos_app/model/study_model.dart';

class WeekButton extends StatefulWidget {
  final FirebaseUser user;
  WeekButton({this.user});

  @override
  _WeekButtonState createState() => _WeekButtonState();
}

class _WeekButtonState extends State<WeekButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          tileMode: TileMode.mirror,
          begin: Alignment.centerLeft,
          end: Alignment.bottomRight,
          colors: [
            CupertinoColors.link,
             CupertinoColors.link
          ],
        ),
      ),
      child: FloatingActionButton(
        elevation: 16.0,
        backgroundColor: Colors.transparent,
        tooltip: 'Adicionar Horário',
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => WeekDialog(
                    user: widget.user,
                  ));
        },
        child: Center(
          child: Icon(
            CupertinoIcons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class WeekDialog extends StatefulWidget {
  final FirebaseUser user;
  WeekDialog({this.user});

  @override
  _WeekDialogState createState() => _WeekDialogState();
}

class _WeekDialogState extends State<WeekDialog> {
  List<String> _days = [
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
    'Sábado',
    'Domingo'
  ];

  String _currentValue;
  TimeOfDay _initialTime = TimeOfDay.now();
  TimeOfDay _finalTime = TimeOfDay.now();

  String _errorText = '';

  Future<Null> _getInitialTime() async {
    final TimeOfDay selectedTime = await showTimePicker(
      context: context,
      initialTime: _initialTime,
    );
    if (selectedTime != null) {
      setState(() {
        _initialTime = selectedTime;
      });
      print(_initialTime.format(context));
    }
  }

  Future<Null> _getFinalTime() async {
    final TimeOfDay selectedTime = await showTimePicker(
      context: context,
      initialTime: _finalTime,
    );
    if (selectedTime != null) {
      setState(() {
        _finalTime = selectedTime;
      });
      print(_finalTime.format(context));
    }
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
            if (_initialTime != null &&
                _finalTime != null &&
                _currentValue != null) {
              Map<String, dynamic> data = {
                'semana': _currentValue,
                'começo': _initialTime.format(context),
                'final': _finalTime.format(context),
                'subject': '',
                'topic': '',
              };

              StudyModel.of(context).addHour(
                  data: data,
                  userId: widget.user.uid,
                  startTime: _initialTime.format(context));
              Navigator.of(context).pop();
            } else {
              setState(() {
                _errorText =
                    'Por Favor escolha um horário! \n Ou um dia da semana!';
              });
            }
          },
          child: Text(
            'Adicionar',
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: CupertinoColors.link,
      title: Text(
        'Escolha um horário:',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.normal,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Expanded(
                child: _timePickerField(
                    title: 'Começo',
                    time: _initialTime,
                    getTime: _getInitialTime)),
            SizedBox(
              width: 6,
            ),
            Expanded(
                child: _timePickerField(
              title: 'Final',
              time: _finalTime,
              getTime: _getFinalTime,
            )),
          ]),
          SizedBox(
            width: 8,
          ),
          _errorText != ''
              ? Container(
                  alignment: Alignment.center,
                  margin: _errorText == ''
                      ? EdgeInsets.symmetric(vertical: 2)
                      : EdgeInsets.symmetric(vertical: 0),
                  child: Text(
                    _errorText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                )
              : Container(),
          Container(
            child: DropdownButton(
              dropdownColor: CupertinoColors.link,
              style: TextStyle(color: Colors.white),
              isExpanded: true,
              value: _currentValue,
              hint: Text(
                _currentValue == null
                    ? 'Selecione um dia da semana:'
                    : _currentValue,
                style: TextStyle(color: Colors.white),
              ),
              onChanged: (String value) {
                setState(() {
                  _currentValue = value;
                });
              },
              items: _days
                  .map((String day) => DropdownMenuItem(
                      value: day,
                      child: Container(
                        margin: EdgeInsets.all(4),
                        child: Text(
                          '$day',
                          style: TextStyle(color: Colors.white),
                        ),
                      )))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  //substituir por um datepicker hehe

  Widget _timePickerField({String title, Function getTime, TimeOfDay time}) =>
      Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white),
        ),
        alignment: Alignment.center,
        child: OutlinedButton(
          onPressed: getTime,
          child: Text(
            '$title: ${time.format(context)}',
            style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.normal),
          ),
        ),
      );
}
