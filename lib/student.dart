import 'package:flutter/material.dart';
import 'package:student_record/dbhelper.dart';

class Student{
  int? id;
  String? name;
  String? location;
  int? contact;

  Student(
      this.id,
      this.name,
      this.location,
      this.contact

      );
  Student.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    location = map['location'];
    contact = map['contact'];
  }

Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnLocation: location,
      DatabaseHelper.columnContact: contact,
    };
}

}

