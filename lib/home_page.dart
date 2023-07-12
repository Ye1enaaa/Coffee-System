import 'package:coffee_system/db_helper.dart';
import 'package:flutter/material.dart';

import 'form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List <Map<String, dynamic>> dataList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
  }

  Future <void> _fetchData() async {
    List<Map<String, dynamic>> data = await DatabaseHelper().fetchData();
    setState(() {
      dataList = data;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home Page')
      ),
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: ListView.builder(
          itemCount: dataList.length,
          itemBuilder:(context, index){
            Map<String, dynamic> data = dataList[index];
            return ListTile(
              title: Text(data['customer_name']),
            );
          }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _fetchData();
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const FormPage()));
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}