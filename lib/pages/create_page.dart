import 'package:employee/models/employe_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/https_service.dart';
import '../services/log_service.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  _createEmploye() async{
    String name = _nameController.text.toString().trim();
    int salary = int.parse(_salaryController.text.toString().trim());
    int age =int.parse(_ageController.text.toString().trim());

    Employe employe = Employe(name: name,salary: salary,age: age);

    var response = await Network.POST(Network.API_POST_CREATE, Network.paramsCreate(employe));
    LogService.d(response!);
    Employe employeRes = Network.parsePostRes(response);
    backToFinish();
  }

  backToFinish(){
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Text("Create Post"),
          ),
          body: Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        hintText: "Name"
                    ),
                  ),
                ),
                Container(
                  child: TextField(
                    controller: _salaryController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Salary",
                    ),
                  ),
                ),
                Container(
                  child: TextField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Age",
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 10),
                    width: double.infinity,
                    child: MaterialButton(
                      color: Colors.blue,
                      onPressed: () {
                        _createEmploye();
                      },
                      child: Text("Create"),
                    )
                ),
              ],
            ),
          ),
        )
    );
  }
}