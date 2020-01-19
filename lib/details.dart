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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
/*       title: 'Flutter Demo', */
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  Map<String, bool> values = {
    'Milk' : false,
    'Eggs' : false,
    'Fish (bass, flounder, cod)': false,
    'Crustacean shellfish (crab, lobster, shrimp)' : false,
    'Tree nuts (almonds, walnuts, pecans)': false,
    'Peanuts' : false,
    'Wheat': false,
    'Soybeans': false,
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        title: Text(widget.title),
      ), */
      body: Center(
        child:Stack(
        children:<Widget>[
        ListView(
          children: values.keys.map((String key) {
              return new CheckboxListTile(
                title: new Text(key),
                value: values[key],
                onChanged: (bool value) {
                setState(() {
                values[key] = value;
              });
            },
          );
          },
          ).toList(),
    ),
    Align(
      alignment: Alignment.bottomRight,
      child:Padding(
        padding: EdgeInsets.all(20),
    child: FloatingActionButton(
        onPressed:() async { 
          await createRecord();
          Navigator.pop(context);
          },
        child: Icon(Icons.add),
      ),
    )
    )
        ]
        )
      )
    );
  }
  
  Future createRecord() async{
  databaseReference.once().then((DataSnapshot snapshot) {
    if(snapshot.value==null)
    databaseReference.child("1").set({
      'name': name,
      'email':email,
      'food': values,
  });
  else
    databaseReference.child("${snapshot.value.length}").set({
      'name': name,
      'email':email,
      'food': values,
  });
  });
}
}