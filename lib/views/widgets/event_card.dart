import 'package:ea_frontend/models/location.dart';
import 'package:ea_frontend/views/event_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String numberUsers;
  final Location location;
  final bool admin;
  final Function? setMainComponent;
  final String id;
  EventCard({
    required this.title,
    required this.date,
    required this.numberUsers,
    required this.location,
    required this.admin,
    required this.setMainComponent,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      width: 300,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white, width: 2.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            offset: const Offset(
              0.0,
              10.0,
            ),
            blurRadius: 10.0,
            spreadRadius: -6.0,
          ),
        ],
      ),
      child: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: LatLng(location.latitude,
                  location.longitude),
              zoom: 13.0,
              onTap: (TapPosition, LatLng) {
                setMainComponent!(EventPage(
                  setMainComponent:
                      setMainComponent,
                  elementId: id)
                );
              },
            ),
            layers: [
              TileLayerOptions(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayerOptions(
                markers: [
                  Marker(
                    anchorPos: AnchorPos.align(AnchorAlign.center),
                    width: 30.0,
                    height: 30.0,
                    point: LatLng(location.latitude,
                        location.longitude),
                    builder: (ctx) => Icon(
                      Icons.location_on,
                      color: Theme.of(context).backgroundColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Align(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            alignment: Alignment.topCenter,
          ),
          Align(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  date,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            alignment: Alignment.bottomCenter,
          ),
          Align(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.people,
                        color: Colors.orange,
                        size: 18,
                      ),
                      const SizedBox(width: 7),
                      Text(numberUsers),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ],
            ),
            alignment: Alignment.bottomLeft,
          ),
          admin ? Align(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.orange,
                    size: 18,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ],
            ),
            alignment: Alignment.bottomRight,
          )
          : const SizedBox(height: 0)
        ],
      ),
    );
  }
}
