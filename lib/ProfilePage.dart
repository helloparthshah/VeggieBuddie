import 'package:flutter/material.dart';
import 'package:VeggieBuddie/loginPage.dart';
import 'package:firebase_database/firebase_database.dart';

final databaseReference = FirebaseDatabase.instance.reference();

class Profile extends StatefulWidget {
  Profile({Key key, this.title}) : super(key: key);
  final String title;
  ProfilePage createState() => ProfilePage();
}

/* class Profile extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue[100], Colors.blue[400]],
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
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {return LoginPage();}), ModalRoute.withName('/'));
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
              /* FloatingActionButton(
                onPressed: () {  
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Details()),
                );
                },
                ) */
            ],
          ),
        ),
      ),
    );
  }
} */
class ProfilePage extends State<Profile> {
  Map<String, bool> values = {
    'Milk': false,
    'Eggs': false,
    'Fish (bass, flounder, cod)': false,
    'Crustacean shellfish (crab, lobster, shrimp)': false,
    'Tree nuts (almonds, walnuts, pecans)': false,
    'Peanuts': false,
    'Wheat': false,
    'Soybeans': false,
  };
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
          child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.blue[100], Colors.blue[400]],
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
                    ]))
                  ])))),
    ]);
  }

  Future createRecord() async {
    databaseReference.once().then((DataSnapshot snapshot) {
      if (snapshot.value == null)
        databaseReference.child("1").set({
          'name': name,
          'email': email,
          'food': values,
        });
      else
        databaseReference.child("${snapshot.value.length}").set({
          'name': name,
          'email': email,
          'food': values,
        });
    });
  }
}
