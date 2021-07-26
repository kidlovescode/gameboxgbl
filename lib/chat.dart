import 'package:chat_list/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(ChatApp());

class ChatApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
       primarySwatch: Colors.deepOrange,
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: MyChatHomePage(title: 'ห้องพูดคุย'),
    );
  }
}

class MyChatHomePage extends StatefulWidget {
  MyChatHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyChatHomePage> {
  String newmessage;
  int loadchat = 0;
  final ScrollController _scrollController = ScrollController();
  final _txtcontroller = TextEditingController();
  bool _focused = true, _sendMsg = false;
  FocusNode  _node;
  FocusAttachment _nodeAttachment;
  String InputText="";
  bool _show = true;

  @override
  void initState() {

    super.initState();


    _node = FocusNode(debugLabel: 'TextFormField');
    _node.addListener(_handleFocusChange);
    //_nodeAttachment = _node.attach(context, onKey: );
    _buildMSGInfo();
  }
  void _handleFocusChange() {
    if (_node.hasFocus == _focused && _sendMsg ==true) {
      setState(() {
        _node.unfocus();
      });
    }else if (_sendMsg == false){
      _node.hasFocus;


    }
  }

 Widget _buildMSGInfo() {

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('message_001')
        //  .orderBy('timestamp' , descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return  _buildList(context, snapshot.data.documents);
      },
    );
  }


  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Message.fromSnapshot(data);
    return Container(

      child:
       record.user!='1'? Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
          Row(children:[
            Image.asset("images/kid.jpeg",width:30),
            Expanded(child:Container(
              alignment: Alignment.centerLeft,
              width:MediaQuery.of(context).size.width,child:ClipOval(child: Container(padding: EdgeInsets.all(10),
            child:Text(record.user,style: TextStyle(fontSize: 16)))))),

          ]),
        Container(
            decoration: BoxDecoration(
              border: Border.all(color:Colors.orange),
                ),
            alignment: Alignment.centerLeft,
            padding:EdgeInsets.all(8),
            width:MediaQuery.of(context).size.width*0.7,
            child:Text(record.content, style: TextStyle(fontSize: 16),)),

      ]): Column(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children:[
                 Row(children:[
                   Expanded(child:Container(
                       alignment: Alignment.centerRight,
                       width:MediaQuery.of(context).size.width,child:ClipOval(child: Container(padding: EdgeInsets.all(10),
                       child:Text(record.user,style: TextStyle(fontSize: 16)))))),
                   Image.asset("images/kid.jpeg",width:30),

                 ]),    Container(alignment: Alignment.centerRight,width:MediaQuery.of(context).size.width,
        padding:EdgeInsets.all(8),child:  Text(record.content,style: TextStyle(fontSize: 16))),

           ])
       ,



    );
  }
  _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
     // controller: _scrollBottomBarController,
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );














  }



  @override
  Widget build(BuildContext context) {

    return MaterialApp(home:Scaffold(

      appBar: AppBar(
         leading: Builder(
           builder: (BuildContext context) {
             return IconButton(
               icon: const Icon(Icons.home),
               onPressed: () {
                 //Scaffold.of(context).openDrawer();
                 Navigator.pop(context);
               },
              // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
             );
           },
         ),
         title: Text('ห้องแชท'),
           ) ,
        body:Center(child:SingleChildScrollView(
            controller:  _scrollController ,
            child:
            Container(child:Column(
              children: [
                Container(
                  height:MediaQuery.of(context).size.height *.80,
               //   color:Colors.orange[200],
                  child: _buildMSGInfo(),
               ),
                Container(
                    height: MediaQuery.of(context).size.height *.10,
                    color: Colors.deepOrange,
                    child: Row(children: [
                      Container(
                          child:IconButton(icon:Icon(Icons.image, color: Colors.white,))),
                      Expanded(child:Container(
                          padding: EdgeInsets.only( bottom: 5),
                          child:     TextField(
                            controller: _txtcontroller,
                            onSubmitted: (String inputText) {
                              setState(() {
                               InputText = inputText;

                                AddMessage("Learner",inputText.toString());
                                _onNewMessage();
                              });

                              _txtcontroller.clear();
                            },
                            decoration: InputDecoration(

                              fillColor: Colors.grey,
                              border: OutlineInputBorder(

                                borderRadius: BorderRadius.circular(15),
                              ),

                            ),
                          ))),

                      Container(
                          child: IconButton(icon:Icon(Icons.send, color: Colors.white,),
                            onPressed: (){
                              AddMessage("Learner",InputText);

                              setState(){
                                _sendMsg=true;
                                _handleFocusChange();
                                _txtcontroller.clear();
                                _onNewMessage();
                                _sendMsg=false;
                              };
                            },
                          )),
                    ],)),
              ],
            )
            )),
        )));
  }
  void _onNewMessage() {

    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
  }
  Future<void> AddMessage(user,content) {
    CollectionReference checkoutinfo = Firestore.instance.collection(
        'message_001');

    var addinfo= checkoutinfo
        .add({
      'user': user,
      'content': content,
      'timestamp' : Timestamp.now()

    })
        .then((value) =>  setState(() {


      print('Write roomCheckout succeess');
    })
    )
        .catchError((error) => print("Failed to add info: $error"));
  }

}

class Message {
  final String content,user,timestamp;
  final DocumentReference reference;

  Message.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['content'] != null),
        assert(map['user'] != null),
        assert(map['timestamp'] != null),


        content = map['content'],
        user = map['user'],
        timestamp = map['timestamp'].toString()

  ;

  Message.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$content:$user:$timestamp>";
}