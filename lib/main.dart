
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
List<Data> data = List<Data>();
Data _data=Data();
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
void get()async{
  var dta=await _data.getData();
  data=await parseJosn(dta);
  print(data);
}
class _HomeState extends State<Home> {
  @override
  void initState() {
    get();
//    data = parseJosn(jsonFile.readAsStringSync());
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
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
                  IconButton(icon: Icon(Icons.search,color: Color(0xffF7F7F7),), onPressed: (){}),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: MediaQuery.of(context).size.height/1.3,
                child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: data.length,

                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Player(data: data.elementAt(index),)));
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
                                image: DecorationImage(image: NetworkImage(data.elementAt(index).thumb),
                                fit: BoxFit.cover),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                Text("Title:\n ${data.elementAt(index).title}",style: TextStyle(
                                 color: Colors.white,
                                  fontSize: 15
                                ),),

                                Text("SubTitle:\n ${data.elementAt(index).subtitle}",style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15
                                ),),

                              ],
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