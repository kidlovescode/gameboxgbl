import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/one',
      routes: {
        '/one': (context) => PageOne(),
        '/two': (context) => PageTwo(),
      },
    );
  }
}

class PageOne extends StatelessWidget {

  final SnackBar _snackBar = SnackBar(
    content: const Text('Message from page one'),
    duration: const Duration(seconds: 5),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Woolha.com - Page one'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            OutlinedButton(
              child: Text('Go to page two'),
              onPressed: () {
                Navigator.pushNamed(context, '/two');
              },
            ),
            OutlinedButton(
              child: Text('Show message!'),
              onPressed: () {
                Scaffold.of(context).showSnackBar(_snackBar);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PageTwo extends StatelessWidget {

  final SnackBar _snackBar = SnackBar(
    content: Container(height:200,child: Text('Message from page two')),
    duration: const Duration(seconds: 5),
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Woolha.com - Page Two'),
      ),
      body: Builder(
          builder: (BuildContext context) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  OutlinedButton(
                    child: Text('Go to page one'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  OutlinedButton(
                    child: Text('Show message!'),
                    onPressed: () {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content:Container(height:200,color:Colors.blue,child: Text('Rahul Kushwaha!')),
                      ));
                    },
                  ),
                ],
              ),
            );
          }
      ),
    );
  }
}