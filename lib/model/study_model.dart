import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';


class StudyModel extends Model {
  static StudyModel of(BuildContext context) =>
      ScopedModel.of<StudyModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
  }

  String topicValue;

  Future<String> setTopicValue(String value) async {
    topicValue = value;
    return topicValue;
  }

  Future<Null> addSubject(
      {String grade, String userId, Map<String, dynamic> data}) async {
    await Firestore.instance.collection(grade).add(data).then((subject) async {
      await Firestore.instance
          .collection('users')
          .document(userId)
          .collection(grade)
          .document(subject.documentID)
          .setData({'subjectId': subject.documentID});
    });
  }

  Future<Null> removeSubject(
      {@required String userId,
      @required String grade,
      @required String gradeId}) async {
    await Firestore.instance
        .collection('users')
        .document(userId)
        .collection(grade)
        .document(gradeId)
        .delete()
        .then((doc) async {
      await Firestore.instance.collection(grade).document(gradeId).delete();
    });
  }

  Future<Null> addHour(
      {@required Map<String, dynamic> data,
      @required String userId,
      @required String startTime}) async {
    await Firestore.instance
        .collection('horarios')
        .add(data)
        .then((hour) async {
      await Firestore.instance
          .collection('users')
          .document(userId)
          .collection('horarios')
          .document(hour.documentID)
          .setData({
        'scheduleId': hour.documentID,
        'começo': startTime,
      });
    });
  }

  Future<Null> removeHour(
      {String userId,
      String timeId,
      VoidCallback onSuccess,
      VoidCallback onFail}) async {
    await Firestore.instance
        .collection('users')
        .document(userId)
        .collection('horarios')
        .document(timeId)
        .delete()
        .then((_) {
      Firestore.instance.collection('horarios').document(timeId).delete();
      onSuccess();
    }).catchError((e) {
      onFail();
    });
  }

  Future<Null> setSubject({String id, Map<String, dynamic> data}) async {
    await Firestore.instance
        .collection('horarios')
        .document(id)
        .updateData(data);
  }
}
