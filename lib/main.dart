import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Coverflow Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
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
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text('Coverflow Demo'),
      ),
      body: new CoverFlow(widgetBuilder,
          disposeDismissed), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget widgetBuilder(BuildContext context, int index) {
    if (data.length == 0) {
      return new Container();
    } else {
      return data[index % data.length];
    }
  }

  disposeDismissed(int index, DismissDirection direction) {
    data.removeAt(index);
  }
}

typedef void OnDismissedCallback(
    int itemDismissedIndex, DismissDirection direction);

class CoverFlow extends StatefulWidget {
  IndexedWidgetBuilder itemBuilder;
  OnDismissedCallback dismissedCallback;

  CoverFlow(this.itemBuilder, this.dismissedCallback);

  @override
  _CoverFlowState createState() => new _CoverFlowState();
}

class _CoverFlowState extends State<CoverFlow> {
  PageController controller;
  int currentPage = 0;
  bool _pageHasChanged = false;

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
            _pageHasChanged = true;
            currentPage = value;
          });
        },
        controller: controller,
        itemBuilder: (context, index) => builder(index));
  }

  builder(int index) {
    return new AnimatedBuilder(
        animation: controller,
        builder: (context, Widget child) {
          double result = _pageHasChanged ? controller.page : 0.0;
          double value = result - index;

          value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);

          return new Dismissible(
            key: ObjectKey(child),
            direction: DismissDirection.vertical,
            child: new Center(
              child: new SizedBox(
                height: Curves.easeOut.transform(value) * 525,
                width: Curves.easeOut.transform(value) * 700,
                child: child,
              ),
            ),
            onDismissed: (direction) {
              setState(() {
                widget.dismissedCallback(currentPage, direction);
                controller.animateToPage(currentPage,
                    duration: new Duration(seconds: 2), curve: Curves.easeOut);
              });
            },
          );
        },
        child: widget.itemBuilder(context, index));
  }
}
