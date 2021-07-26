import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar_route.dart' as route;
import 'chat.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Gamebox 10 คำถาม'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  double avg = 0.0;
  bool _show = true;
  PageController _pageview = new PageController(initialPage: 0,);
  int _selectedItem = 0;
  List<FlSpot> dummyData2 =  [FlSpot(0,0),FlSpot(1,0),
  FlSpot(2,0),FlSpot(3,0),FlSpot(4,0),FlSpot(5,0),FlSpot(6,0),
  FlSpot(7,0),FlSpot(8,0),FlSpot(9,0)];
  void _onItemTapped(int index) {
    setState(() {
      _selectedItem = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:
      PageView(
          scrollDirection: Axis.horizontal,
          controller: _pageview,
          children:[
          _homepage(context),
            _scoreView(context),
         _scoreBoard(context),
          //  MyChatHomePage()
         //   ChatApp()
            //   _usePoint(context), list customer point

          ]),



      bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.orange,
            primaryColor: Colors.white,
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: TextStyle(color: Colors.white)),
          ),
          child: _show==true? BottomNavigationBar(
            backgroundColor: Colors.orangeAccent,

            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Colors.white,),
                label: 'Home',
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.stacked_line_chart,color: Colors.white),
                label: 'Score',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard,color: Colors.white),
                label: 'Dashboard'),
              BottomNavigationBarItem(
                    icon: Icon(Icons.chat,color: Colors.white),
                    label: 'Friends',

              ),
            ],
            currentIndex: _selectedItem,
            selectedItemColor: Colors.white,
            selectedLabelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),

            onTap:(_selectedItem){
              _onItemTapped(_selectedItem);
              if (_selectedItem==0){
                _pageview.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              }else  if (_selectedItem==1){
                print('see score');
                _pageview.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              }else  if (_selectedItem==2){

                _pageview.animateToPage(
                  2,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );

              }else  if (_selectedItem==3){
                setState(() {
                //  _show=false;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyChatHomePage()),
                );

                _pageview.animateToPage(
                  3,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                ); }
            },
          ):Container(width:200)) ,
      );

  }
 _scoreView(context){
   _buildChartInfo();

   return Column(
   children: [
   Container(padding:EdgeInsets.all(10),
   child:Text('คะแนนทดสอบ')),
   Container(
   padding: EdgeInsets.all(20),
   width: double.infinity,
   child: LineChart(
   LineChartData(
   borderData: FlBorderData(show: false),
   lineBarsData: [

   LineChartBarData(
   spots: dummyData2,
   isCurved: true,
   barWidth: 3,
   colors: [
   Colors.red,
   ],
   ),

   ],
   ),
   ),
   ),
     Row(children:[
       Image.network("http://www.kidlovescode.com/gamebox/pic/teacherexplain.gif", width:180),
       Column(children:[Container(
           child:Text('ความถูกต้อง ',style: TextStyle(fontSize: 18),)),
         Container(
             child:Text((avg.ceil()).toString()+"%",style: TextStyle(fontSize: 50),))

       ])
     ]),
   ],
   );



 }
  _homepage(BuildContext context){
    return //Column(children:[
      // Text("Upoint แพ็กเกจ EasyPoint\n ยินดีต้อยรับเข้าสู่ระบบจัดการคะแนนสำหรับร้ายค้า \n มีปัญหาในการใช้บริการติดต่อที่ upoint@kidlovescode.com\n"),
      _buildShopInfo();

    //]);
  }

  Widget _buildShopInfo() {

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('mainflow_001').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return  _buildList(context, snapshot.data.documents);
      },
    );
  }


  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return
      ListView(
        padding: const EdgeInsets.only(top: 20.0),
        children: snapshot.map((data) => _buildListItem(context, data)).toList(),
      );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(

      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
              child:Column(children: [
                //    Padding(padding: EdgeInsets.only(top:8),child:  Text("CID:"+record.umobile+": แต้มที่ "+customerscore.toString()),),
                Container(child:Row(children: [
                  FlatButton(child: Image.network(record.pic ,width:130),
                    onPressed: (){

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QuestionPage(set:record.set)),
                      );



                    },),
                  Expanded(child:Container(padding:EdgeInsets.only(left:10),child:Text(record.title))),

                ],)),


              ],)
          )
      ),
    );
  }
