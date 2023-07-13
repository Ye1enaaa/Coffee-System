import 'package:coffee_system/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class FormPage extends StatefulWidget {
  const FormPage({ Key? key }) : super(key: key);

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  void saveData () async {
    String name = nameController.text;
    String number = numberController.text;
    String address = addressController.text;

    Map<String, dynamic> data = {
      'customer_name' : name,
      'customer_number' : number,
      'customer_address' : address
    };
    int result  = await DatabaseHelper().insertData(data);
    if(result != null){
      print(data);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Customer'),
      ),
      body: Form(
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person_sharp),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: numberController,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: addressController,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: (){
                saveData();
                Navigator.pop(context);
              }, child: const Text('SUBMIT'))
          ],
        ) 
      ),
    );
  }
}