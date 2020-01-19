import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:VeggieBuddie/loginPage.dart';

final databaseReference = FirebaseDatabase.instance.reference();

/* class Details extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
} */
/* class Details extends StatefulWidget {
  Details({Key key, this.title}) : super(key: key);
  final String title;
  @override
  Details createState() => Details();
} */
class Details extends StatelessWidget {
  Details({Key key}) : super(key: key);
  Map<String, bool> values = {
    'Milk' : false,
    'Eggs' : false,
    'Fish (e.g., bass, flounder, cod)': false,
    'Crustacean shellfish (e.g., crab, lobster, shrimp)' : false,
    'Tree nuts (e.g., almonds, walnuts, pecans)': false,
    'Peanuts' : false,
    'Wheat': false,
    'Soybeans': false,
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Personalize"),
      ),
      body: Center(
        child: new ListView(
          children: values.keys.map((String key) {
              return new CheckboxListTile(
                title: new Text(key),
                value: values[key],
                onChanged: (bool value) {
                values[key] = value;
            },
          );
          }).toList(),
    ),
    ));
  }
}

void createRecord(){
  databaseReference.once().then((DataSnapshot snapshot) {
    if(snapshot.value==null)
    databaseReference.child("1").set({
      'name': name,
      'email':email,
  });
  else
    databaseReference.child("${snapshot.value.length}").set({
      'name': name,
      'email':email,
  });
  });
}