import 'dart:convert';

import 'package:coffee_system/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'form_page.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:http/http.dart' as http;
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
  Future<String> getPhoneNumberFromPrefs() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('phone_number') ?? '';
  }
  // Function to send SMS
  Future <void> sendSms() async {
    String phoneNumber = await getPhoneNumberFromPrefs();
    

    Map <String, dynamic> smsBody = {
      'phone_number' : '$phoneNumber',
      'message' : 'Hello Erickson, your sorted coffee beans are now ready to be pick up!! Thank you.'
    };
    final response = await http.post(
      Uri.parse(sendSMSURL),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(smsBody)
    );
    if(response.statusCode == 200){
       final snackBar = SnackBar(
        content: Text('SMS Successfully Sent'),
        duration: Duration(seconds: 3), 
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print('SMS Successfully Sent');
    }
  }

  void printPhoneNumber() async {
    String? phoneNumber = await getPhoneNumberFromPrefs();
    print('Stored Phone Number: $phoneNumber');
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
            double desiredHeight = MediaQuery.of(context).size.height;
            String phoneNumber = data['customer_number'];
            void storePhoneNumberToPrefs() async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('phone_number', phoneNumber);
            }
            return Dismissible(
              key: UniqueKey(),
              child: GestureDetector(
                onTap: (){
                  storePhoneNumberToPrefs();
                },
                child: Container(
                  //color: Colors.red,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 2.0
                      )
                    )
                  ),
                  height: desiredHeight * 0.1,
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      const Icon(
                        LineIcons.laughingSquintingFaceAlt,
                        size: 70,
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: ${data['customer_name']}',
                            style: GoogleFonts.poppins(
                              fontSize: 22
                            ),
                          ),
                          Text(
                            'Phone Number: ${data['customer_number']}',
                            style: GoogleFonts.poppins(
                              fontSize: 22
                            ),
                          ),
                          Text(
                            'Address: ${data['customer_address']}',
                            style: GoogleFonts.poppins(
                              fontSize: 22
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(onPressed: (){
                        sendSms();
                      }, child: const Text('Send'))
                    ],
                  ),
                ),
              ),
              onDismissed: (direction) {
                if(direction == DismissDirection.endToStart){
                  //delete function
                }
              },
            );
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async {
          printPhoneNumber();
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const FormPage()));
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}