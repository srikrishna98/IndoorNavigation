import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

final _rowHeight = 100.0;
final _borderRadius = BorderRadius.circular(_rowHeight / 2);

class NavTile extends StatelessWidget {
  final String code;
  final String text;
  final int time;

  /// Creates a [Category].
  ///
  /// A [Category] saves the name of the Category (e.g. 'Length'), its color for
  /// the UI, and the icon that represents it (e.g. a ruler).
  // While the @required checks for whether a named parameter is passed in,
  // it doesn't check whether the object passed in is null. We check that
  // in the assert statement.
  const NavTile(
      {Key key, @required this.code, @required this.text, @required this.time})
      : assert(code != null),
        assert(text != null),
        assert(time != null),
        super(key: key);

  /// Navigates to the [ConverterRoute].
//  void _navigateToConverter(BuildContext context) {
//    Navigator.of(context).push(MaterialPageRoute<Null>(
//      builder: (BuildContext context) {
//        return Scaffold(
//          appBar: AppBar(
//            elevation: 1.0,
//            title: Text(
//              name,
//              style: Theme.of(context).textTheme.display1,
//            ),
//            centerTitle: true,
//            backgroundColor: color,
//          ),
//          body: ConverterRoute(
//            color: color,
//            units: units,
//          ),
//        );
//      },
//    ));
//  }
  IconData getIcon(String code) {
    switch (code) {
      case "L":
        return Icons.keyboard_arrow_left;
      case "R":
        return Icons.keyboard_arrow_right;
      case "F":
        return Icons.keyboard_arrow_up;
      case "S":
        return Icons.person_pin_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: _rowHeight,
        child: InkWell(
          borderRadius: _borderRadius,
          highlightColor: Colors.black54,
          splashColor: Colors.blueAccent,
          onTap: () => {
            Navigator.of(context)
                .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
              return new MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  body: Center(
                    child: Container(
                      color: Colors.black,
                      child: Center(
                        child: Text(
                          time.toString()+' Seconds away\n',
                          style: TextStyle(fontSize: 30.0,color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }))
          },
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(
                    getIcon(this.code),
                    size: 40.0,
                  ),
                ),
                Center(
                  child: Text(
                    this.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
