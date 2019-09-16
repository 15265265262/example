import 'package:flutter_web/material.dart';
import 'expand_search.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
     home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            HeaderView(),
          ],
        ),
      ),
    );
  }
}

class HeaderView extends StatefulWidget {
  HeaderView({Key key}) : super(key: key);

  createState() => HeaderViewState();
}

class HeaderViewState extends State<HeaderView> {
  String title ;

  @override
  Widget build(BuildContext context) {

    return Material(
        child: SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 800,
      child: Padding(
          padding: EdgeInsets.only(left: 50.0, right: 50.0),
          child: Column(
            children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                              child: Container(
                                  padding: EdgeInsets.all(0.5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 0.5),
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.grey),
                                  child: ExpandSearch(
                                    width: 200,
                                    fixedH: 250,
                                    list: ['Flutter-01', 'Flutter-02', 'Flutter-03'],
                                    callback: (value) {
                                      setState(() {
                                        title = value;
                                      });
                                    },
                                  ))),
                        ],
                      )),
                  Center(
                    child: Text(title == null ? ' No Data': title),
                  )
            ],
          )),
    ));
  }
}
