import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new CoverFlow([new Container(color: Colors.deepOrangeAccent),
      new Container(color: Colors.blue),
      new Container(color: Colors.amber),
      new Container(color: Colors.deepPurpleAccent)]),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
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
        try {
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
        } catch (ArgumentError) {
          // Trying to build before everything has been initialized
          return new Container();
        }

      },
      child: widget.displayCovers[index % widget.displayCovers.length],
    );
  }
}

