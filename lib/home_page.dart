import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:student_record/dbhelper.dart';
import 'package:student_record/student.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final dbHelper = DatabaseHelper.instance;

  List<Student> students = [];
  List<Student> studentsByName = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController contactController = TextEditingController();


  TextEditingController idUpdateController = TextEditingController();
  TextEditingController nameUpdateController = TextEditingController();
  TextEditingController locationUpdateController = TextEditingController();
  TextEditingController contactUpdateController = TextEditingController();

  TextEditingController idDeleteController = TextEditingController();

  TextEditingController queryController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _showMessageInScaffold(String message) {
    _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(message),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 5,
        child: Scaffold(
          key: _scaffoldKey,
      appBar: AppBar(
        bottom: TabBar(
          tabs: [
            Tab(text: 'Insert',),
            Tab(text: 'View',),
            Tab(text: "Query",),
            Tab(text: 'Update',),
            Tab(text: "Delete",)
          ],
        ),
        title: Text('Student Record'),
      ),
          body: TabBarView(
            children: [
              Center(
                child: ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Student Name',
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: TextField(
                        controller: locationController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Student Location'
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                        child: TextField(
                            controller: contactController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Student Contact'
                            ),
                        ),
                    ),
                    ElevatedButton(
                      child: Text('Insert Student Details'),
                      onPressed: (){
                      String name = nameController.text;
                      String location = locationController.text;
                      int contact = int.parse(contactController.text);
                      _insert(name, location, contact);
                    },
                    ),
                  ],
                ),
              ),
              Container(
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: students.length + 1,
                    itemBuilder: (BuildContext context, int index){
                      if(index == students.length) {
                        return ElevatedButton(
                          child: Text("Refresh"),
                          onPressed: () {
                            setState(() {
                              _queryAll();
                            });
                          },
                        );
                      }
                      return Container(
                        height: 40,
                        child: Center(
                         child: Text(
                            '[${students[index].id}] ${students[index].name} \n ${students[index].location} - ${students[index].contact}  ',
                           style: TextStyle(fontSize: 18),
                          ),
                        ),
                      );
                    }),
              ),
              SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        child: TextField(
                          controller: queryController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Student Name',
                          ),
                          onChanged: (text) {
                            if(text.length >= 2) {
                              setState(() {
                                _query(text);
                              });
                            }else{
                              setState(() {
                                studentsByName.clear();
                              });
                            }
                          },
                        ),
                        height: 100,
                      ),
                      Container(
                        height: 300,
                        child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: studentsByName.length,
                            itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 50,
                            margin: EdgeInsets.all(2),
                            child: Center(
                              child: Text(
                                '[${studentsByName[index].id}] ${studentsByName[index].name} - ${studentsByName[index].location} - ${studentsByName[index].contact}',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        child: TextField(
                          controller: idUpdateController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Student Id'
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: TextField(
                          controller: nameUpdateController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Student Name',
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: TextField(
                          controller: locationUpdateController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Student Location',
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: TextField(
                          controller: contactUpdateController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Student Contact',
                          ),
                        ),
                      ),
                      ElevatedButton(
                          child: Text('Update Student Details'),
                          onPressed: (){
                            int id = int.parse(idUpdateController.text);
                            String name = nameUpdateController.text;
                            String location = locationUpdateController.text;
                            int contact = int.parse(contactUpdateController.text);
                            _update(id, name, location, contact);
                       },
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: TextField(
                        controller: idDeleteController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Student Id'
                        ),
                      ),
                    ),
                    ElevatedButton(
                     child: Text('Delete'),onPressed: () {
                     int id = int.parse(idDeleteController.text);
                     _delete(id);
                     },
                    ),
                  ],
                ),
              ),
            ],
          ),
    ),
    );
  }

  void _insert(name, location, contact ) async{

    Map<String, dynamic> row = {
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnLocation: location,
      DatabaseHelper.columnContact: contact
    };
    Student student = Student.fromMap(row);
    final id = await dbHelper.insert(student);
    _showMessageInScaffold('inserted row id: $id');
  }

  void _queryAll() async{
    final allRows = await dbHelper.queryAllRows();
    students.clear();
    allRows.forEach((row) => students.add(Student.fromMap(row)));
    _showMessageInScaffold('Query done.');
    setState(() {

    });
  }

  void _query(name) async {
    final allRows = await dbHelper.queryRows(name);
    studentsByName.clear();
    allRows.forEach((row) =>  studentsByName.add(Student.fromMap(row)));
  }

  void _update(id, name, location, contact) async{
    Student student = Student(id, name, location, contact);
    final rowsAffected = await dbHelper.update(student);
    _showMessageInScaffold('updated $rowsAffected row(s)');
  }

  void _delete(id) async {
    final rowsDeleted = await dbHelper.delete(id);
    _showMessageInScaffold('deleted $rowsDeleted row(s): row $id');
  }
}
