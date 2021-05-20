import 'package:flutter/material.dart';
import 'squarePercentIndicator.dart';

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
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: MySquarePercentIndicator(
                width: 140,
                height: 140,
                startAngle: StartAngle.bottomRight,
                borderRadius: 12,
                shadowWidth: 1.5,
                animation: true,
                animationDuration: 2000,
                restartAnimation: false,
                // animateFromLastPercent: true,
                progressWidth: 5,
                shadowColor: Colors.grey,
                progressColor: Colors.blue,
                progress: 0.8,
                child: Center(
                  child: Text(
                    "80 %",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
            ),
            Center(
              child: MySquarePercentIndicator(
                width: 100,
                height: 100,
                startAngle: StartAngle.bottomRight,
                borderRadius: 20,
                shadowWidth: 1.5,
                animation: true,
                animationDuration: 750,
                restartAnimation: false,
                animateFromLastPercent: true,
                progressWidth: 2,
                shadowColor: Colors.grey,
                progressColor: Colors.red,
                progress: 0.5,
                child: Center(
                  child: Text(
                    "50 %",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
            ),
            Center(
              child: MySquarePercentIndicator(
                width: 200,
                height: 200,
                startAngle: StartAngle.bottomRight,
                borderRadius: 20,
                shadowWidth: 2.5,
                animation: true,
                animationDuration: 1000,
                restartAnimation: true,
                animateFromLastPercent: true,
                progressWidth: 4,
                shadowColor: Colors.red,
                progressColor: Colors.green,
                progress: 1.0,
                child: Center(
                  child: Text(
                    "100 %",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
