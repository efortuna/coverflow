import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text('coverflow demo'),
      ),
      body: new CoverFlow([new Container(color: Colors.deepOrangeAccent),
      new Container(color: Colors.blue),
      new Container(color: Colors.amber),
      new Container(color: Colors.deepPurpleAccent)]), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


class CoverFlow extends StatefulWidget {
  List displayCovers;
  CoverFlow(this.displayCovers);

  @override
  _CoverFlowState createState() => new _CoverFlowState();
}

class _CoverFlowState extends State<CoverFlow> {
  PageController controller;
  int currentpage = 0;


  @override
  initState() {
    super.initState();
    controller = new PageController(viewportFraction: .65);
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new PageView.builder(
        onPageChanged: (value) {
          setState(() {
            currentpage = value;
          });
        },
        controller: controller,
        itemBuilder: (context, index) => builder(index));
  }

  builder(int index) {
    return new AnimatedBuilder(
      animation: controller,
      builder: (context, Widget child) {
        double result = 0.0;
        //if (controller.hasClients) {
          result = controller.page;
          double value = result - index;

          value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);

          return new Dismissible(
            key: ObjectKey(child),
            direction: DismissDirection.vertical,
            child: new Center(
              child: new SizedBox(
                height: Curves.easeOut.transform(value) * 300,
                width: Curves.easeOut.transform(value) * 400,
                child: new Stack(children: [
                  child,
                  new Container(color: Colors.transparent), ]),

              ),
            ),
            onDismissed: (direction) {
              setState(() {
                controller.nextPage(duration: new Duration(seconds: 1), curve: Curves.easeOut);
                widget.displayCovers.removeAt(0);
              });
            },
          );
        //}
        return new Container();

      },
      child: widget.displayCovers[index % widget.displayCovers.length],
    );
  }
}

