import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:practise/Utils/Constraints.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class SearchMap extends StatefulWidget {
  @override
  _SearchMapState createState() => _SearchMapState();
}

class _SearchMapState extends State<SearchMap> {
  final _controller = TextEditingController();
  var uuid = new Uuid();
  String? _sessionToken;
  List<dynamic> _placeList = [];
  List<dynamic> _latlon = [];
  bool buscando = false;
  bool _loaderListView = false;
  String _startAddress = '';

  GoogleMapController? mapController;

  List<Marker> _markers = [];
  double? latfromMap;
  double? lonfromMap;
  getAddressFromLatLng() async {
    print("-----SEARCH MAP-----");
    List locations = await locationFromAddress(_controller.text);
    // print(locations);
    print(locations[0]);
    print(locations[0].latitude);
    print(locations[0].longitude);
    latfromMap = locations[0].latitude;
    lonfromMap = locations[0].longitude;
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _onChanged();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(_controller.text);
  }

  void getSuggestion(String input) async {
    String kPLACES_API_KEY = "AIzaSyDM8U1e_9FPJqaCu4Vv0YrMxj6vqEyWyiA";
    String type = 'country:Lk';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken&components=$type';

    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      setState(() {
        _placeList = json.decode(response.body)['predictions'];
      });

      for (var i in _placeList) {}
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Stack(children: [
              GoogleMap(
          markers: Set<Marker>.of(_markers),
          onMapCreated: onMapCreated,
          initialCameraPosition: _initialLocation,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          mapType: MapType.normal,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: false,
              ),
              SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 38.0),
              child: Column(
                children: <Widget>[
                  Align(
                    child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: TextField(
                          onTap: () {
                            _loaderListView = false;
                          },
                          controller: _controller,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                              borderSide: BorderSide(
                                color: kPrimaryBlueColor,
                                width: 1,
                              ),
                            ),
                            contentPadding: EdgeInsets.all(15),
                            hintText: 'Search Location',
                          ),
                        )),
                  ),
                  _loaderListView
                      ? Text("")
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _placeList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(_placeList[index]["description"]),
                              onTap: () {
                                print(_placeList[index]["description"]);
                                print("---------------------");
                                setState(() {
                                  _loaderListView = true;
                                  _controller.text =
                                      _placeList[index]["description"];
                                });
                                getAddressFromLatLng();
                                searchnavigate();
                              },
                            );
                          },
                        ),
                  Text(_controller.text),
                ],
              ),
            ),
          ),
              ),
              SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: RaisedButton(
                elevation: 0,
                hoverElevation: 0,
                focusElevation: 0,
                highlightElevation: 0,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                color: kPrimaryBlueColor,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.white,
                onPressed: (latfromMap != null)
                                  ? () async {
                                      _sendDataBack(context);
                                    }
                                  : null,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Add Points')
                    ],
                  ),
                ),
              ),
            ),
          ),
              ),
            ]),
        ));
  }

  searchnavigate() {
    locationFromAddress(_controller.text).then((result) {
      setState(() {
        Marker:
        _markers.add(Marker(
            markerId: MarkerId('SomeId'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            position: LatLng(result[0].latitude, result[0].longitude),
            infoWindow: InfoWindow(title: 'Your Search Location ')));
      });
      mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(result[0].latitude, result[0].longitude),
        zoom: 12,
      )));
    });
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _sendDataBack(BuildContext context) {
    Navigator.pop(context, {"lat": latfromMap, "lon": lonfromMap});
  }
}