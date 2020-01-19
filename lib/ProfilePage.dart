import 'package:flutter/material.dart';
import 'package:VeggieBuddie/loginPage.dart';
import 'package:firebase_database/firebase_database.dart';

final databaseReference = FirebaseDatabase.instance.reference();

Map<String, bool> values = {
    'Soybeans': false,
    'Crustacean shellfish': false,
    'Peanuts': false,
    'Tree nuts': false,
    'Fish': false,
    'Wheat': false,
    'Eggs': false,
    'Milk': false,
  };

Future test() async{
  databaseReference.once().then((DataSnapshot snapshot) {
      values=Map<String,bool>.from(snapshot.value[name]['food']);
    });
}

class Profile extends StatefulWidget {
  Profile({Key key, this.title}) : super(key: key);
  final String title;
  ProfilePage createState() => ProfilePage();
}

class ProfilePage extends State<Profile> {
  var _result;
  @override
  void initState() {
    /* WidgetsBinding.instance.addPostFrameCallback((_) async {
            await test();
          }); */
          test().then((result){
            setState(() {
                _result = result;
            });
            print("Data retrived");
          });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(_result==null)
    {
      print("Loading...");
    }
    return Stack(children: <Widget>[
      Container(
          child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.blue[400], Colors.blue[100]],
                ),
              ),
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        imageUrl,
                      ),
                      radius: 60,
                      backgroundColor: Colors.transparent,
                    ),
                    SizedBox(height: 40),
                    Text(
                      'NAME',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                    Text(
                      name,
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'EMAIL',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                    Text(
                      email,
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 40),
                    RaisedButton(
                      onPressed: () {
                        signOutGoogle();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) {
                          return LoginPage();
                        }), ModalRoute.withName('/'));
                      },
                      color: Colors.deepPurple,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Sign Out',
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                      ),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                    ),
                    Expanded(
                        child: Stack(children: <Widget>[
                      ListView(
                        children: values.keys.map(
                          (String key) {
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
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: FloatingActionButton(
                              onPressed: () async {
                                await createRecord();
                              },
                              child: Icon(Icons.add),
                            ),
                          ))
                    ]))
                  ])))),
    ]);
  }

  Future createRecord() async {
    databaseReference.child(name).update({'food': values});
  }
}
