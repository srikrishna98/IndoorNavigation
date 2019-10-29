import 'package:flutter/material.dart';
import 'package:wifi_flutter/wifi_flutter.dart';
import 'package:io_nav/apis.dart';
import 'package:io_nav/models/post.dart';
import 'package:io_nav/models/locations.dart';
import 'package:io_nav/models/navigation.dart';
import 'package:io_nav/navTile.dart';

final _backGroundColor = Colors.black;

class srcDestRoute extends StatefulWidget {
  final List<Locations> srcLocs;

  srcDestRoute({Key key, @required this.srcLocs}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _srcDestRoute();
  }
}

class _srcDestRoute extends State<srcDestRoute> {
  List<Locations> destinations;
  List<Locations> sources;
  Locations _source;
  Locations _destination;
  List<Navigation> _navigation;
  bool pressed;
  String _destString,_srcString;
  bool _dpressed,_spressed;

  void setSources(List<Locations> srcs) {
    setState(() {
      sources = srcs;
    });
    print('Set Sources list');
  }

  void setDestinations() async {
    List<Locations> locations = await Api().getAllLocations();
    setState(() {
      destinations = locations;
    });

    print('Destinations obtained');
  }

  void setSource(Locations src) {
    setState(() {
      _source = src;
      _srcString = src.name;
      _spressed = true;
    });
  }

  void setDest(Locations dest) {
    setState(() {
      _destination = dest;
      _destString = dest.name;
      _dpressed = true;
    });
  }

  void setNavigation(List<Navigation> navs) {
    setState(() {
      _navigation = navs;
    });
  }

  @override
  Future initState() {
    super.initState();
    setDestinations();
    setSources(widget.srcLocs);
    pressed = false;
    _spressed = false;
    _dpressed = false;
  }

  Widget locationDropDown(List<Locations> locations, bool flag) {
//    flag 0 - Source 1 - Dest
    return new DropdownButtonHideUnderline(
      child: new DropdownButton<Locations>(
        iconSize: 40.0,
        elevation: 0,
        items: locations == null
            ? null
            : locations.map((Locations x) {
                return new DropdownMenuItem<Locations>(
                  value: x,
                  child: new Text(x.name),
                );
              }).toList(),
        hint: Text((flag ? (_dpressed?_destString:'Select Destination') :(_spressed?_srcString:'Select Source'))),
        onChanged: (newLocation) {
          if (flag == false) {
            setSource(newLocation);
            print(newLocation.name);
          } else {
            setDest(newLocation);
            print(newLocation.name);
          }
        },
      ),
    );
  }

  Widget _buildCategoryWidgets() {
    final _navigations = <NavTile>[];
    for (int i = 0; i < _navigation.length; i++) {
      _navigations.add(NavTile(
          code: _navigation[i].code,
          text: _navigation[i].text,
          time: _navigation[i].time));
    }
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) => _navigations[index],
      itemCount: _navigations.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> _wifiNameRssi;
//    _dpressed = false;
//    _spressed = false;
//    setSources(widget.srcLocs);

    final listView = Container(
      child: Padding(
        padding: const EdgeInsets.only(top:5.0,left:10.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 35.0),
                  child: Center(
                    child: Container(
                        decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border:
                                Border.all(color: Colors.blueGrey, width: 0.5)),
                        width: 250,
                        child: Center(child: locationDropDown(sources, false))),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left:35.0,top:10.0),
                  child: Center(
                    child: Container(
                        decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border:
                                Border.all(color: Colors.blueGrey, width: 0.5)),
                        width: 250,
                        child: Center(child: locationDropDown(destinations, true))),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Center(
                  child: Container(
                    width: 300.0,
                    alignment: Alignment.center,
                    child: Center(
                      child: RaisedButton(
                        child: Text('Go'),
                        color: Colors.blueAccent,
                        onPressed: () async {
                          pressed = true;
                          List<Navigation> nav =
                              await Api().postNavigation(_source.id, _destination.id);
                          setNavigation(nav);
                          print("Nav Length:" + nav.length.toString());
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
            pressed
                ? Expanded(
                    child: SizedBox(
                      height: 100.0,
                      child: _buildCategoryWidgets(),
                    ),
                  )
                : SizedBox()

          ],
        ),
      ),
    );

    final appBar = AppBar(
      elevation: 0.0,
      title: Text(
        'Navigation',
        style: TextStyle(fontSize: 30.0, color: Colors.blueAccent),
      ),
      centerTitle: true,
      backgroundColor: Colors.black87,
    );

    return Scaffold(
      appBar: appBar,
      body: listView,
    );
  }
}
