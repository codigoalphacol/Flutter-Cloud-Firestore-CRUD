import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyQueryPage(),
    );
  }
}

class MyQueryPage extends StatefulWidget {
  @override
  _MyQueryPageState createState() => _MyQueryPageState();
}

class _MyQueryPageState extends State<MyQueryPage> {
  var selectedCurrency,selectedType;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('DropDown'),
        ),
        body: new Form(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 17.0),
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    icon: Icon(Icons.access_alarm),
                    hintText: 'Alguna cosa',
                    labelText: "Comida"),
              ),
              SizedBox(
                height: 20.0,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection("food").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    Text("Loading...");
                  } else {
                    List<DropdownMenuItem> foodItems = [];
                    for (int i = 0; i < snapshot.data.documents.length; i++) {
                      DocumentSnapshot ds = snapshot.data.documents[i];
                      foodItems.add(DropdownMenuItem(
                        child: Text(
                          ds.documentID,
                          style: TextStyle(color: Colors.grey),
                        ),
                        value: "${ds.documentID}",
                      )
                      );
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.fastfood, size: 25.0, color: Colors.orange),
                        SizedBox(width: 50.0,),
                        DropdownButton(
                          items: foodItems,
                          onChanged: (currencyValue){
                            final snackBar=SnackBar(
                              content: Text('Select a Food $currencyValue', style: TextStyle(color: Colors.orangeAccent),),
                            );
                            Scaffold.of(context).showSnackBar(snackBar);
                            setState(() {
                             selectedCurrency=currencyValue; 
                            });
                          },
                          value: selectedCurrency,
                          isExpanded: false,
                          hint: new Text("Select Food"),
                        ),
                      ],
                    );
                  }
                },
              )
            ],
          ),
        ));
  }
}
