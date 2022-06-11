import 'dart:developer';

import 'package:ea_frontend/localization/language_constants.dart';
import 'package:ea_frontend/models/event.dart';
import 'package:ea_frontend/models/user.dart';
import 'package:ea_frontend/routes/event_service.dart';
import 'package:ea_frontend/routes/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:localstorage/localstorage.dart';
import 'package:pr_geo/pr_geo.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ea_frontend/views/home.dart';

import '../../models/location.dart';
import '../event_page.dart';

class BuildMapDistance extends StatefulWidget {
  final Function? setMainComponent;
  final String? eventId;
  final String? modo;
  final Location? center;
  const BuildMapDistance({
    Key? key,
    this.modo,
    this.center,
    this.setMainComponent,
    this.eventId,
  }) : super(key: key);

  @override
  State<BuildMapDistance> createState() => _BuildMapState();
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.

      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

int range = 700000;
bool changeDistance = false;

class _BuildMapState extends State<BuildMapDistance> {
  final PopupController _popupController = PopupController();
  List<Marker> markers = [];
  List<Marker> userMarker = [];
  List<dynamic> _events = [];

  int pointIndex = 0;
  LatLng centerPoint = LatLng(0.0, 0.0);
  List points = [];

  Future<bool> getEvents() async {
    if (widget.modo == "UserEvent") {
      //Get events user
      String id = LocalStorage('BookHub').getItem('userId');
      _events = (await UserService.getUser(id)).events;
    } else {
      //Get all events
      _events = await EventService.getEvents();
    }

    Position userPosition = await _determinePosition();

    double userLatitude = userPosition.latitude;
    double userLongitude = userPosition.longitude;
    GeoCoordinate pointUser =
        GeoCoordinate(latitude: userLatitude, longitude: userLongitude);
    _events.forEach((element) {
      Event event = element;
      points.add(LatLng(event.location.latitude, event.location.longitude));
      GeoCoordinate pointEvent = GeoCoordinate(
          latitude: event.location.latitude,
          longitude: event.location.longitude);

      double totalDistance =
          PR_Geo.distance(pointUser, pointEvent); // distancia en metros

      if (totalDistance <= range) {
        markers.add(Marker(
          anchorPos: AnchorPos.align(AnchorAlign.center),
          height: 30,
          width: 30,
          point: LatLng(event.location.latitude, event.location.longitude),
          builder: (ctx) => const Icon(
            Icons.location_on,
            color: Colors.red,
          ),
        ));
      }
    });
    userMarker.add(Marker(
      anchorPos: AnchorPos.align(AnchorAlign.center),
      height: 30,
      width: 30,
      point: LatLng(userLatitude, userLongitude),
      builder: (ctx) => const Icon(
        Icons.location_on,
        color: Colors.blue,
      ),
    ));
    if (widget.center == null) {
      centerPoint = points[0];
    } else {
      centerPoint = LatLng(widget.center!.latitude, widget.center!.longitude);
    }
    if (_events != null) {
      return true;
    }
    return false;
  }

