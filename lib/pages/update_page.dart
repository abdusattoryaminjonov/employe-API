import 'package:employee/models/employe_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/https_service.dart';
import '../services/log_service.dart';

class UpdatePage extends StatefulWidget {
  final Employe employe;
  const UpdatePage({super.key,required this.employe});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();


  _updatePost() async{
    String name = _nameController.text.toString().trim();
    int salary = int.parse(_salaryController.text.toString().trim());
    int age =int.parse(_ageController.text.toString().trim());

    Employe newEmploye = widget.employe;
    newEmploye.name = name;
    newEmploye.salary = salary;
    newEmploye.age = age;

    var response = await Network.PUT(Network.API_POST_UPDATE + newEmploye.id.toString(), Network.paramsUpdate(newEmploye));
    LogService.d(response!);
    Employe postRes = Network.parsePostRes(response);

    backToFinish();
  }

  backToFinish(){
    Navigator.of(context).pop(true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     _nameController.text = widget.employe.name!;
     _salaryController.text = widget.employe.salary.toString();
     _ageController.text = widget.employe.age.toString();
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
            title: Text("Update Post"),
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
                        _updatePost();
                      },
                      child: Text("Update"),
                    )
                ),
              ],
            ),
          ),
        )
    );
  }

}