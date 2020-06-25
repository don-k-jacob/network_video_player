
import 'package:flutter/material.dart';
import 'package:networkvideos/Networking/data.dart';

import 'package:networkvideos/vedio_player.dart';


void main() => runApp(MyApp());
//File jsonFile=new File('assets/data.json');
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
Data mData= Data();
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark() ,
      home: Home(),
    );
  }
}
List<Data> data_ = List<Data>();
Data _data=Data();
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
void get()async{

  var dta=await _data.getData();
  data_=await parseJosn(dta);
  print(data_);
}
class _HomeState extends State<Home> {
  @override
  void initState() {
    setState(() {
      get();
    });
//    data = parseJosn(jsonFile.readAsStringSync());
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    setState(() {
      get();
    });
    return Scaffold(
      backgroundColor: Color(0xff1E1F28),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Row(
                children: <Widget>[
                  Text("Movies",style: TextStyle(
                      color: Color(0xffF7F7F7),
                      fontWeight: FontWeight.bold,
                      fontSize: 34
                  ),
                  ),
                  Spacer(),
                  IconButton(icon: Icon(Icons.refresh,color: Color(0xffF7F7F7),), onPressed: (){
                    setState(() {
                      get();
                    });
                  }),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: MediaQuery.of(context).size.height/1.25,
                child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: data_.length,

                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Player(data: data_.elementAt(index),)));
                      },
                      child: Container(
                        color: Color(0xff2A2C36),
                       height: 100,
                        width: 300,
                        child: Row(
                          children: [
                            Container(
                              height: 100,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                image: DecorationImage(image: NetworkImage(data_.elementAt(index).thumb),
                                fit: BoxFit.cover),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  Text("${data_.elementAt(index).title}",style: TextStyle(
                                   color: Colors.white,
                                    fontSize: 15
                                  ),),

                                  Text("${data_.elementAt(index).subtitle}",style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15
                                  ),),

                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => const Divider(),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
List<Data> parseJosn(dynamic response) {
//  print(response);
  if (response == null) {
    return [];
  }
  return response.map<Data>((json) => new Data.fromJson(json)).toList();
}