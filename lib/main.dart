import 'dart:math' as math;
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
      home: new MyHomePage(title: 'Reverse ListView Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  List<Widget> widgets = [];

  @override
  initState() {
    super.initState();
    var intro = buildHelperIntro();
    widgets.insert(0, intro);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        title: new Text(widget.title),
      ),
      body: Container(
        color: Colors.black12,  // Why doesn't this fill the full ListView?
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemBuilder: (_, index) => widgets[index],
                itemCount: widgets.length,
              ),
            ),
            Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHelperIntro() {
    return Container(
      color: Colors.black12,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 8.0),
                  color: Color(0xFF2196F3),
                  child: Text(
                    "Hi! Try clicking an option below.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Options(
            [
              "Option number 1",
              "Option number 2",
              "Option number 3",
              "Option number 4",
              "Option number 5",
            ],
            _addRequest,
          ),
        ],
      ),
    );
  }

  void _addRequest(String text) {
    setState(() {
      widgets.insert(0, Text(text));
    });
  }

  updateSubmitButton() {
    if (!mounted) {
      return;
    }
    setState(() {
      // Force evaluation of _textController state.
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    FocusScope.of(context).requestFocus(new FocusNode()); // dismiss keyboard.
    updateSubmitButton();
    _addRequest(text);
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        height: 60.0,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(children: <Widget>[
          Flexible(
            child: Card(
              color: Colors.white,
              shape: const RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _textController,
                  onChanged: (String text) {
                    updateSubmitButton();
                  },
                  onSubmitted: _handleSubmitted,
                  decoration: InputDecoration.collapsed(
                    hintText: "Start typing...",
                  ),
                ),
              ),
            ),
          ),
          Container(
              child: IconButton(
            icon: Icon(Icons.send, color: Color(0xFF2196F3)),
            onPressed: _textController.text.length > 0
                ? () => _handleSubmitted(_textController.text)
                : null,
          )),
        ]),
      ),
    );
  }
}

typedef StringCallback(String text);

class Options extends StatelessWidget {
  final List<String> requests;
  final StringCallback addRequest;

  Options(this.requests, this.addRequest);

  @override
  Widget build(BuildContext context) {
    var children = List.generate(
        2 * requests.length - 1,
        (int index) => index % 2 == 0
            ? _SingleRequest(requests[index ~/ 2], addRequest)
            : Divider(color: Colors.black));

    return CustomPaint(
      painter: _DrawArc(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
        child: Card(
          elevation: 10.0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}

class _SingleRequest extends StatelessWidget {
  final String request;
  final StringCallback addRequest;

  _SingleRequest(this.request, this.addRequest);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        addRequest(request);
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 3.0),
            child: CircleAvatar(
              radius: 10.0,
              backgroundColor: Color(0xFF2196F3),
              child: CircleAvatar(
                radius: 6.0,
                backgroundColor: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 6.0, 0.0, 4.0),
            child: Text(
              request,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawArc extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const padH = 52.0;
    var paint = Paint()..color = Color(0xFF2196F3);
    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, size.width, padH), paint);
    final h = 0.1 * size.height;
    canvas.drawArc(Rect.fromLTWH(0.0, -0.5 * h + padH, size.width, h), 0.0,
        math.pi, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
