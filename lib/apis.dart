import 'dart:async';
import 'dart:convert' show utf8, json;
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:io_nav/models/post.dart';
import 'package:io_nav/models/navigation.dart';
import 'package:io_nav/models/locations.dart';
import 'package:io_nav/models/wifiRequest.dart';

class Api {
  final httpClient = HttpClient();
  final url = 'http://192.168.137.46:8080';

  Future<Post> getPost() async {
    String uri = 'https://jsonplaceholder.typicode.com/posts/';
    final response = await http.get(uri);
    return postFromJson(response.body);
  }

//  /navigate
  Future<List<Navigation>> getNavigation() async {
    String uri = '/navigate';
//      Get request
    final response = await http.get('$url' + '$uri');
    List<Navigation> navs = navigationFromJson((response.body));
    if(navs.length>1)
      return navs;
    else {
      Navigation navigation = new Navigation(text: "No Route Available",time: 0,code: "S");
      List<Navigation> navList;
      navList.add(navigation);
      return navList;
    }

  }

  Future<List<Navigation>> postNavigation(int src, int dest) async {
    String uri = '/navigate';
//    Post Request
    final response = await http.post('$url' + '$uri',
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body:json.encode({"source": src, "destination": dest}));

    return navigationFromJson(response.body);
  }

//  /getAllLocationList
  Future<List<Locations>> getAllLocations() async {
    String uri = '/getAllLocationList';
    final response = await http.get('$url' + '$uri',
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    print("Request to getAllLocations: " + response.statusCode.toString());
    return locationsFromJson(response.body.replaceAll(" ", ""));
  }

// /getWifiBasedLocations
  Future<List<Locations>> getWifiBasedLocations(
      List<Wifis> wifis) async {
    print("WIFIS LENGTH IN API "+wifis.length.toString());
    String uri = '/getWifiBasedLocations';
    final response = await http.post('$url' + '$uri',
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: json.encode({"wifis":wifis}));

  return locationsFromJson(response.body.replaceAll(" ",""));
  }

}
