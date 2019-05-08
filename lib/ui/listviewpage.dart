import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipes/ui/addpage.dart';
import 'package:recipes/ui/informationPage.dart';
import 'package:recipes/ui/updatepage.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'View Page1',
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      home: new MyListPage(),
    );
  }
}

class CommonThings {
  static Size size;
}

class MyListPage extends StatefulWidget {
  @override
  _MyListPageState createState() => _MyListPageState();
}

class _MyListPageState extends State<MyListPage> {

  TextEditingController phoneInputController;
  TextEditingController nameInputController;
  String id;
  final db = Firestore.instance;
  String name;
  String phone;

  //create tha funtion navigateToDetail
  navigateToDetail(DocumentSnapshot ds) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyUpdatePage(
                  ds: ds,
                )));
  }

  //create tha funtion navigateToDetail
  navigateToInfo(DocumentSnapshot ds) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyInfoPage(
                  ds: ds,
                )));
  }


  void deleteData(DocumentSnapshot doc) async {
    await db.collection('CRUD').document(doc.documentID).delete();
    setState(() => id = null);
  }

  @override
  Widget build(BuildContext context) {

    CommonThings.size = MediaQuery.of(context).size;
    //print('Width of the screen: ${CommonThings.size.width}');
    return new Scaffold(
      appBar: AppBar(
        title: Text('View Page1'),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection("colrecipes").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Text("loading....");
          }
          int length = snapshot.data.documents.length;
          //print("from the streamBuilder: "+ snapshot.data.documents[]);
          // print(length.toString() + " doc length");
          return ListView.builder(
            itemCount: length,
            itemBuilder: (_, int index) {
              final DocumentSnapshot doc = snapshot.data.documents[index];
              return new Container(
                padding: new EdgeInsets.all(3.0),
                child: Card(
                  child: Row(
                    children: <Widget>[
                      
                      new Container(
                        padding: new EdgeInsets.all(5.0),
                        child: Image.network(
                          '${doc.data["image"]}' + '?alt=media',
                        ),
                        width: 100,
                        height: 100,
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text(
                            doc.data["name"],
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 21.0,
                            ),
                          ),
                          subtitle: Text(
                            doc.data["phone"],
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 21.0),
                          ),
                          onTap: () => navigateToDetail(doc),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                        onPressed: () => deleteData(doc), //funciona
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.remove_red_eye,
                          color: Colors.blueAccent,
                        ),
                         onPressed: () => navigateToInfo(doc),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.pinkAccent,
        onPressed: () {
          Route route = MaterialPageRoute(builder: (context) => MyAddPage());
          Navigator.push(context, route);
        },
      ),
    );
  }
}
