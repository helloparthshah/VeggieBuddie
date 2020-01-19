import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

final databaseReference = FirebaseDatabase.instance.reference();

final myController = TextEditingController();

void createRecord(){
  databaseReference.once().then((DataSnapshot snapshot) {
          if(snapshot.value==null)
          databaseReference.child("1").set({
          'name': myController.text,
          });
  });
}
class Details extends StatelessWidget {
@override
Widget build(BuildContext context) {
  // Build a Form widget using the _formKey created above.
  return Material(
    child:Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 60.0),
          child: TextFormField(
            controller: myController,
            decoration: InputDecoration(
                labelText: 'Enter your Name'
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 100.0, horizontal: 60.0),
          child: RaisedButton(
            onPressed: () {
              createRecord();
            },
            child: Text('Submit'),
          ),
        ),
      ],
    ),
  );
}
}
/* class Details extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
      children:<Widget>[ Directionality( 
        textDirection: TextDirection.ltr,
        child:TextField(
        controller: myController,
        decoration: InputDecoration(
          labelText: "Enter Name:"
        ),
      )),
      FloatingActionButton(
        onPressed: () {  
          databaseReference.once().then((DataSnapshot snapshot) {
          if(snapshot.value==null)
          databaseReference.child("1").set({
          'name': myController.text,
        });
        else
          databaseReference.child("${snapshot.value.length}").set({
          'name': myController.text,
        });
        });
        },
        
      )
      ]
      )
    );
  }
} */