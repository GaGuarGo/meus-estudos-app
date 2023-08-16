import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meus_estudos_app/classes/calendar_class.dart';
import 'package:meus_estudos_app/tabs/events_tab.dart';
import 'package:meus_estudos_app/widgets/review_widget.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ReviewTab extends StatefulWidget {
  final FirebaseUser user;

  ReviewTab({this.user});

  @override
  _ReviewTabState createState() => _ReviewTabState();
}

class _ReviewTabState extends State<ReviewTab> {
  @override
  void initState() {
    super.initState();
    _initializeEventColor();
  }

  List<Color> _colorCollection;

  void _initializeEventColor() {
    this._colorCollection = <Color>[];
    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF01A1EF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));
    _colorCollection.add(const Color(0xFF0A8043));
  }

  List<Meeting> meetings;
  Map<String, dynamic> eventMap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Calendário',
          style: TextStyle(
            color: CupertinoColors.activeBlue,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => ReviewWidget(
                    user: widget.user,
                  ));
        },
        child: Icon(
          Icons.add,
          color: Colors.purple,
        ),
        backgroundColor: Colors.white,
        elevation: 20.0,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.8,
            // ignore: deprecated_member_use
            child: RaisedButton(
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (context) => ListEvents(user: widget.user)
                );
              },
              color: CupertinoColors.activeBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  'Ver os meus Eventos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                )
              ),
            ),
          ),
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
                        valueColor: AlwaysStoppedAnimation(Colors.purple),
                      ),
                    );
                  else
                    return Container(
                      child: SfCalendar(
                        todayHighlightColor: CupertinoColors.activeBlue,
                        view: CalendarView.month,
                        dataSource: MeetingDataSource(
                            _getDataSource(events: snapshot.data.documents)),
                        monthViewSettings: MonthViewSettings(
                          showAgenda: true,
                        ),
                      ),
                    );
                }),
          ),
        ],
      ),
    );
  }

  List<Meeting> _getDataSource({List<DocumentSnapshot> events}) {
    meetings = <Meeting>[];
    eventMap = {};
    if (events.isNotEmpty) {
      final Random random = new Random();
      events.forEach((doc) {
        DateTime from = doc.data['from'].toDate();
        DateTime to = doc.data['to'].toDate();

        eventMap = {
          'eventName': doc.data['eventName'],
          'from': from,
          'to': to,
          'isAllDay': false,
          'Color': _colorCollection[random.nextInt(9)],
        };

        Meeting eventNow = Meeting(
          eventName: eventMap['eventName'],
          from: eventMap['from'],
          to: eventMap['to'],
          background: eventMap['Color'],
          isAllDay: eventMap['isAllDay'],
        );

        meetings.add(eventNow);
      });

      return meetings;
    } else {
      meetings = <Meeting>[];
      return meetings;
    }
  }
}
