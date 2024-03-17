import 'package:employee/models/employe_model.dart';
import 'package:employee/pages/update_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;

import '../services/https_service.dart';
import '../services/log_service.dart';
import 'create_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  List<Employe> employes = [];

  _loadEmploye() async{
    setState(() {
      isLoading = true;
    });

    var response = await Network.GET(Network.API_POST_LIST, Network.paramsEmpty());
    LogService.d(response!);
    List<Employe> employeList = Network.parsePostList(response);

    setState(() {
      employes = employeList;
      isLoading = false;
    });
  }

  _deleteEmploye(int id) async {
    setState(() {
      isLoading = true;
    });
    var response = await Network.DEL(Network.API_POST_DELETE + id.toString(), Network.paramsEmpty());
    LogService.d(response!);
    _loadEmploye();
  }


  Future _callCreatePage() async {
    bool result = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return const CreatePage();
    }));

    if (result) {
      _loadEmploye();
    }
  }

  Future _callUpdatePage(Employe employe) async {
    bool result = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return UpdatePage(employe: employe);
    }));

    if (result) {
      _loadEmploye();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadEmploye();
  }

  Future<void> _handleRefresh() async {
    _loadEmploye();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text("Employee",style: TextStyle(
          fontSize: 30,
          color: Colors.white,
        ),),
      ),
      body:Stack(
        children: [
          RefreshIndicator(
            onRefresh: _handleRefresh,
            child: ListView.builder(
              itemCount: employes.length,
              itemBuilder: (ctx, index) {
                return _itemOfEmploye(employes[index]);
              },
            ),
          ),
          isLoading
              ? Center(
            child: CircularProgressIndicator(),
          )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _itemOfEmploye(Employe employe) {
    return Slidable(
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (BuildContext context) {
                _callUpdatePage(employe);
              },
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (BuildContext context) {
                _deleteEmploye(employe.id!);
              },
              backgroundColor: Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                employe.name!,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text("${employe.age!}",
                  style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
              Text("${employe.salary!}",
                  style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
              Divider(),
            ],
          ),
        ));
  }

}
