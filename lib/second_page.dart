import 'package:flutter/material.dart';
import 'package:stream_sample/main.dart';
import 'package:stream_sample/utils.dart';

class SecondPage extends StatefulWidget {
  final String id;
  final UsersModel data;
  const SecondPage(this.id, this.data, {Key? key}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final fullNameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final companyCtrl = TextEditingController();

  _update() {
    users
        .doc(widget.id)
        .update({
          "full_name": fullNameCtrl.text,
          "age": int.parse(ageCtrl.text),
          "company": companyCtrl.text,
        })
        .then((value) => debugPrint("succcess update :  "))
        .catchError((err) => debugPrint("error update: $err"));
  }

  @override
  void initState() {
    fullNameCtrl.text = widget.data.fullName;
    companyCtrl.text = widget.data.company;
    ageCtrl.text = widget.data.age.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(hintText: "FullName"),
                controller: fullNameCtrl,
              ),
              TextField(
                decoration: const InputDecoration(hintText: "Company"),
                controller: companyCtrl,
              ),
              TextField(
                decoration: const InputDecoration(hintText: "Age"),
                controller: ageCtrl,
              ),
              ElevatedButton(onPressed: _update, child: const Text("Update"))
            ],
          ),
        ),
      ),
    );
  }
}
