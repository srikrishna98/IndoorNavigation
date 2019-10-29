import 'package:flutter/material.dart';
import 'package:io_nav/models/wifiRequest.dart';
import 'package:wifi_flutter/wifi_flutter.dart';
import 'package:io_nav/apis.dart';
import 'package:io_nav/models/post.dart';
import 'package:io_nav/srcDestRoute.dart';
import 'package:io_nav/apis.dart';
import 'package:io_nav/models/locations.dart';
import 'dart:math';

final _backGroundColor = Colors.black;

class idLocationRoute extends StatefulWidget {
  const idLocationRoute();

  @override
  _idLocationRouteState createState() {
    return _idLocationRouteState();
  }
}

class _idLocationRouteState extends State<idLocationRoute> {
  double calculateDistance(int rssi) {
    int measuredPower = -69;
    int n = 2;
    int numerator = (measuredPower - rssi);
    int denominator = (10 * n);
    double powFactor = (numerator / denominator);
    print("RSSI: " + (powFactor).toString());
    print(pow(10, -powFactor) % 16);
    return pow(10, -powFactor) % 16;
  }

  void _navigateToSrcDestRoute(
      BuildContext context, List<Locations> sourceLocations) {
    Navigator.of(context).push(MaterialPageRoute<Null>(
      builder: (BuildContext context) {
        return srcDestRoute(srcLocs: sourceLocations);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    List<Wifis> _wifiNameRssi;

    final listView = Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Get my location',
            style: TextStyle(color: Colors.blueAccent, fontSize: 25),
          ),
          Center(
            child: IconButton(
              color: Colors.blue,
              splashColor: Colors.green,
              tooltip: 'Locate Me',
              icon: Icon(Icons.room),
              onPressed: () async {
                final noPermissions = await WifiFlutter.promptPermissions();
                if (noPermissions) {
                  return;
                }
                List<Wifis> WifiList=[];
                try {
                  final networks = await WifiFlutter.wifiNetworks;

                  List<WifiNetwork> wifiNetworks = networks.toList();
                  for (int i = 0; i < wifiNetworks.length; i++) {
                    WifiList.add(new Wifis(
                        mac: wifiNetworks[i].ssid,
                        distance: calculateDistance(wifiNetworks[i].rssi)));
                  }
                } catch (err) {
                  print(err);
                }

//                print("Wifi Objects Size" + WifiList[0].distance.toString());

                List<Locations> srcs = await Api().getWifiBasedLocations(WifiList);

                _navigateToSrcDestRoute(context, srcs);
              },
            ),
          ),
        ],
      ),
    );

    final appBar = AppBar(
      elevation: 0.0,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.scanner),
          color: Colors.yellow,
          splashColor: Colors.red,
          onPressed: () async {
            try {
              var scannedNetworks = await WifiFlutter.scanNetworks();
            } catch (err) {
              print(err.toString());
            }
            print('Scanned');
          },
        )
      ],
      title: Text(
        'Indoor Nav',
        style: TextStyle(fontSize: 30.0, color: Colors.blue),
      ),
      centerTitle: true,
      backgroundColor: Colors.black,
    );

    return Scaffold(
      appBar: appBar,
      body: listView,
    );
  }
}
