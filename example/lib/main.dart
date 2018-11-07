import 'package:flutter/material.dart';
import 'package:simple_coverflow/simple_coverflow.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  static List<Container> data = [
    new Container(color: Colors.orange),
    new Container(color: Colors.blue),
    new Container(color: Colors.amber),
    new Container(color: Colors.deepPurple),
    new Container(color: Colors.green),
    new Container(color: Colors.red),
    new Container(color: Colors.yellow),
    new Container(color: Colors.greenAccent),
    new Container(color: Colors.black)
  ];

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Coverflow Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text('Coverflow Demo'),
          ),
          body: new CoverFlow(itemBuilder: widgetBuilder,
              dismissedCallback: disposeDismissed,
              currentItemChangedCallback: (int index) {print(index);})
      ),
    );
  }

  Widget widgetBuilder(BuildContext context, int index) {
    if (data.length == 0) {
      return new Container();
    } else {
      return data[index % data.length];
    }
  }

  disposeDismissed(int item, DismissDirection direction) {
    data.removeAt(item % data.length);
  }
}