  String dropdownValue = '700Km';
  Widget buildLocationDistance(context, Function reload) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.red),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          if (newValue == '700Km') {
            range = 700000;
          } else if (newValue == '1000Km') {
            range = 1000000;
          } else if (newValue == '5000Km') {
            range = 5000000;
          } else if (newValue == 'All') {
            range = 12742000;
          } else if (newValue == '100Km') {
            range = 100000;
          }
          changeDistance = true;
          reload();
        });
      },
      items: <String>['100Km', '700Km', '1000Km', '5000Km', 'All']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<void> reload() async {
      Route route = MaterialPageRoute(builder: (context) => BuildMapDistance());
      Navigator.push(context, route);
    }

    return FutureBuilder(
        future: getEvents(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.data == true) {
            return Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.startTop,
              floatingActionButton: (widget.center != null)
                  ? FloatingActionButton(
                      backgroundColor: const Color.fromARGB(202, 255, 255, 255),
                      onPressed: () {
                        widget.setMainComponent!(EventPage(
                          setMainComponent: widget.setMainComponent,
                          elementId: widget.eventId,
                        ));
                      },
                      child: const Icon(Icons.arrow_back),
                    )
                  : null,
              body: FlutterMap(
                options: MapOptions(
                  center: centerPoint,
                  zoom: 5,
                  maxZoom: 15,
                  plugins: [
                    MarkerClusterPlugin(),
                  ],
                  onTap: (_, __) => _popupController
                      .hideAllPopups(), // Hide popup when the map is tapped.
                ),
                children: <Widget>[
                  TileLayerWidget(
                    options: TileLayerOptions(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                  ),
                  Column(
                    children: [
                      buildLocationDistance(context, reload),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                          heroTag: range++,
                          backgroundColor: Theme.of(context).indicatorColor,
                          onPressed: () {
                            if (changeDistance) {
                              changeDistance = false;
                              Route route = MaterialPageRoute(
                                  builder: (context) => Home());

                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                            } else {
                              Navigator.maybePop(context);
                            }
                          },
                          child: const Icon(Icons.chevron_left_rounded)),
                    ],
                  ),
                  MarkerClusterLayerWidget(
                      options: MarkerClusterLayerOptions(
                    spiderfyCircleRadius: 80,
                    spiderfySpiralDistanceMultiplier: 2,
                    circleSpiralSwitchover: 12,
                    maxClusterRadius: 120,
                    rotate: true,
                    size: Size(40, 40),
                    anchor: AnchorPos.align(AnchorAlign.center),
                    fitBoundsOptions: const FitBoundsOptions(
                      padding: EdgeInsets.all(50),
                      maxZoom: 5,
                    ),
                    markers: userMarker,
                    builder: (context, markers) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.cyan),
                        child: Center(
                          child: Text(
                            markers.length.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  )),
                  MarkerClusterLayerWidget(
                    options: MarkerClusterLayerOptions(
                      spiderfyCircleRadius: 80,
                      spiderfySpiralDistanceMultiplier: 2,
                      circleSpiralSwitchover: 12,
                      maxClusterRadius: 120,
                      rotate: true,
                      size: Size(40, 40),
                      anchor: AnchorPos.align(AnchorAlign.center),
                      fitBoundsOptions: const FitBoundsOptions(
                        padding: EdgeInsets.all(50),
                        maxZoom: 5,
                      ),
                      markers: markers,
                      polygonOptions: const PolygonOptions(
                          borderColor: Colors.blueAccent,
                          color: Colors.black12,
                          borderStrokeWidth: 3),
                      popupOptions: PopupOptions(
                        popupSnap: PopupSnap.markerTop,
                        popupController: _popupController,
                        popupBuilder: (_, marker) => Container(
                          width: 200,
                          height: 100,
                          child: GestureDetector(
                            onTap: () => debugPrint('Popup tap!'),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1),
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: Theme.of(context).backgroundColor),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: ListTile(
                                title: Text(
                                  _events[markers.indexOf(marker)].name,
                                  style: TextStyle(color: Colors.black),
                                ),
                                subtitle: Text(
                                    _events[markers.indexOf(marker)]
                                            .eventDate
                                            .day
                                            .toString() +
                                        "-" +
                                        _events[markers.indexOf(marker)]
                                            .eventDate
                                            .month
                                            .toString() +
                                        "-" +
                                        _events[markers.indexOf(marker)]
                                            .eventDate
                                            .year
                                            .toString(),
                                    style: TextStyle(color: Colors.black)),
                                onTap: () {
                                  widget.setMainComponent!(EventPage(
                                      setMainComponent: widget.setMainComponent,
                                      elementId:
                                          _events[markers.indexOf(marker)].id));
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      builder: (context, markers) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.cyan),
                          child: Center(
                            child: Text(
                              markers.length.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            log(snapshot.error.toString());
            print(snapshot.error);
            //   throw snapshot.error.hashCode;
          }
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).backgroundColor,
            ),
          );
        });
  }
}
