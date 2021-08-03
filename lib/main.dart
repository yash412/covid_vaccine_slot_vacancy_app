import 'dart:convert';

import 'package:covid_vaccine_slot_vacancy_app/slots.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'slots.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.teal,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //------------------------------------------------------------------
  TextEditingController pincodecontroller = TextEditingController();
  TextEditingController daycontroller = TextEditingController();
  List slots = [];
  //------------------------------------------------------------------

  fetchslots() async {
    await http
        .get(Uri.parse(
            'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByPin?pincode=' +
                pincodecontroller.text +
                '&date=' +
                daycontroller.text))
        .then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        slots = result['sessions'];
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Slot(
                    slots: slots,
                  )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Vaccination Slots')),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
            Container(
              margin: EdgeInsets.all(20),
              height: 250,
              child: Image.asset('assets/vaccine.jpg'),
            ),
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
              child: TextField(
                controller: pincodecontroller,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(hintText: 'Enter PIN Code'),
              ),
            ),
            Container(
              height: 60,
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: TextField(
                controller: daycontroller,
                decoration: InputDecoration(
                  hintText: 'Enter Date',
                ),
                onTap: () async {
                  var date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100));
                  daycontroller.text = DateFormat('dd-MM-yyyy hh:mm:ss')
                      .format(date!)
                      .substring(0, 10);
                },
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.only(top: 5, right: 20, left: 20),
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor)),
                onPressed: () {
                  fetchslots();
                },
                child: Text('Find Slots'),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