/* Build dashboard */
  _scoreBoard(BuildContext context){
    return //Column(children:[
      // Text("Upoint แพ็กเกจ EasyPoint\n ยินดีต้อยรับเข้าสู่ระบบจัดการคะแนนสำหรับร้ายค้า \n มีปัญหาในการใช้บริการติดต่อที่ upoint@kidlovescode.com\n"),
      _buildScoreInfo();

    //]);
  }

  Widget _buildScoreInfo() {

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('roommember_001')
          .orderBy("topscore",descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return  _buildScoreList(context, snapshot.data.documents);
      },
    );
  }


  Widget _buildScoreList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return
      ListView(
        padding: const EdgeInsets.only(top: 20.0),
        children: snapshot.map((data) => _buildScoreListItem(context, data)).toList(),
      );
  }

  Widget _buildScoreListItem(BuildContext context, DocumentSnapshot data) {
    final record = RecordScore.fromSnapshot(data);

    return Padding(

      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
              child:Column(children: [
                //    Padding(padding: EdgeInsets.only(top:8),child:  Text("CID:"+record.umobile+": แต้มที่ "+customerscore.toString()),),
                Container(child:Row(children: [
                  FlatButton(child: Image.network(record.pic ,width:90,height:90),
                    ),
                  Column(children:[
                    Container(padding:EdgeInsets.only(left:10),child:Text(record.topscore.toString()
                      ,style: TextStyle(fontSize: 50,color:Colors.red))),
                    Container(padding:EdgeInsets.only(left:10),child:Text(record.name)),

                  ])
                ],)),


              ],)
          )
      ),
    );
  }

  _buildChartInfo() {

    var snapshot =  Firestore.instance.collection('topscore_001')
     .where('user', isEqualTo: '1')
     .getDocuments()
     .then((QuerySnapshot querySnapshot) => {
     querySnapshot.documents.forEach((doc) {

    final restUser = doc.data['user'];
    final restContent = doc.data['set'];
    final restTimestamp = doc.data['timestamp'];
    final restScore = doc.data['topscore'];
    avg += restScore;
    setState(() {
    dummyData2[int.parse(restContent)] = FlSpot((int.parse(restContent)).toDouble(), restScore.toDouble());
    });

    }

    )});
    avg = avg / 10;
  }
}
class Record {
  final String pic,title,set;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['pic'] != null),
        assert(map['title'] != null),
        assert(map['set'] != null),


      pic = map['pic'],
        title = map['title'],
    set = map['set']

  ;

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$pic:$title>";
}
class RecordScore {
  final String name,pic,sid;
  final int topscore;
  final DocumentReference reference;

  RecordScore.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['pic'] != null),

      assert(map['topscore'] != null),
        assert(map['sid'] != null),


        name = map['name'],
        pic = map['pic'],
        sid = map['sid'],
        topscore=map['topscore']

  ;

  RecordScore.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$pic:$sid:$topscore>";
}
class Question {
  final String choice1,choice2,choice3,choice4,answer,title;
  final DocumentReference reference;

  Question.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['choice1'] != null),
        assert(map['choice2'] != null),
        assert(map['choice3'] != null),
        assert(map['choice4'] != null),
        assert(map['title'] != null),

      assert(map['answer'] != null),


        choice1 = map['choice1'],
        choice2 = map['choice2'],
        choice3 = map['choice3'],
        choice4 = map['choice4'],
        title = map['title'],
        answer= map['answer'];



  Question.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$choice1:$choice2:$choice3:$choice4:$answer:$title>";
}

class MyAppQuestion extends StatelessWidget {
  final  String set;
  MyAppQuestion({Key key, this.set}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: QuestionPage (set: this.set),
    );
  }
}

