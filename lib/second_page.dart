import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    final fullNameCtrl = TextEditingController();
    final ageCtrl = TextEditingController();
    final companyCtrl = TextEditingController();
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
              ElevatedButton(onPressed: () {}, child: const Text("Update"))
            ],
          ),
        ),
      ),
    );
  }
}
