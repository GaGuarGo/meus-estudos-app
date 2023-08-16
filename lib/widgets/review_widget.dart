import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReviewWidget extends StatefulWidget {
  final FirebaseUser user;
  ReviewWidget({this.user});

  @override
  _ReviewWidgetState createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  final _titleController = new TextEditingController();

  DateTime _timePicked;
  String _errorText = '';

  TimeOfDay _initialTime = TimeOfDay.now();
  TimeOfDay _finalTime = TimeOfDay.now();

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
          onPressed: () async {
            if (_timePicked != null &&
                _titleController.text.trim() != null &&
                _initialTime != null &&
                _finalTime != null) {
              Map<String, dynamic> event = {
                'eventName': _titleController.text,
                'from': _timePicked.add(Duration(hours: _initialTime.hour)),
                'to': _timePicked.add(Duration(hours: _finalTime.hour)),
              };

              await Firestore.instance
                  .collection('users')
                  .document(widget.user.uid)
                  .collection('events')
                  .add(event);
            } else {
              setState(() {
                _errorText = 'Preencha todos os campos!';
              });
            }
          },
          child: Text(
            'Adicionar',
            style: TextStyle(color: Colors.blueAccent),
          ),
        )
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.purple,
      title: Text(
        'Adicionar novo evento:',
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontSize: MediaQuery.of(context).size.width * 0.045),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _timePickerField(
                  time: _initialTime,
                  title: 'Começo',
                  getTime: _getInitialTime,
                ),
                _timePickerField(
                  time: _finalTime,
                  title: 'Final',
                  getTime: _getFinalTime,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 6),
            // ignore: missing_required_param
            // ignore: deprecated_member_use
            child: RaisedButton(
              onPressed: () async {
                final pickedDay = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)));

                if (pickedDay != null) {
                  setState(() {
                    _timePicked = pickedDay;
                  });
                  return _timePicked;
                } else {}
              },
              color: Colors.purple,
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  _timePicked == null
                      ? 'Escolha o dia'
                      : 'Dia: ${_timePicked.day}/${_timePicked.month}/${_timePicked.year}',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: MediaQuery.of(context).size.width * 0.025),
                ),
              ),
            ),
          ),
          /*
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            child: DropdownButton<Color>(
              dropdownColor: Colors.white,
              style: TextStyle(color: Colors.white),
              isExpanded: true,
              value: _dropColor,
              hint: _dropColor == null
                  ? Text(
                      _dropColor == null
                          ? 'Selecione uma cor:'
                          : 'Cor: ${_dropColor.toString()}',
                      style: TextStyle(color: Colors.white),
                    )
                  : Container(
                      height: 30,
                      width: 30,
                      color: _dropColor,
                    ),
              onChanged: (Color value) {
                setState(() {
                  _dropColor = value;
                });
              },
              items: _droppedColors
                  .map((Color color) => DropdownMenuItem<Color>(
                        value: color,
                        child: Container(
                          height: 30,
                          width: 30,
                          color: color,
                        ),
                      ))
                  .toList(),
            ),
          ),
          */
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: TextField(
              controller: _titleController,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelText: 'Título do evento',
                labelStyle: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.normal),
              ),
            ),
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
                ),
        ],
      ),
    );
  }

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