class QuestionPage extends StatefulWidget {
  final  String set;
  QuestionPage({Key key, this.set}) : super(key: key);
    @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<QuestionPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  //final _scaffoldQKey = GlobalKey<ScaffoldState>();
  int _counterQuest = 0;
  int _score=0;
  PageController _pageview = new PageController();
  int _selectedItem = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedItem = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      key:_scaffoldKey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('ตอบคำถามในชุดที่ '+widget.set),
      ),
      body:
      _buildQuestion(context)
      ,


      bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.orange,
            primaryColor: Colors.white,
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: TextStyle(color: Colors.white)),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.orangeAccent,

            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.help, color: Colors.white,),
                label: 'ช่วยเหลือ',
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.reset_tv,color: Colors.white),
                label: 'เริ่มใหม่',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.queue_play_next,color: Colors.white),
                  label: 'ถัดไป'),

            ],
            currentIndex: _selectedItem,
            selectedItemColor: Colors.white,
            selectedLabelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),

            onTap:(_selectedItem){
              _onItemTapped(_selectedItem);
              if (_selectedItem==0){
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  duration: const Duration(seconds: 5),
                  backgroundColor: Colors.orange,
                  content:Container(

                      height:250,
                      color:Colors.white,child:
                  Column(children:[
                    Text('ช่วยเหลือ', style: TextStyle(color: Colors.black),),
                    Image.network("http://www.kidlovescode.com/gamebox/pic/playheart.gif", width:170),
                    Text('การทดสอบ ให้ตอบคำถามไปเรื่อยๆจนกระทั่งสิ้นสุดคำถาม ', style: TextStyle(color: Colors.black)),
                    Text('หากต้องการเปิดเสียงอ่านคำถามกดปุ่มด้านล่าง', style: TextStyle(color: Colors.black)),
                    IconButton(icon: Icon(Icons.play_circle_fill,size:40,color:Colors.red),
                        onPressed: null)
                  ])),
                ));
              }else  if (_selectedItem==1){
                  setState(() {
                    _counterQuest=0;

                  });
              }else  if (_selectedItem==2){
                 setState(() {
                   if (_counterQuest<10)
                     _counterQuest++;
                  if (_counterQuest==10){
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      duration: const Duration(seconds: 1),
                      backgroundColor: Colors.orange,
                      content:Container(

                          height:250,
                          color:Colors.white,child:
                      Column(children:[
                        Text('หมดคำถามเริ่มทำแบบทดสอบชุดใหม่', style: TextStyle(color: Colors.black),),
                        Image.network("http://www.kidlovescode.com/gamebox/pic/cool.gif", width:170),
                        FlatButton(onPressed: (){
                          //set,score,user
                          addScore('1',_score,'1');
                          Navigator.pop(context);
                        }, child: Text("กลับ"))
                      ])),
                    ));
                    Navigator.pop(context);
                  }

                 });
                 }else  if (_selectedItem==3){


              }
            },
          )),
    );

  }

  Widget _buildQuestion(BuildContext context){

    return //Column(children:[
      // Text("Upoint แพ็กเกจ EasyPoint\n ยินดีต้อนรับเข้าสู่ระบบจัดการคะแนนสำหรับร้ายค้า \n มีปัญหาในการใช้บริการติดต่อที่ upoint@kidlovescode.com\n"),
      _buildQuestInfo(context);

    //]);
  }
  _showSnackEnd(){
    if (_counterQuest==10) {

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.orange,
        content: Container(

            height: 250,
            color: Colors.white, child:
        Column(children: [
          Text('หมดคำถามกลับไปเลือกทำแบบทดสอบชุดใหม่',
            style: TextStyle(color: Colors.black),),
          Image.network(
              "http://www.kidlovescode.com/gamebox/pic/playheart.gif", width: 170),
          FlatButton(
              color:Colors.orange,
              onPressed: (){
            //set,score,user
       //     addScore('1',_score,'1');
        //    Navigator.pop(context);
          }, child: Text("ตกลง"))
        ])),
      ));
      addScore('1',_score,'1');
      Navigator.pop(context);
    }

  }

  Widget _buildQuestInfo(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('question_001')
          .where('set', isEqualTo: widget.set)
          .where('question', isEqualTo: (_counterQuest+1).toString())
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  _doAlert(context,msg) {

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              children: [
                Container(padding: EdgeInsets.all(10),
                    child: Text(msg,
                      style: TextStyle(fontSize: 20, color: Colors.red),)),
                Container(
                    width:MediaQuery.of(context).size.width/2,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child:

                    FlatButton(onPressed: (){
                    },
                        child: Column(children:[
                          Text('ปิด', style:TextStyle(color:Colors.white, fontWeight:FontWeight.bold ))
                          ,
                          IconButton(icon: Icon(Icons.close,color: Colors.white,),
                              onPressed: () {
                             //    Navigator.pop(context);
                              }
                          )
                        ])
                    )),


              ]);});
  }


  Future<void> addScore(set,score,user){
      CollectionReference checkoutinfo = Firestore.instance.collection(
          'topscore_001');

      var addinfo= checkoutinfo
          .add({
        'set': set,
        'topscore': score,
        'user':user,
        'timestamp' : Timestamp.now()

      })
          .then((value) =>  setState(() {


        print('Write score succeess');
      })
      )
          .catchError((error) => print("Failed to add score info: $error"));

  }
  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return
      ListView(

        padding: const EdgeInsets.only(top: 20.0),
        children: snapshot.map((data) => _buildListItem(context, data)).toList(),
      );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Question.fromSnapshot(data);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(

          child: Container(
              child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.all(30),
                      child:
                          Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),

                        height:130,
                        width:MediaQuery.of(context).size.width,
                      child: Column(children:[
                        ClipOval(
                         child:Container(
                           color: Colors.orange,
                            padding: EdgeInsets.all(8),
                            child:Text(

                          'คำถามที่ '+(_counterQuest+1).toString()+"/10",

                          style:TextStyle(fontSize:16,fontWeight: FontWeight.bold,color:Colors.white),
                            textAlign: TextAlign.center,))),
                         Padding(padding: EdgeInsets.only(bottom:10)),
                        Align(
                        alignment: Alignment.center,
                        child: Text(

                          record.title,
                          style:TextStyle(fontSize:20,fontWeight: FontWeight.w300),textAlign: TextAlign.center,),
                        ),

                      ]))),
                Container(


                  child:Column(children:[
                Row(children: [
                  FlatButton(child: Image.network(record.choice1 ,width:130),
                    onPressed: (){
                      //pressee  answer
                      setState(() {
                        if (_counterQuest <10)
                        _counterQuest++;
                        if (1== int.parse(record.answer)){
                           //correct answer
                          _score++;
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            duration: const Duration(seconds: 1),
                            backgroundColor: Colors.orange,
                            content:Container(

                                height:250,
                                color:Colors.white,child:
                            Column(children:[
                              Text('เยี่ยม', style: TextStyle(color: Colors.black),),
                              Image.network("http://www.kidlovescode.com/gamebox/pic/cool.gif", width:170),

                            ])),
                          ));


                        }
                        _showSnackEnd();
                      });
                    },),
                  FlatButton(child: Image.network(record.choice2 ,width:130),
                    onPressed: (){
                      setState(() {
                        if (_counterQuest <10)

                          _counterQuest++;
                        if (2 == int.parse(record.answer)){

                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            duration: const Duration(seconds: 1),
                            backgroundColor: Colors.orange,
                            content:Container(

                                height:250,
                                color:Colors.white,child:
                            Column(children:[
                              Text('เยี่ยม', style: TextStyle(color: Colors.black),),
                              Image.network("http://www.kidlovescode.com/gamebox/pic/cool.gif", width:170),

                            ])),
                          ));
                          _score++;
                        }
                      });
                      _showSnackEnd();
                    },),

                ],),
        Padding(padding: EdgeInsets.only(bottom:15)),
        Row(children: [
          FlatButton(child: Image.network(record.choice3 ,width:130),
            onPressed: (){
              //pressee  answer
              setState(() {
                if (_counterQuest <10)

                  _counterQuest++;
                print(int.parse(record.answer));

                if (3 == int.parse(record.answer)){
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    duration: const Duration(seconds: 1),
                    backgroundColor: Colors.orange,
                    content:Container(

                        height:250,
                        color:Colors.white,child:
                    Column(children:[
                      Text('เยี่ยม', style: TextStyle(color: Colors.black),),
                      Image.network("http://www.kidlovescode.com/gamebox/pic/cool.gif", width:170),

                    ])),
                  ));
                  _score++;
                }
              });
              _showSnackEnd();
            },),
          FlatButton(child: Image.network(record.choice4 ,width:130),
            onPressed: (){
              //pressee  answer
              setState(() {
                if (_counterQuest <10)

                  _counterQuest++;

                if (4 == int.parse(record.answer)){
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    duration: const Duration(seconds: 1),
                    backgroundColor: Colors.orange,
                    content:Container(

                        height:250,
                        color:Colors.white,child:
                    Column(children:[
                      Text('เยี่ยม', style: TextStyle(color: Colors.black),),
                      Image.network("http://www.kidlovescode.com/gamebox/pic/cool.gif", width:170),

                    ])),
                  ));

                  _score++;
                }
              });
              _showSnackEnd();
            },),

        ],)
          ]),
          )

    ])) ));
  }

}