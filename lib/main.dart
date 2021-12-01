import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stream_sample/second_page.dart';
import 'utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  addUser() {
    users.add({
      'full_name': "John Doe", // John Doe
      'company': "PT. Maju Mundur", // Stokes and Sons
      'age': 22 // 42
    }).then((value) {
      debugPrint("User Added");
      // ignore: invalid_return_type_for_catch_error
    }).catchError((error) => debugPrint("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
            stream: users.doc('AivI29I9sBQdsufvcaPP').snapshots(),
            builder: (context, snapshot) {
              return Text("${snapshot.data!['age']}");
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addUser();
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                future: users.get(),
                builder: (context, snapshot) {
                  return ItemList(snapshot);
                },
              ),
            ),
            Container(color: Colors.black12, height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: users.snapshots(),
                  builder: (context, snapshot) {
                    return ItemList(snapshot);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;
  const ItemList(this.snapshot, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final ff = snapshot.data!.docs;
      return SingleChildScrollView(
        child: Column(
          children: ff.map((e) {
            final fv = UsersModel.json(e);
            return ListTile(
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: const Text('Are you sure want to delete?'),
                      actions: [
                        TextButton(
                          style: TextButton.styleFrom(primary: Colors.red),
                          onPressed: () {
                            users.doc(e.id).delete();
                            Navigator.pop(context);
                          },
                          child: const Text("Delete"),
                        )
                      ],
                    );
                  },
                );
              },
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SecondPage(e.id, fv),
                  ),
                );
              },
              title: (Text(fv.fullName)),
              subtitle: Text("${fv.age}"),
              trailing: const Icon(Icons.arrow_right_alt),
            );
          }).toList(),
        ),
      );
    }

    return const CircularProgressIndicator();
  }
}

class UsersModel {
  final String fullName;
  final String company;
  final int age;

  UsersModel(this.fullName, this.company, this.age);

  factory UsersModel.json(x) {
    return UsersModel(x['full_name'], x['company'], x['age']);
  }
}
